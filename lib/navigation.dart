import 'package:athomeconvenience/settings_page.dart';
import 'package:athomeconvenience/home_page.dart';
import 'package:athomeconvenience/inbox_page.dart';
import 'package:athomeconvenience/likes_page.dart';
import 'package:athomeconvenience/notifications_page.dart';
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
      bottomNavigationBar: ConvexAppBar(
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
      ),
    );
  }
}
