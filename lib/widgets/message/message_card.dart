import 'package:athomeconvenience/widgets/message/conversation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageCard extends StatefulWidget {
  final String docId;
  final String shopId;
  final String shopName;
  final String? shopHours;
  final Timestamp latestChatTime;
  final String latestChatUser;
  final String latestChatMsg;
  const MessageCard(
      {super.key,
      required this.docId,
      required this.shopId,
      required this.shopName,
      this.shopHours,
      required this.latestChatTime,
      required this.latestChatUser,
      required this.latestChatMsg});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  // ? =========================fetching uid======================
  String uid = "";

  @override
  void initState() {
    super.initState();
    fetchUID();
  }

  Future<void> fetchUID() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;

      setState(() {
        uid = userId;
      });
    } catch (e) {
      print("error fetching uid:$e");
    }
  }
// ?=================================================================

  @override
  Widget build(BuildContext context) {
    // ? ==========GETTING THE CORRECT TIME FOR DISPLAY==================
    DateTime notificationTimeUtc =
        widget.latestChatTime.toDate(); // Convert to UTC

    DateTime notificationTimeLocal = notificationTimeUtc
        .add(const Duration(hours: 8)); // Add 8 hours for UTC+8:00

    DateTime now = DateTime.now();
    bool isToday = now.difference(notificationTimeLocal).inDays == 0;

    String formattedDateTime = (isToday)
        ? DateFormat.Hm().format(notificationTimeLocal)
        : (notificationTimeLocal.isAfter(
            now.subtract(
              Duration(days: 7),
            ),
          ))
            ? DateFormat('EEE').format(notificationTimeLocal)
            : (notificationTimeLocal.isAfter(
                DateTime(now.year - 1, now.month, now.day),
              ))
                ? DateFormat('MMM d').format(notificationTimeLocal)
                : DateFormat('MM/dd/yy').format(notificationTimeLocal);
    // ?=================================================================
    return Column(
      children: [
        Divider(),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => Conversation(
                    shopId: widget.shopId,
                    shopName: widget.shopName,
                    docId: widget.docId,
                  ),
                ),
              );
            },
            child: Row(
              children: [
                // Image/Icon
                const CircleAvatar(
                  backgroundImage: AssetImage('images/default_profile_pic.png'),
                  maxRadius: 30,
                ),
                const SizedBox(
                  width: 10,
                ),

                // Column
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SHOP NAME
                      Text(
                        widget.shopName,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.black),
                      ),

                      // message
                      Text(
                        widget.latestChatUser == uid
                            ? 'You: ${widget.latestChatMsg}'
                            : widget.latestChatMsg,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                // timestamp
                Text(formattedDateTime)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
