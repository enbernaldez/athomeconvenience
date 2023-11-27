import 'package:athomeconvenience/model/message_data.dart';
import 'package:athomeconvenience/widgets/message/message_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Messages'),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Edit',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('users_id',
                arrayContains: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No chats available.'),
            );
          }

          return FutureBuilder<List<MessageData>>(
            future: processChats(snapshot.data!.docs),
            builder: (BuildContext context,
                AsyncSnapshot<List<MessageData>> chatsSnapshot) {
              if (chatsSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!chatsSnapshot.hasData || chatsSnapshot.data!.isEmpty) {
                return Center(
                  child: Text('No chats available.'),
                );
              }

              List<MessageData> chats = chatsSnapshot.data!;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      for (final chat in chats)
                        MessageCard(
                          docId: chat.docId,
                          shopId: chat.incomingId,
                          shopName: chat.shopName,
                          shopHours: chat.shopHours,
                          latestChatTime: chat.latestChatTime,
                          latestChatUser: chat.latestChatUser,
                          latestChatMsg: chat.latestChatMsg,
                        )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<MessageData>> processChats(List<DocumentSnapshot> docs) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    List<MessageData> chats = [];

    for (final chat in docs) {
      final chatData = chat.data() as Map<String, dynamic>;

      List<dynamic> usersDynamic = chatData['users_id'];
      print(usersDynamic);
      List<String> usersString =
          usersDynamic.map((item) => item.toString()).toList();

      String docId = chat.id;
      String shopId = usersString.firstWhere((id) => id != uid); //!or user id
      String? shopName; //! or user full name
      String? serviceHours;
      Timestamp latestChatTimeStamp = chatData['latest_timestamp'];
      String latestChatUser = chatData['latest_chat_user'];
      String latestChatMsg = chatData['latest_chat_message'];

      try {
        var shopQuery = await FirebaseFirestore.instance
            .collection('service_provider')
            .where('uid', isEqualTo: shopId)
            .get();

        if (shopQuery.docs.isNotEmpty) {
          String start = shopQuery.docs.first.get('service_start');
          String end = shopQuery.docs.first.get('service_end');

          shopName = shopQuery.docs.first.get('service_provider_name');
          serviceHours = '$start-$end';
        } else {
          // ! FETCH USER INSTEAD
          var userQuery = await FirebaseFirestore.instance
              .collection('users')
              .where('uid', isEqualTo: shopId)
              .get();

          if (userQuery.docs.isNotEmpty) {
            String userName = userQuery.docs.first.get("name");

            shopName = userName;
          }
        }
      } catch (e) {
        print("error fetching shopData: $e");
      }

      if (docId.isNotEmpty &&
          shopId.isNotEmpty &&
          shopName != null &&
          latestChatTimeStamp.toString().isNotEmpty &&
          latestChatUser.isNotEmpty &&
          latestChatMsg.isNotEmpty) {
        final currentChat = MessageData(
          docId: docId,
          incomingId: shopId,
          shopName: shopName!,
          shopHours: serviceHours,
          latestChatTime: latestChatTimeStamp,
          latestChatUser: latestChatUser,
          latestChatMsg: latestChatMsg,
        );

        chats.add(currentChat);
      }
    }

    return chats;
  }
}
