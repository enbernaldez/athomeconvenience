import 'package:cloud_firestore/cloud_firestore.dart';

class IndividualMessage {
  final String msgDocId;
  final String messageText; //id of shop
  final String receiverId;
  final String senderId;
  final Timestamp timestamp;

  IndividualMessage({
    required this.msgDocId,
    required this.messageText,
    required this.receiverId,
    required this.senderId,
    required this.timestamp,
  });
}
