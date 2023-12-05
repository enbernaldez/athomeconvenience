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
  bool isLoading = true;

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
          .orderBy('dateTime', descending: true)
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
                'from_uid']) // Assuming user_doc_id is the ID in service_provider
            .get();

        if (serviceProviderSnapshot.exists) {
          var serviceProviderData = serviceProviderSnapshot.data();
          // Accessing service_provider_name
          var serviceProviderName =
              serviceProviderData!['service_provider_name'];

          notification['service_provider_name'] = serviceProviderName;
        } else {
          // ! FETCH USER INSTEAD
          var userQuery = await FirebaseFirestore.instance
              .collection('users')
              .where('uid', isEqualTo: notification['from_uid'])
              .get();

          if (userQuery.docs.isNotEmpty) {
            String userName = userQuery.docs.first.get("name");

            notification['service_provider_name'] = userName;
          }
        }
      }

      // Update the state with the fetched data
      setState(() {
        isLoading = false;
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
        title: const Text('Notifications'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  for (final notif in notifications)
                    NotifCard(
                      chatDocId: notif['chat_doc_id'],
                      fromUid: notif['from_uid'],
                      shopName: notif['service_provider_name'],
                      dateTime: notif['dateTime'],
                      isRead: notif['is_read'],
                      docId: notif['docId'],
                      isMessage: notif['is_message'],
                      isRate: notif['is_rate'],
                      isAgreement: notif['is_agreement'],
                      notifMsg: notif['notif_msg'],
                    )
                ],
              ),
            ),
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            )
        ],
      ),
    );
  }
}
