import 'package:athomeconvenience/widgets/message/conversation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotifCard extends StatelessWidget {
  final String? chatDocId;
  final bool isRate;
  final bool isMessage;
  final bool isAgreement;
  final String fromUid;
  final String shopName;
  final Timestamp dateTime;
  final bool isRead;
  final String docId;
  final String notifMsg;

  const NotifCard(
      {super.key,
      this.chatDocId,
      required this.fromUid,
      required this.shopName,
      required this.dateTime,
      required this.isRead,
      required this.docId,
      required this.isMessage,
      required this.isAgreement,
      required this.isRate,
      required this.notifMsg});

  @override
  Widget build(BuildContext context) {
    //? DATE & TIME DISPLAY ============================================
    DateTime notificationTimeUtc = dateTime.toDate(); // Convert to UTC

    DateTime notificationTimeLocal = notificationTimeUtc
        .add(const Duration(hours: 8)); // Add 8 hours for UTC+8:00

    DateTime now = DateTime.now();
    bool isToday = now.difference(notificationTimeLocal).inDays == 0;

    String formattedDateTime = isToday
        ? 'Today at ${DateFormat.Hm().format(notificationTimeLocal)}'
        : DateFormat('yyyy/MM/dd HH:mm').format(notificationTimeLocal);
    // ? ===============================================================

    Future<void> updateReadStatus() async {
      try {
        await FirebaseFirestore.instance
            .collection('notification')
            .doc(docId)
            .update({
          "is_read": true,
        });
      } catch (e) {
        print(e);
      }
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            updateReadStatus();

            if (isMessage == true && isRate == false && isAgreement == false) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => Conversation(
                    docId: chatDocId,
                    shopId: fromUid,
                    shopName: shopName,
                  ),
                ),
              );
            } else if (isRate == true &&
                isMessage == false &&
                isAgreement == false) {
              print("rate");
              // TODO NAVIGATE TO VIEW SHOP'S RATING & REVIEW
            } else {
              print('agreement');
              // TODO NAVIGATE TO CONVERSATION PAGE
            }
          },
          child: Row(
            children: [
              // Image/Icon
              Container(
                height: 70,
                width: 70,
                decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(100))),
              ),
              const SizedBox(
                width: 20,
              ),

              // Column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SHOP NAME
                  Text(
                    shopName ?? "Loading...",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isRead == false
                            ? Colors.black
                            : Colors.grey.shade600),
                  ),

                  // messaged you
                  Text(
                    notifMsg,
                    style: TextStyle(
                        fontSize: 15,
                        color: isRead == false
                            ? Colors.black
                            : Colors.grey.shade600),
                  ),

                  // timestamp
                  Text(
                    formattedDateTime,
                    style: TextStyle(
                        color: isRead == false
                            ? Colors.black
                            : Colors.grey.shade600),
                  )
                ],
              )
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
