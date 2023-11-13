import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Map<String, dynamic>> notifications = []; // List to store fetched data

  @override
  void initState() {
    super.initState();
    fetchNotif();
  }

  Future<void> fetchNotif() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      var querySnapshot = await FirebaseFirestore.instance
          .collection("notification")
          .where("user_doc_id", isEqualTo: uid)
          .get();

      List<Map<String, dynamic>> tempNotifications =
          []; // Temporary list to store fetched data

      querySnapshot.docs.forEach((doc) {
        tempNotifications.add(doc.data());
      });

      // Update the state with the fetched data
      setState(() {
        notifications = tempNotifications;
      });
    } catch (e) {
      print("Error fetching notifications: $e");
      // Handle errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Notifications',
          style: Theme.of(context).textTheme.titleLarge!,
        ),
        centerTitle: true,
      ),
    );
  }
}
