/*
FUNCTIONS:
. Time Picker
. Image Picker
. Show Toast
. Rating Dialog
. trial: interaction dialog
*/

import 'package:athomeconvenience/functions/fetch_data.dart';
import 'package:athomeconvenience/widgets/buttons.dart';
import 'package:athomeconvenience/widgets/star_rating.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

// ============================ Time Picker ============================
TimeOfDay? selectedTimeST; //*
TimeOfDay? selectedTimeET; //*
TimePickerEntryMode entryMode = TimePickerEntryMode.dialOnly;
TextDirection textDirection = TextDirection.ltr;
MaterialTapTargetSize tapTargetSize = MaterialTapTargetSize.padded;
Orientation orientation = Orientation.portrait;
bool use24HourTime = false;
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

// =========================== Image Picker ===========================
class ImageHandler {
  static XFile? _image; //*
  static final ImagePicker picker = ImagePicker();

  static XFile? get currentImage => _image;

  static Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    print('img: $img');

    if (img != null) {
      _image = img;
      print('_image: $_image');
    }
  }

  static void removeImage() {
    _image = null;
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

// ============= Show Toast =============
void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.grey,
    textColor: Colors.white,
    fontSize: 12.0,
  );
}

// =========================== Rating Dialog ===========================
class RateHandler {
  static void ratingHandler(
    BuildContext context,
    String shopUid,
    String shopName,
  ) {
    double? selectedRating;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          title: const Text('Rate'),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 24.0,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StarRating(
                onRatingChange: (rating) {
                  selectedRating = rating;
                },
              ),
              const SizedBox(
                height: 16.0,
              ),
              // ===================== Review Field =====================
              TextField(
                controller: reviewController..text = '',
                onChanged: (review) {
                  print('Review: $review');
                },
                minLines: 1,
                maxLines: 5,
                maxLength: 100,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'What do you think of $shopName?',
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.grey[700]),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(8.0),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              // ========================================================
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.all(4.0),
          actions: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: DialogButton(
                onPress: () {
                  Navigator.pop(context);
                },
                buttonText: 'Cancel',
                textColor: Colors.black,
              ),
            ),
            Container(
              height: 24, //adjust nalang height
              width: 1.0,
              color: Colors.black87,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: DialogButton(
                onPress: () {
                  if (selectedRating != null) {
                    String strRating = selectedRating!.toString();
                    handleRateReview(shopUid, strRating, reviewController.text);
                    Navigator.pop(context);
                  } else {
                    showToast('Please input your rating.');
                  }
                },
                buttonText: 'Rate',
              ),
            ),
          ],
        );
      },
    );
  }
}

// ========================= trial: interaction dialog =========================
class InteractionHandler {
  static void showInteractionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          title: const Text('Share Location?'),
          content: const Text(
            'By sharing your location, the agreed-upon services will start.',
            softWrap: true,
          ),
          contentPadding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 16.0),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.all(4.0),
          actions: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: DialogButton(
                onPress: () {
                  Navigator.pop(context);
                },
                buttonText: 'Cancel',
                textColor: Colors.black,
              ),
            ),
            Container(
              height: 24, //adjust nalang height
              width: 1.0,
              color: Colors.black87,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: DialogButton(
                onPress: () {},
                buttonText: 'Share',
              ),
            ),
          ],
        );
      },
    );
  }
}
