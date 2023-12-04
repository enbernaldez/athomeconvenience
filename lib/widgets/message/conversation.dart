import 'package:athomeconvenience/model/indiv_message.dart';
import 'package:athomeconvenience/widgets/buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Conversation extends StatefulWidget {
  final String? docId;
  final String shopName;
  final String shopId;

  const Conversation(
      {Key? key, this.docId, required this.shopName, required this.shopId})
      : super(key: key);

  @override
  State<Conversation> createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  final TextEditingController chatTextFieldController = TextEditingController();
  String? chatDocId;

  @override
  void initState() {
    super.initState();
    if (widget.docId != null) {
      setState(() {
        chatDocId = widget.docId;
      });
    }
  }

  Future<void> _sendMessage() async {
    String message = chatTextFieldController.text.trim();
    if (message.isNotEmpty) {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      try {
        if (chatDocId != null) {
          // ! =========== IF CHAT ALREADY EXIST ==================
          DocumentReference chatDoc =
              FirebaseFirestore.instance.collection('chats').doc(chatDocId);

          CollectionReference messagesCollection =
              chatDoc.collection('messages');

          Timestamp timeSent = Timestamp.now();

          await messagesCollection.add({
            'is_read': false,
            'message_text': message,
            'receiver_id': widget.shopId,
            'sender_id': uid,
            'timestamp': timeSent,
          });

          await chatDoc.update({
            'latest_chat_message': message,
            'latest_chat_user': uid,
            'latest_timestamp': timeSent,
          });

          print('message sent successfully');
          sendNotification();
        } else {
          // ! ========== IF CHAT IS A NEW CONVERSATION ==========
          try {
            CollectionReference chatsCollection =
                FirebaseFirestore.instance.collection('chats');

            Timestamp timeSent = Timestamp.now();

            // Create a new chat document and get its reference
            DocumentReference newChatDocRef = await chatsCollection.add({
              'users_id': [uid, widget.shopId],
              'composite_id': '${uid}_${widget.shopId}',
              'latest_chat_message': message,
              'latest_chat_user': uid,
              'latest_timestamp': timeSent,
            });

            // Get the ID of the newly created chat document
            String newChatDocId = newChatDocRef.id;

            // Create a messages subcollection for the new chat
            CollectionReference messagesCollection =
                newChatDocRef.collection('messages');

            // Add the initial message to the messages subcollection
            await messagesCollection.add({
              'is_read': false,
              'message_text': message,
              'receiver_id': widget.shopId,
              'sender_id': uid,
              'timestamp': timeSent,
            });

            setState(() {
              chatDocId = newChatDocId;
            });

            sendNotification();
          } catch (e) {
            print("error sending message: $e");
          }
        }
      } catch (e) {
        print("error sending msg: $e");
      }

      chatTextFieldController.clear();

      // !======== SEND A NOTIF=================
    }
  }

  Future<void> sendNotification() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final today = Timestamp.now();

    // Query to check if a notification has been sent today for a message
    QuerySnapshot<Map<String, dynamic>> existingNotification =
        await FirebaseFirestore.instance
            .collection('notification')
            .where('from_uid', isEqualTo: uid)
            .where('is_message', isEqualTo: true)
            .where('dateTime',
                isGreaterThanOrEqualTo: Timestamp(today.seconds, 0))
            .get();

    if (existingNotification.docs.isEmpty) {
      // If no notification has been sent for a message today, proceed with sending a new notification
      try {
        // Rest of your existing message sending logic

        // After sending the message, create a notification
        await FirebaseFirestore.instance.collection('notification').add({
          'chat_doc_id': chatDocId ?? '',
          'dateTime': today,
          'from_uid': uid,
          'is_agreement': false,
          'is_message': true,
          'is_rate': false,
          'is_read': false,
          'notif_msg': 'messaged you.',
          'user_doc_id': widget.shopId,
        });
      } catch (e) {
        print("error sending message: $e");
      }
    } else {
      print("Notification already sent for a message today");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackArrow(),
        titleSpacing: 0,
        title: Text(
          widget.shopName,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(
                Icons.share_location_rounded,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('chats')
              .doc(chatDocId)
              .collection('messages')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            List<IndividualMessage> msg = snapshot.data!.docs.map((messageDoc) {
              return IndividualMessage(
                msgDocId: messageDoc.id,
                messageText: messageDoc['message_text'],
                receiverId: messageDoc['receiver_id'],
                senderId: messageDoc['sender_id'],
                timestamp: messageDoc['timestamp'],
              );
            }).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    itemCount: msg.length,
                    itemBuilder: (BuildContext context, int index) {
                      bool isCurrentUser = msg[index].senderId ==
                          FirebaseAuth.instance.currentUser!.uid;
                      // ===================== Time Display =====================
                      DateTime timeReceived = msg[index].timestamp.toDate();

                      DateTime now = DateTime.now();
                      bool isToday = now
                              .difference(msg[index].timestamp.toDate())
                              .inDays ==
                          0;
                      String formattedDateTime = (isToday)
                          ? DateFormat('hh:mm a').format(timeReceived)
                          : (timeReceived.isAfter(
                              now.subtract(
                                Duration(days: 7),
                              ),
                            ))
                              ? DateFormat('EEE \'at\' hh:mm a')
                                  .format(timeReceived)
                              : (timeReceived.isAfter(
                                  DateTime(now.year - 1, now.month, now.day),
                                ))
                                  ? DateFormat('MMM d \'at\' hh:mm a')
                                      .format(timeReceived)
                                  : DateFormat('MM/dd/yy \'at\' hh:mm a')
                                      .format(timeReceived);
                      bool seeTime = false;
                      // ========================================================

                      return ListTile(
                        title: Container(
                          alignment: isCurrentUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: isCurrentUser
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.sizeOf(context).width * 0.80,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isCurrentUser
                                        ? Colors.blueAccent
                                        : Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    msg[index].messageText,
                                    style: TextStyle(
                                      color: isCurrentUser
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 4.0,
                              ),
                              Text(formattedDateTime,
                                  style: GoogleFonts.dmSans(fontSize: 11))
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: TextField(
                      controller: chatTextFieldController,
                      minLines: 1,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.grey),
                        contentPadding: const EdgeInsets.all(8),
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: _sendMessage,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
