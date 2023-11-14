import 'package:athomeconvenience/widgets/notif_card.dart';
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
        Map<String, dynamic> tempData = doc.data();
        tempData['docId'] = doc.id;

        tempNotifications.add(tempData);
      });

      // Fetching shopData for each notification
      for (var notification in tempNotifications) {
        var serviceProviderSnapshot = await FirebaseFirestore.instance
            .collection("service_provider")
            .doc(notification[
                'user_doc_id']) // Assuming user_doc_id is the ID in service_provider
            .get();

        if (serviceProviderSnapshot.exists) {
          var serviceProviderData = serviceProviderSnapshot.data();
          // Accessing service_provider_name
          var serviceProviderName =
              serviceProviderData!['service_provider_name'];

          notification['service_provider_name'] = serviceProviderName;
        }
      }

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
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              for (final notif in notifications)
                NotifCard(
                  fromUid: notif['from_uid'],
                  shopName: notif['service_provider_name'],
                  dateTime: notif['dateTime'],
                  isRead: notif['is_read'],
                  docId: notif['docId'],
                )
            ],
          ),
        ),
      )),
    );
  }
}
