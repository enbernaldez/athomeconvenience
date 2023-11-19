import 'package:athomeconvenience/widgets/message/conversation.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => const Conversation(),
              ),
            );
          },
          child: const Row(
            children: [
              // Image/Icon
              CircleAvatar(
                backgroundImage: AssetImage('images/default_profile_pic.png'),
                maxRadius: 30,
              ),
              SizedBox(
                width: 20,
              ),

              // Column
              Flexible(
                child: Column(
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
                      "You: I need it today",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              // timestamp
              Text("8:00")
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
