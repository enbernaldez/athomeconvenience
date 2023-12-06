import 'package:athomeconvenience/settings_page.dart';
import 'package:athomeconvenience/home_page.dart';
import 'package:athomeconvenience/inbox_page.dart';
import 'package:athomeconvenience/likes_page.dart';
import 'package:athomeconvenience/notifications_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentPageIndex = 2;
  NavigationDestinationLabelBehavior labelBehavior =
      NavigationDestinationLabelBehavior.alwaysHide;
  InteractiveInkFeatureFactory? splashFactory;

  Stream<int> fetchUnreadNotificationCountStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection('notification')
          .where('user_doc_id', isEqualTo: user.uid)
          .where('is_read', isEqualTo: false)
          .snapshots()
          .map((snapshot) => snapshot.docs.length);
    }
    return Stream.value(0);
  }

  Stream<int> fetchUnreadChatMessagesCountStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection('chats')
          .where('users_id', arrayContains: user.uid)
          .snapshots()
          .asyncMap((chatsSnapshot) async {
        int unreadMessagesCount = 0;
        for (final chat in chatsSnapshot.docs) {
          final messagesSnapshot = await chat.reference
              .collection('messages')
              .where('receiver_id', isEqualTo: user.uid)
              .where('is_read', isEqualTo: false)
              .get();

          unreadMessagesCount += messagesSnapshot.docs.length;
        }
        return unreadMessagesCount;
      });
    }
    return Stream.value(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: <Widget>[
        const NotificationsPage(),
        const InboxPage(),
        const HomePage(),
        const LikesPage(),
        const CustomerSettingsPage(),
      ][currentPageIndex],
      bottomNavigationBar: StreamBuilder<int>(
          stream: fetchUnreadNotificationCountStream(),
          builder: (context, snapshot) {
            int unreadCount = snapshot.data ?? 0;
            return ConvexAppBar.badge(
              {
                0: unreadCount > 0 ? unreadCount.toString() : null,
              },
              backgroundColor: Colors.black,
              activeColor: Colors.orangeAccent,
              initialActiveIndex: 2,
              items: const [
                TabItem(icon: Icons.notifications),
                TabItem(icon: Icons.chat_bubble),
                TabItem(icon: Icons.home),
                TabItem(icon: Icons.favorite),
                TabItem(icon: Icons.person),
              ],
              onTap: (int index) {
                setState(() {
                  currentPageIndex = index;
                });
              },
            );
          }),
    );
  }
}
