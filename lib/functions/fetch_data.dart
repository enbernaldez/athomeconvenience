import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final String uid = FirebaseAuth.instance.currentUser!.uid;

// ====================== Fetch A Service Provider Data ======================
Map<String, dynamic> shopData = {};

Future<void> fetchShopData(BuildContext context, String shopUid) async {
  try {
    var querySnapshot = await FirebaseFirestore.instance
        .collection("service_provider")
        .where("uid", isEqualTo: shopUid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      shopData = querySnapshot.docs.first.data();
    }
  } catch (e) {
    print(e);
  }
}

// ========================= Fetch User Likes =========================
List<String> userLikes = [];

Future<void> fetchUserLikes() async {
  try {
    var userQuerySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: uid)
        .get();

    if (userQuerySnapshot.docs.isNotEmpty) {
      var userData = userQuerySnapshot.docs.first.data();
      userLikes = List<String>.from(userData['likes'] ?? []);
    }
  } catch (e) {
    print(e);
  }
}

// ====================== User Type Checker ======================
Future<bool> isServiceProvider() async {
  final CollectionReference serviceProviders =
      FirebaseFirestore.instance.collection('service_provider');

  try {
    var documentSnapshot = await serviceProviders.doc(uid).get();
    return documentSnapshot.exists;
  } catch (e) {
    print(e);
    return false;
  }
}

// ============================= Rating Calculator =============================
ratingCalculation(String spUid, double rating) async {
  DocumentReference<Map<String, dynamic>> documentReference =
      FirebaseFirestore.instance.collection('service_provider').doc(spUid);

  final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
      await documentReference.get();

  // Check if the 'rating' field already exists
  if (!documentSnapshot.data()!.containsKey('rating')) {
    // Update the document with the new field
    await documentReference.update({rating: 0.0});
  } else {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot documentSnapshot =
          await transaction.get(documentReference);

      final lastRatingForTheUser = documentSnapshot.data() as Map;
      String? newRating;
      double? ratingOfUser = double.tryParse(lastRatingForTheUser['rating']);

      rating = rating.ceilToDouble();

      if (ratingOfUser == 0.0) {
        newRating = rating.toString();
      } else {
        double calculateRating = (ratingOfUser! + rating) / 2;
        newRating = calculateRating.toString();
      }

      transaction.update(documentReference, {'rating': newRating});
    });
  }
}