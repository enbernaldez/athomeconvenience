import 'package:athomeconvenience/functions/functions.dart';
import 'package:athomeconvenience/model/indiv_message.dart';
import 'package:athomeconvenience/widgets/buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Conversation extends StatefulWidget {
  final String? docId;
  final String shopName;
  final String shopId;
  final String? shopHours;

  const Conversation(
      {Key? key,
      this.docId,
      required this.shopName,
      required this.shopId,
      this.shopHours})
      : super(key: key);

  @override
  State<Conversation> createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  final TextEditingController chatTextFieldController = TextEditingController();
  String? chatDocId;

  late bool servicePermission = false;
  late LocationPermission permission;

  String? lat;
  String? long;

  String? locDataDocId;
  bool activeLocation = false;

  bool open = true; //for business hours

  final String pre1 = "How much does the service fee cost?";
  final String pre2 = "How long will the service take?";
  final String pre3 = "When are you available to perform the service?";

  Map<String, dynamic> shopData = {};

  @override
  void initState() {
    super.initState();
    fetchShopData();
    if (widget.docId != null) {
      setState(() {
        chatDocId = widget.docId;
      });
    }
  }

//! alert for when SP acc is disabled, not used yet
  void disableAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Text("Unavailable"),
          contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          content: const Text(
              "SP is unavailable at this moment. They will not be notified of your messages, but they will still receive them."),
          actionsPadding: const EdgeInsets.all(8.0),
          actions: [
            DialogButton(
              onPress: () => Navigator.pop(context),
              buttonText: "OK",
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              widget.shopName,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Visibility(
            //   visible: true, //! visible only when SP acc is disabled
            //   child: Text(
            //     "Unavailable",
            //     style: GoogleFonts.poppins(
            //       fontSize: 11,
            //       fontWeight: FontWeight.normal,
            //       color: Colors.grey,
            //     ),
            //   ),
            // ),
          ],
        ),
        centerTitle: true,
        actions: [
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatDocId)
                  .collection('location')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  QueryDocumentSnapshot firstDoc = snapshot.data!.docs.first;
                  Map<String, dynamic> data =
                      firstDoc.data() as Map<String, dynamic>;
                  String docId = firstDoc.id; // Retrieve the document ID
                  String agreementDocId = '';
                  String agreementStatus = '';

                  bool isActive = data['active'] ?? false;

                  String shopUID = data['shop_id'];
                  String fromUserId = data['user_id'];

                  return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chats')
                          .doc(chatDocId)
                          .collection('agreement')
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot2) {
                        // String agreementStatus = '';
                        // Map<String, dynamic> agreementData = {};
                        if (snapshot2.hasData &&
                            snapshot2.data!.docs.isNotEmpty) {
                          QueryDocumentSnapshot agreementFirstDoc =
                              snapshot2.data!.docs.first;
                          Map<String, dynamic> agreementData =
                              agreementFirstDoc.data() as Map<String, dynamic>;
                          agreementDocId = agreementFirstDoc.id;

                          agreementStatus = agreementData['status'] ?? '';
                          print(
                              'this is the status:${agreementData['status']}');
                          print('this is the snapshot:${agreementData}');
                        }
                        return PopupMenuButton<String>(
                          icon: const Icon(
                              Icons.more_vert), // Icon for the button
                          itemBuilder: (BuildContext context) {
                            List<PopupMenuEntry<String>> items = [];

                            if (shopUID !=
                                FirebaseAuth.instance.currentUser!.uid) {
                              if (!isActive) {
                                items.add(
                                  const PopupMenuItem<String>(
                                    value: 'sharelocation',
                                    child: Text('Share my location'),
                                  ),
                                );
                              } else {
                                items.add(
                                  const PopupMenuItem<String>(
                                    value: 'endlocation',
                                    child: Text('Turn off Location'),
                                  ),
                                );
                              }
                            }

                            if (agreementStatus == 'Active' &&
                                fromUserId ==
                                    FirebaseAuth.instance.currentUser!.uid) {
                              items.add(
                                const PopupMenuItem<String>(
                                  value: 'endagreement',
                                  child: Text('End Agreement'),
                                ),
                              );
                            }
                            if (agreementStatus == 'Pending' &&
                                shopUID ==
                                    FirebaseAuth.instance.currentUser!.uid) {
                              items.add(
                                const PopupMenuItem<String>(
                                  value: 'endagreement',
                                  child: Text('End Agreement'),
                                ),
                              );
                            }

                            return items;
                          },
                          onSelected: (String value) {
                            switch (value) {
                              case 'sharelocation':
                                getCurrentLocation().then((value) async {
                                  if (value != null) {
                                    lat = '${value.latitude}';
                                    long = '${value.longitude}';
                                    print('line 214: $lat, $long');
                                    await setUserLocationInFirestore(
                                      FirebaseAuth.instance.currentUser!.uid,
                                      widget.shopId,
                                      double.parse(lat!),
                                      double.parse(long!),
                                    );
                                  } else {
                                    showToast(
                                        "You need to enable location to share");
                                  }
                                });
                                liveLocation();
                                startAgreement(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    widget
                                        .shopId); //! START AN AGREEMENT WHEN USER SHARES LOCATION
                                break;
                              case 'endlocation':
                                if (agreementStatus.isNotEmpty &&
                                    agreementStatus == 'Paid') {
                                  stopSharingLocation(docId);
                                } else {
                                  showToast(
                                      "Please settle your agreement before turning off location");
                                }
                                break;
                              // Handle additional cases if needed
                              case 'endagreement':
                                confirmEndAgreement(
                                    context, agreementDocId, fromUserId);
                                setState(() {
                                  agreementDocId = '';
                                });
                                break;
                            }
                          },
                        );
                      });
                }
                return PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert), // Icon for the button
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'sharelocation',
                      child: Text('Share Location'),
                    ),
                  ],
                  onSelected: (String value) {
                    switch (value) {
                      case 'sharelocation':
                        getCurrentLocation().then((value) async {
                          if (value != null) {
                            lat = '${value.latitude}';
                            long = '${value.longitude}';
                            print('line 270: $lat, $long');

                            final String shopUID = widget.shopId;
                            await setUserLocationInFirestore(
                              FirebaseAuth.instance.currentUser!.uid,
                              shopUID,
                              double.parse(lat!),
                              double.parse(long!),
                            );
                          } else {
                            showToast("You need to enable location to share");
                          }
                        });
                        liveLocation();
                        startAgreement(FirebaseAuth.instance.currentUser!.uid,
                            widget.shopId);
                        break;
                    }
                  },
                );
              }),
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
                widget.shopHours != null
                    ? Visibility(
                        visible: open,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.blue.shade200),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Business Hours: ${widget.shopHours!}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                    onPressed: () {
                                      setState(() {
                                        open = false;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.close,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      )
                    : const SizedBox(),
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

                      DateTime dateToday =
                          DateTime(now.year, now.month, now.day);
                      DateTime dateReceived = DateTime(timeReceived.year,
                          timeReceived.month, timeReceived.day);

                      bool isSameDate =
                          dateToday.isAtSameMomentAs(dateReceived);

                      String formattedDateTime = (isSameDate)
                          ? DateFormat('hh:mm a').format(timeReceived)
                          : (timeReceived.isAfter(
                              now.subtract(const Duration(days: 6)),
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
                // ? PRE ASKED QUESTION
                chatDocId == null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _sendMessage(true, pre1);
                                },
                                child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.blue.shade200),
                                        borderRadius: BorderRadius.circular(4)),
                                    child: Text(pre1)),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _sendMessage(true, pre2);
                                },
                                child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.blue.shade200),
                                        borderRadius: BorderRadius.circular(4)),
                                    child: Text(pre2)),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _sendMessage(true, pre3);
                                },
                                child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.blue.shade200),
                                        borderRadius: BorderRadius.circular(4)),
                                    child: Text(pre3)),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('chats')
                        .doc(chatDocId)
                        .collection('location')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                        QueryDocumentSnapshot firstDoc =
                            snapshot.data!.docs.first;
                        Map<String, dynamic> data =
                            firstDoc.data() as Map<String, dynamic>;

                        bool isActive = data['active'] ?? false;

                        String lat = data['latitude'].toString();
                        String long = data['longitude'].toString();

                        print('line 519: $lat & $long');

                        String fromUserId = data['user_id'];

                        if (isActive) {
                          return Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                  '${FirebaseAuth.instance.currentUser!.uid == fromUserId ? "You" : widget.shopName} just shared ${FirebaseAuth.instance.currentUser!.uid == fromUserId ? "your" : 'their'} location'),
                              GestureDetector(
                                onTap: () {
                                  openMap(lat, long);
                                },
                                child: const Text(
                                  "Tap to view",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          );
                        }
                      }

                      return const SizedBox();
                    }),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('chats')
                        .doc(chatDocId)
                        .collection('agreement')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot2) {
                      if (snapshot2.hasData &&
                          snapshot2.data!.docs.isNotEmpty) {
                        QueryDocumentSnapshot firstDoc =
                            snapshot2.data!.docs.first;
                        Map<String, dynamic> data =
                            firstDoc.data() as Map<String, dynamic>;

                        String agreementStatus = data['status'];
                        String agreementDocId = firstDoc.id;
                        String fromUserId = data['user_id'];
                        String shopUID = data['shop_id'];

                        return Column(
                          children: [
                            agreementStatus == "Active"
                                ? Text(
                                    "${fromUserId == FirebaseAuth.instance.currentUser!.uid ? "You've" : widget.shopName} initiated an agreement")
                                : const SizedBox(),
                            agreementStatus == "Pending"
                                ? Column(
                                    children: [
                                      Text(
                                        "${fromUserId == FirebaseAuth.instance.currentUser!.uid ? "You've" : widget.shopName} terminated the agreement, waiting for Service Provider to confirm payment",
                                        textAlign: TextAlign.center,
                                      ),
                                      shopUID ==
                                              FirebaseAuth
                                                  .instance.currentUser!.uid
                                          ? GestureDetector(
                                              onTap: () {
                                                confirmEndAgreement(context,
                                                    agreementDocId, fromUserId);
                                              },
                                              child: Text(
                                                "Tap to Confirm",
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              ),
                                            )
                                          : const SizedBox(),
                                    ],
                                  )
                                : const SizedBox(),
                            agreementStatus == "Paid"
                                ? Column(
                                    children: [
                                      const Text("Agreement Terminated"),
                                      fromUserId ==
                                              FirebaseAuth
                                                  .instance.currentUser!.uid
                                          ? GestureDetector(
                                              onTap: () {
                                                RateHandler.ratingHandler(
                                                  context,
                                                  widget.shopId,
                                                  widget.shopName,
                                                );
                                              },
                                              child: const Text(
                                                "Time to rate!",
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              ),
                                            )
                                          : const SizedBox(),
                                    ],
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        );
                      }

                      return const SizedBox();
                    }),
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
                          onPressed: () {
                            _sendMessage(false, null);
                          },
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

  Future<void> fetchShopData() async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection("service_provider")
          .where("uid", isEqualTo: widget.shopId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          shopData = querySnapshot.docs.first.data();
        });
      }

      if (shopData['disabled']) {
        disableAlert();
      }
    } catch (e) {
      print('line 688: $e');
    }
  }

  Future<void> _sendMessage(bool preQuestion, String? selectedPreQ) async {
    String message = chatTextFieldController.text.trim();

    if (message.isNotEmpty || preQuestion == true) {
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
          sendNotification('message');
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
              'latest_chat_message':
                  preQuestion == true ? selectedPreQ : message,
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
              'message_text': preQuestion == true ? selectedPreQ : message,
              'receiver_id': widget.shopId,
              'sender_id': uid,
              'timestamp': timeSent,
            });

            setState(() {
              chatDocId = newChatDocId;
            });

            sendNotification('message');
          } catch (e) {
            print("error sending message, line 765: $e");
          }
        }
      } catch (e) {
        print("error sending msg, line 769 $e");
      }

      chatTextFieldController.clear();

      // !======== SEND A NOTIF=================
    }
  }

  Future<void> sendNotification(String type) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final today = Timestamp.now();
    if (type == 'message') {
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
          print("error sending message, line 810: $e");
        }
      } else {
        print("Notification already sent for a message today");
      }
    } else if (type == 'agreement') {
      // Query to check if a notification has been sent today for a message
      QuerySnapshot<Map<String, dynamic>> existingNotification =
          await FirebaseFirestore.instance
              .collection('notification')
              .where('from_uid', isEqualTo: uid)
              .where('is_agreement', isEqualTo: true)
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
            'is_agreement': true,
            'is_message': false,
            'is_rate': false,
            'is_read': false,
            'notif_msg': 'initiated an agreement.',
            'user_doc_id': widget.shopId,
          });
        } catch (e) {
          print("error sending message, line 844: $e");
        }
      } else {
        print("Notification already sent for a message today");
      }
    } else {
      QuerySnapshot<Map<String, dynamic>> existingNotification =
          await FirebaseFirestore.instance
              .collection('notification')
              .where('from_uid', isEqualTo: uid)
              .where('is_rate', isEqualTo: true)
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
            'is_message': false,
            'is_rate': true,
            'is_read': false,
            'notif_msg': 'rated and reviewed your service.',
            'user_doc_id': widget.shopId,
          });
        } catch (e) {
          print("error sending message, line 877: $e");
        }
      } else {
        print("Notification already sent for a message today");
      }
    }
  }

  Future<Position?> getCurrentLocation() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      print('service disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Handle the case where permission is denied
        return null; // or throw an error
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Handle the case where permission is permanently denied
      return null; // or throw an error
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      return await Geolocator.getCurrentPosition();
    }

    return null; // Handle any other cases
  }

  void liveLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {});
  }

  Future<void> openMap(String lat, String long) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    await canLaunchUrlString(googleUrl)
        ? await launchUrlString(googleUrl)
        : throw 'could not launch $googleUrl';
  }

  Future<void> setUserLocationInFirestore(
      String userId, String shopId, double lat, double long) async {
    try {
      final userLocationRef = FirebaseFirestore.instance
          .collection('chats')
          .doc(chatDocId)
          .collection('location');
      await userLocationRef.doc().set({
        'active': true,
        'latitude': lat,
        'longitude': long,
        'shop_id': shopId,
        'user_id': userId,
        'timestamp': Timestamp.now(),
      });
    } catch (e) {
      print('line 946: $e');
    }
  }

  Future<void> stopSharingLocation(String docId) async {
    try {
      final userLocationRef = FirebaseFirestore.instance
          .collection('chats')
          .doc(chatDocId)
          .collection('location');
      await userLocationRef.doc(docId).update({
        'active': false,
      });
    } catch (e) {
      print('line 960: $e');
    }
  }

  Future<void> startAgreement(String userId, String shopId) async {
    try {
      final userLocationRef = FirebaseFirestore.instance
          .collection('chats')
          .doc(chatDocId)
          .collection('agreement');
      await userLocationRef.doc().set({
        'status': 'Active',
        'shop_id': shopId,
        'user_id': userId,
        'timestamp': Timestamp.now(),
      });

      sendNotification('agreement');
    } catch (e) {
      print('line 979: $e');
    }
  }

  Future<void> endAgreement(String docId, String? fromUID) async {
    if (fromUID != null && fromUID.isNotEmpty) {
      final userLocationRef = FirebaseFirestore.instance
          .collection('chats')
          .doc(chatDocId)
          .collection('agreement');
      await userLocationRef.doc(docId).update({
        'status': 'Pending',
      });
    } else {
      final userLocationRef = FirebaseFirestore.instance
          .collection('chats')
          .doc(chatDocId)
          .collection('agreement');
      await userLocationRef.doc(docId).update({
        'status': 'Paid',
      });
    }
  }

  void confirmEndAgreement(
      BuildContext context, String agreementDocId, String fromUserId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('End the Agreement?'),
          content: Text(
            fromUserId != FirebaseAuth.instance.currentUser!.uid
                ? 'Customer has initiated the end of the agreement. Make sure to settle the payment before clicking "confirm"'
                : 'Please complete your payment before confirming the end of the agreement.',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                endAgreement(
                    agreementDocId,
                    fromUserId == FirebaseAuth.instance.currentUser!.uid
                        ? fromUserId
                        : null);
                Navigator.of(context).pop();
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}
