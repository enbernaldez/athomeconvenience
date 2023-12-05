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
    //? DATE & TIME DISPLAY ====================================================
    DateTime notifDateTime = dateTime.toDate();
    DateTime now = DateTime.now();

    DateTime dateToday = DateTime(now.year, now.month, now.day);
    DateTime notifDate =
        DateTime(notifDateTime.year, notifDateTime.month, notifDateTime.day);

    bool isSameDate = dateToday.isAtSameMomentAs(notifDate);

    String formattedDateTime = (isSameDate)
        ? DateFormat('hh:mm a').format(notifDateTime)
        : (notifDateTime.isAfter(
            now.subtract(const Duration(days: 6)),
          ))
            ? DateFormat('EEE \'at\' hh:mm a').format(notifDateTime)
            : (notifDateTime.isAfter(
                DateTime(now.year - 1, now.month, now.day),
              ))
                ? DateFormat('MMM d \'at\' hh:mm a').format(notifDateTime)
                : DateFormat('MM/dd/yy \'at\' hh:mm a').format(notifDateTime);
    // ? =======================================================================

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
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Divider(
            height: 1,
          ),
        ),
        Container(
          color: isRead ? Colors.transparent : Colors.blue[100],
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.center,
                child: FractionallySizedBox(
                  widthFactor: 0.78,
                  child: GestureDetector(
                    onTap: () {
                      updateReadStatus();

                      if (isMessage == true &&
                          isRate == false &&
                          isAgreement == false) {
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
                        const CircleAvatar(
                          backgroundImage:
                              AssetImage('images/default_profile_pic.png'),
                          maxRadius: 30,
                        ),
                        const SizedBox(
                          width: 10,
                        ),

                        // Column
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // SHOP NAME
                            Text(
                              shopName ?? "Loading...",
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: Colors.black),
                            ),

                            // messaged you
                            Text(
                              notifMsg,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: Colors.black),
                            ),

                            // timestamp
                            Text(
                              formattedDateTime,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: Colors.grey[700]),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
