/*
FUNCTIONS:
1. User Type Checker
2. Time Picker
3. Image Picker
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ====================== User Type Checker ======================
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

// =========================== Time Picker ===========================
TimeOfDay? selectedTimeST; //*
TimeOfDay? selectedTimeET; //*
TimePickerEntryMode entryMode = TimePickerEntryMode.dialOnly;
TextDirection textDirection = TextDirection.ltr;
MaterialTapTargetSize tapTargetSize = MaterialTapTargetSize.padded;
Orientation orientation = Orientation.portrait;
bool use24HourTime = false;
String startTime = '';
String buttonTextST = 'Start Time';
String buttonTextET = 'End Time';

Future<TimeOfDay?> showTimePickerFunction(
  BuildContext context,
  TimeOfDay? initialTime,
) async {
  return await showTimePicker(
    context: context,
    initialTime: initialTime ?? TimeOfDay.now(),
    initialEntryMode: entryMode,
    orientation: orientation,
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: Theme.of(context).copyWith(
          materialTapTargetSize: tapTargetSize,
        ),
        child: Directionality(
          textDirection: textDirection,
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              alwaysUse24HourFormat: use24HourTime,
            ),
            child: child!,
          ),
        ),
      );
    },
  );
}

// ======================= Image Picker =======================
class ImageHandler {
  static XFile? _image; //*
  static final ImagePicker picker = ImagePicker();

  static XFile? get currentImage => _image;

  static Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    if (img != null) {
      _image = img;
    }
  }

  static void uploadImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          title: const Text('Upload'),
          content: SizedBox(
            height: MediaQuery.of(context).size.height / 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    side: const BorderSide(
                      color: Colors.blueAccent,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    getImage(ImageSource.gallery);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.image,
                        color: Colors.blue[700],
                      ),
                      const SizedBox(width: 8),
                      const Text('From Gallery'),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    side: const BorderSide(
                      color: Colors.blueAccent,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    getImage(ImageSource.camera);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.camera,
                        color: Colors.blue[700],
                      ),
                      const SizedBox(width: 8),
                      const Text('From Camera'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}