import 'package:athomeconvenience/functions/functions.dart';
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

// ========================= Fetch User Likes =========================
List<String> userLikes = [];

Future<void> fetchUserLikes(bool? isLiked) async {
  try {
    var userQuerySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: uid)
        .get();

    if (userQuerySnapshot.docs.isNotEmpty) {
      var userData = userQuerySnapshot.docs.first.data();
      userLikes = List<String>.from(userData['likes'] ?? []);

      if (userLikes.contains(shopData['uid'])) {
        isLiked = true;
      } else {
        isLiked = false;
      }
    }
  } catch (e) {
    print(e);
  }
}

// ==================== Insert Rate and Review in Database ====================
final reviewController = TextEditingController();

handleRateReview(String shopUid, String rating, String review) async {
  final firestore = FirebaseFirestore.instance;

  try {
    await firestore.collection('ratings').add({
      'star_rating': rating,
      'review': review,
      'user_id': uid,
      'shop_id': shopUid,
      'timestamp': FieldValue.serverTimestamp(),
    });

    showToast("Rated successfully!");
  } catch (error) {
    print(error);
    showToast("Error. Please try again.");
  }
  return review;
}

// =========================== Retrieve User Details ===========================
String customerName = '';

Future<void> fetchUserDetails(String userId) async {
  try {
    // Get a reference to the Firestore database
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Get the document snapshot using the document ID
    DocumentSnapshot documentSnapshot =
        await firestore.collection('users').doc(userId).get();
    // Check if the document exists
    if (documentSnapshot.exists) {
      // Access specific fields from the document data
      dynamic userName = documentSnapshot.get('name');
      // Replace 'field_name' with the actual field name you want to retrieve

      // Use the retrieved data as needed
      customerName = userName;
      print('Field value: $userName');
    } else {
      print('User does not exist');
    }
  } catch (error) {
    print('Error getting user details: $error');
  }
}

// ======================== Data for Display of Ratings ========================
double averageRating = 0.0;
num numberOfRatings = 0;
String strAverageRating = '';

Future<void> fetchAverageRating(BuildContext context, String shopUid) async {
  try {
    // Execute the query
    var querySnapshot = await FirebaseFirestore.instance
        .collection("ratings")
        .where("shop_id", isEqualTo: shopUid)
        .get();

    // Extract star_rating values from each document
    List<double> starRatings = [];
    for (var document in querySnapshot.docs) {
      // Assuming "star_rating" is the name of the field in your documents
      double starRating = double.parse(document.get("star_rating"));
      starRatings.add(starRating);
    }

    // Calculate the average
    if (starRatings.isNotEmpty) {
      numberOfRatings = starRatings.length;
      averageRating = starRatings.reduce((a, b) => a + b) / numberOfRatings;
      strAverageRating = averageRating.toStringAsFixed(2);
    } else {
      print(shopUid);
      print('starRatings is empty.');
    }
    // Now averageRating contains the average star rating
  } catch (e) {
    print("Error fetching data: $e");
  }
}
