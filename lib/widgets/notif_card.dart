import 'package:athomeconvenience/widgets/message/conversation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotifCard extends StatelessWidget {
  final String fromUid;
  final String shopName;
  final Timestamp dateTime;
  final bool isRead;
  final String docId;

  NotifCard(
      {super.key,
      required this.fromUid,
      required this.shopName,
      required this.dateTime,
      required this.isRead,
      required this.docId});

  @override
  Widget build(BuildContext context) {
    DateTime notificationTimeUtc = dateTime.toDate(); // Convert to UTC

    DateTime notificationTimeLocal =
        notificationTimeUtc.add(Duration(hours: 8)); // Add 8 hours for UTC+8:00

    print(
        notificationTimeLocal); // Print the local time in Kuala Lumpur, Singapore time zone

    DateTime now = DateTime.now();
    bool isToday = now.difference(notificationTimeLocal).inDays == 0;

    String formattedDateTime = isToday
        ? 'Today at ${DateFormat.Hm().format(notificationTimeLocal)}'
        : DateFormat('yyyy/MM/dd HH:mm').format(notificationTimeLocal);

    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            // ?====update isRead status=========
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

            // ?===========================

            // ? ==========navigate to converstation page

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    const Conversation(), //TODO PASS THE SHOP UID AND SHOP NAME
              ),
            );
          },
          child: Container(
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
                      shopName ?? "Loading",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isRead == false
                              ? Colors.black
                              : Colors.grey.shade600),
                    ),

                    // messaged you
                    Text(
                      "Messaged you",
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
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
