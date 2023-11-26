import 'package:athomeconvenience/functions/fetch_data.dart';
import 'package:athomeconvenience/widgets/buttons.dart';
import 'package:athomeconvenience/widgets/message/conversation.dart';
import 'package:athomeconvenience/widgets/shopProfileView/about.dart';
import 'package:athomeconvenience/widgets/shopProfileView/works.dart';
import 'package:athomeconvenience/functions/functions.dart';
import 'package:athomeconvenience/widgets/star_rating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  Map<String, dynamic> shopData = {};
  List<String> userLikes = [];
  bool _isServiceProvider = false;
  String action = '';
  bool disableButton = false;
  String? chatDocId;

  @override
  void initState() {
    super.initState();
    fetchShopData(context, widget.shopUid);
    fetchUserLikes();
    checkIfServiceProvider();
    fetchChatDocId();
    forServiceProviderEdit();
  }

  Future<void> fetchShopData() async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection("service_provider")
          .where("uid", isEqualTo: widget.shopUid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          shopData = querySnapshot.docs.first
              .data(); // Access data from the first document
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchUserLikes() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      var userQuerySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("uid", isEqualTo: uid)
          .get();

      if (userQuerySnapshot.docs.isNotEmpty) {
        var userLikesData = userQuerySnapshot.docs.first.data();
        setState(() {
          userLikes = List<String>.from(userLikesData['likes'] ?? []);
        });
      }
    } catch (e) {
      print(e);
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

  Future<void> checkIfServiceProvider() async {
  bool _isServiceProvider = false;
  String action = '';
  bool disableButton = false;
  bool isLiked = false;
  Color? liked;
  bool isAbout = true;

  Future<void> forServiceProviderEdit() async {
    bool exists = await isServiceProvider();

    setState(() {
      _isServiceProvider = exists;
      if (_isServiceProvider && uid == widget.shopUid) {
        action = 'Edit';
        disableButton = true;
      }
    });
  }

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

          if (isLiked) {
            // If the shop is already liked, remove the UID from 'likes' array
            if (currentLikes.contains(shopData['uid'])) {
              userDocRef.update({
                'likes': FieldValue.arrayRemove([shopData['uid']])
              });
              setState(() {
                isLiked = false;
                liked = Colors.blue[50];
              });
            }
          } else {
            // If the shop is not liked, add the UID to 'likes' array
            userDocRef.update({
              'likes': FieldValue.arrayUnion([shopData['uid']])
            });
            setState(() {
              isLiked = true;
              liked = Colors.red;
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

    return Scaffold(
      appBar: AppBar(
        leading: const BackArrow(),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isServiceProvider == true && action == 'Edit'
                    ? action = 'Done'
                    : action = 'Edit';
              });
            },
            child: Visibility(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  action,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
          ),
        ],
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

                  // STAR RATING
                  // TODO: make rating only once, after interaction
                  GestureDetector(
                    onTap: () {
                      // after interaction, canRate is set to true, so..
                      // if canRate = true
                      RateHandler.ratingHandler(context, widget.shopUid);
                    },
                    child: StarRating(
                      onRatingChange: (p0) {},
                      initialRating: shopData['rating'] != null
                          ? double.parse(shopData['rating'])
                          : 0.0,
                      allowHalfRating: true,
                      ignoreGestures: true,
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
                          });
                        },
                        child: Text(
                          "Works",
                          style: GoogleFonts.dmSans(
                              letterSpacing: -0.5,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isAbout == false
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
                              shopData['service_address'] ?? "Loading...",
                          contactNum: shopData['contact_num'] ?? "Loading...",
                          workingHours:
                              '${shopData['service_start']} - ${shopData['service_end']}' ??
                                  "Loading...",
                        )
                      : const WorksSection()
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: uid == widget.shopUid && isAbout == false ? true : false,
        child: FloatingActionButton(
          onPressed: () {},
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
}
