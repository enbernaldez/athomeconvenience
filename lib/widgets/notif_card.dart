import 'package:athomeconvenience/widgets/message/conversation.dart';
import 'package:flutter/material.dart';

class NotifCard extends StatelessWidget {
  const NotifCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => Conversation(),
              ),
            );
          },
          child: Container(
            child: Row(
              children: [
                // Image/Icon
                Container(
                  height: 75,
                  width: 75,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                ),
                const SizedBox(
                  width: 20,
                ),

                // Column
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SHOP NAME
                    Text(
                      "Jonnel Banka Services",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),

                    // messaged you
                    Text(
                      "Messaged you",
                      style: TextStyle(fontSize: 15),
                    ),

                    // timestamp
                    Text("Today at 8:00")
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
