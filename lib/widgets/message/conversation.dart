import 'package:athomeconvenience/model/indiv_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
          'notif_msg': 'Messaged you.',
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
        title: Text(
          widget.shopName,
          style: Theme.of(context).textTheme.headline6,
        ),
        centerTitle: true,
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

                      return ListTile(
                        title: Container(
                          alignment: isCurrentUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
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
                                color:
                                    isCurrentUser ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  color: Colors.grey[200],
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: chatTextFieldController,
                          decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _sendMessage,
                      ),
                    ],
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
