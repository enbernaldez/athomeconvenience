import 'package:cloud_firestore/cloud_firestore.dart';

class MessageData {
  final String docId;
  final String incomingId; //id of shop
  final String shopName;
  final String? shopHours;
  final Timestamp latestChatTime;
  final String latestChatUser;
  final String latestChatMsg;

  MessageData(
      {required this.docId,
      required this.incomingId,
      required this.shopName,
      this.shopHours,
      required this.latestChatTime,
      required this.latestChatUser,
      required this.latestChatMsg});
}
