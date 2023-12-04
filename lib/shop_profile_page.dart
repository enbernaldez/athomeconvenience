import 'dart:io';

import 'package:athomeconvenience/widgets/buttons.dart';
import 'package:athomeconvenience/widgets/message/conversation.dart';
import 'package:athomeconvenience/widgets/shopProfileView/about.dart';
import 'package:athomeconvenience/widgets/shopProfileView/reviews.dart';
import 'package:athomeconvenience/widgets/shopProfileView/works.dart';
import 'package:athomeconvenience/functions/functions.dart';
import 'package:athomeconvenience/widgets/star_rating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ShopProfilePage extends StatefulWidget {
  final String shopUid;

  const ShopProfilePage({
    super.key,
    required this.shopUid,
  });

  @override
  State<ShopProfilePage> createState() => _ShopProfilePageState();
}

class _ShopProfilePageState extends State<ShopProfilePage> {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  String? chatDocId;
  bool? isLiked;

  Map<String, dynamic> shopData = {};
  List<String> userLikes = [];
  double averageRating = 0.0;
  num numberOfRatings = 0;
  String strAverageRating = '';

  final ImagePicker picker = ImagePicker();
  XFile? image;

  @override
  void initState() {
    super.initState();
    fetchShopData();
    fetchUserLikes();
    fetchAverageRating();
    fetchChatDocId();
  }

  bool disableButton = false;
  Color? liked;
  bool isAbout = true;
  bool isWorks = false;
  bool isReviews = false;

