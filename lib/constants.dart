import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ----- Service Categories -----
Map<String, String> serviceCategoryMap = {
  'Electrical': 'images/icon_electrical.png',
  'Handyman': 'images/icon_handyman.png',
  'Body Groomer': 'images/icon_bodygroomer.png',
  'Plumber': 'images/icon_plumber.png',
  'Cleaning': 'images/icon_cleaning.png',
  'Technician': 'images/icon_technician.png',
  'Greenscaping': 'images/icon_greenscaping.png',
  'Pet Care': 'images/icon_petcare.png',
};

// ----- Check if user == service provider -----
Future<bool> isServiceProvider() async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final CollectionReference serviceProviders =
      FirebaseFirestore.instance.collection('service_provider');

  try {
    var documentSnapshot = await serviceProviders.doc(uid).get();
    return documentSnapshot.exists;
  } catch (e) {
    print("Error checking UID existence: $e");
    return false;
  }
}