  @override
  Widget build(BuildContext context) {
    void handleLike() async {
      try {
        // Fetch the user document
        var userQuerySnapshot = await FirebaseFirestore.instance
            .collection("users")
            .where("uid", isEqualTo: uid)
            .get();

        if (userQuerySnapshot.docs.isNotEmpty) {
          // Access the first document, assuming unique UIDs
          var userDocRef = userQuerySnapshot.docs.first.reference;

          // Get the current 'likes' array
          List<dynamic> currentLikes = userQuerySnapshot.docs.first['likes'];

          // If the shop is already liked, remove the UID from 'likes' array
          if (currentLikes.contains(shopData['uid'])) {
            userDocRef.update({
              'likes': FieldValue.arrayRemove([shopData['uid']])
            });
            setState(() {
              isLiked = false;
            });
          } else {
            // If the shop is not liked, add the UID to 'likes' array
            userDocRef.update({
              'likes': FieldValue.arrayUnion([shopData['uid']])
            });
            setState(() {
              isLiked = true;
            });
          }
        } else {
          // Handle scenario when user document isn't found
        }
      } catch (e) {
        print(e);
      }
    }

    if (userLikes.contains(shopData['uid'])) {
      isLiked = true;
    }

    String workingHours = 'Loading';

    if (shopData['service_start'].toString().isNotEmpty &&
        shopData['service_end'].toString().isNotEmpty) {
      setState(() {
        workingHours =
            '${shopData['service_start']} - ${shopData['service_end']}';
      });
    } else {
      setState(() {
        workingHours = "N/A";
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: const BackArrow(),
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: FractionallySizedBox(
            widthFactor: 0.85,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),

                  // IMAGE/ICON
                  const CircleAvatar(
                    backgroundImage:
                        AssetImage('images/default_profile_pic.png'),
                    maxRadius: 60,
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  // SHOP NAME
                  Text(
                    shopData['service_provider_name'] ?? "Loading",
                    style: GoogleFonts.dmSans(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  // STAR RATING
                  // TODO: make rating only once, after interaction
                  GestureDetector(
                    onTap: () {
                      // after interaction, canRate is set to true, so..
                      // if canRate = true
                      RateHandler.ratingHandler(
                        context,
                        widget.shopUid,
                        shopData['service_provider_name'],
                      );
                      // fetchAverageRating(context, widget.shopUid);
                    },
                    child: Column(
                      children: [
                        StarRating(
                          onRatingChange: (p0) {},
                          initialRating: averageRating ?? 0.0,
                          allowHalfRating: true,
                          ignoreGestures: true,
                        ),
                        Text(
                          "$strAverageRating/5 ($numberOfRatings)",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),

                  // MESSAGE AND LIKE/HEART
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      // *message btn
                      Expanded(
                        child: Button(
                          onPress: shopData['uid'] !=
                                  FirebaseAuth.instance.currentUser!.uid
                              ? () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Conversation(
                                        docId: chatDocId,
                                        shopId: shopData['uid'],
                                        shopName:
                                            shopData['service_provider_name'],
                                      ),
                                    ),
                                  );
                                }
                              : null,
                          buttonText: 'Message',
                          buttonColor: shopData['uid'] ==
                                  FirebaseAuth.instance.currentUser!.uid
                              ? Colors.grey
                              : null,
                          textType: Theme.of(context).textTheme.displaySmall,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),

                      // * like btn
                      SizedBox(
                        width: 50,
                        child: Button(
                          onPress: disableButton == false ||
                                  shopData['uid'] !=
                                      FirebaseAuth.instance.currentUser!.uid
                              ? handleLike
                              : null,
                          buttonText: '',
                          icon: Icons.favorite,
                          buttonColor: shopData['uid'] !=
                                  FirebaseAuth.instance.currentUser!.uid
                              ? null
                              : Colors.grey,
                          iconColor:
                              isLiked == true ? Colors.red : Colors.blue[50],
                        ),
                      ),
                    ],
                  ),

                  // ABOUT | WORKS BTN
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isAbout = true;
                            isWorks = false;
                            isReviews = false;
                          });
                        },
                        child: Text(
                          "About",
                          style: GoogleFonts.dmSans(
                              letterSpacing: -0.5,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isAbout == true
                                  ? const Color(0xFF00A2FF)
                                  : Colors.grey),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 24, //adjust nalang height
                        width: 1.5,
                        decoration: const BoxDecoration(color: Colors.grey),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isAbout = false;
                            isWorks = true;
                            isReviews = false;
                          });
                        },
                        child: Text(
                          "Works",
                          style: GoogleFonts.dmSans(
                              letterSpacing: -0.5,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isWorks == true
                                  ? const Color(0xFF00A2FF)
                                  : Colors.grey),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 24, //adjust nalang height
                        width: 1.5,
                        decoration: const BoxDecoration(color: Colors.grey),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isAbout = false;
                            isWorks = false;
                            isReviews = true;
                          });
                        },
                        child: Text(
                          "Reviews",
                          style: GoogleFonts.dmSans(
                              letterSpacing: -0.5,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isReviews == true
                                  ? const Color(0xFF00A2FF)
                                  : Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // ABOUT | WORKS CONTENT
                  isAbout == true
                      ? AboutSection(
                          category: shopData['category'] ?? "Loading...",
                          shopAddress:
                              (shopData['service_address'].toString().isNotEmpty
                                      ? shopData['service_address']
                                      : "N/A") ??
                                  "Loading...",
                          contactNum: shopData['contact_num'] ?? "Loading...",
                          workingHours: workingHours,
                        )
                      : (isWorks == true
                          ? WorksSection(
                              shopId: widget.shopUid,
                            )
                          : (isReviews == true
                              ? ReviewsSection(
                                  shopUid: widget.shopUid,
                                  shopReviews: true,
                                )
                              : const Center(
                                  child: Column(
                                    children: [
                                      Text("There seems to be a problem."),
                                      Text(
                                        "Please exit the app and try again.",
                                      ),
                                    ],
                                  ),
                                )))
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: uid == widget.shopUid && isAbout == false && isReviews == false
            ? true
            : false,
        child: FloatingActionButton(
          onPressed: () {
            myAlert();
            if (image != null) {
              print(image!.path);
              insertWork();
            }
          },
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> fetchShopData() async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection("service_provider")
          .where("uid", isEqualTo: widget.shopUid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          shopData = querySnapshot.docs.first.data();
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchUserLikes() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      var userQuerySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("uid", isEqualTo: uid)
          .get();

      if (userQuerySnapshot.docs.isNotEmpty) {
        var userData = userQuerySnapshot.docs.first.data();
        setState(() {
          userLikes = List<String>.from(userData['likes'] ?? []);
        });

        if (userLikes.contains(shopData['uid'])) {
          setState(() {
            isLiked = true;
          });
        } else {
          setState(() {
            isLiked = false;
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchAverageRating() async {
    try {
      // Execute the query
      var querySnapshot = await FirebaseFirestore.instance
          .collection("ratings")
          .where("shop_id", isEqualTo: widget.shopUid)
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
        setState(() {
          numberOfRatings = starRatings.length;
          averageRating = starRatings.reduce((a, b) => a + b) / numberOfRatings;
          strAverageRating = averageRating.toStringAsFixed(1);
        });
      } else {
        print(widget.shopUid);
        print('starRatings is empty.');
      }
      // Now averageRating contains the average star rating
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> fetchChatDocId() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final compositeId = '${uid}_${widget.shopUid}';

      QuerySnapshot chatQuery = await FirebaseFirestore.instance
          .collection('chats')
          .where("composite_id", isEqualTo: compositeId)
          .get();

      if (chatQuery.docs.isNotEmpty) {
        // Assuming there's only one document matching the condition
        String docId = chatQuery.docs.first.id;
        setState(() {
          chatDocId = docId;
        });
      } else {
        print('No matching chat document found.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
  }

  void myAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                    side: const BorderSide(color: Colors.blueAccent),
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
                    side: const BorderSide(color: Colors.blueAccent),
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

  Future<void> insertWork() async {
    final String? imagePath = image?.path;
    if (imagePath == null || imagePath.isEmpty) {
      showToast("Please upload your image");
      return;
    } else {
      try {
        // ?======== Upload Image First in Firebase Storage==============
        File file = File(imagePath);

        // Generate a unique image name using UUID
        final imageName = const Uuid().v4(); // Generates a random UUID

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('works')
            .child('$imageName.jpg'); // Use the unique image name

        final uploadImage = storageRef.putFile(file);

        final TaskSnapshot snapshot1 = await uploadImage;
        final imageUrl = await snapshot1.ref.getDownloadURL();
        // ?============================================================

        // ?==========insert service provider details================
        await FirebaseFirestore.instance.collection('works').doc().set({
          'uid': FirebaseAuth.instance.currentUser!.uid,
          'image_url': imageUrl,
        }).then((value) {
          showToast("Image Uploaded Successfully");
        }).catchError((error) {
          print(error);
          showToast("Error occured while uploading image");
        });
        // ?=========================================================
      } catch (e) {
        print("error uploading work: $e");
      }
    }
  }
}
