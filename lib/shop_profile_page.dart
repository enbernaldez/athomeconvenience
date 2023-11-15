import 'package:athomeconvenience/widgets/shopProfileView/about.dart';
import 'package:athomeconvenience/widgets/shopProfileView/works.dart';
import 'package:athomeconvenience/widgets/styledButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ShopProfilePage extends StatefulWidget {
  final String shopUid;
  const ShopProfilePage({super.key, required this.shopUid});

  @override
  State<ShopProfilePage> createState() => _ShopProfilePageState();
}

class _ShopProfilePageState extends State<ShopProfilePage> {
  Map<String, dynamic> shopData = {};
  List<String> userLikes = [];

  @override
  void initState() {
    super.initState();
    fetchShopData();
    fetchUserLikes();
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

  bool isAbout = true;
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    print(shopData);

    void handleLike() async {
      try {
        final uid = FirebaseAuth.instance.currentUser!.uid;

        // Fetch the user document
        var userQuerySnapshot = await FirebaseFirestore.instance
            .collection("users")
            .where("uid", isEqualTo: uid)
            .get();

        if (userQuerySnapshot.docs.isNotEmpty) {
          // Access the first document, assuming unique UIDs
          var userDocRef = userQuerySnapshot.docs.first.reference;

          // Update the 'likes' field in the document
          userDocRef.update({
            'likes': FieldValue.arrayUnion([shopData['uid']])
          });
          // 'new_like_item' can be the item you want to add to the 'likes' array
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
      appBar: AppBar(),
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
                    // minRadius: 30,
                    maxRadius: 60,
                  ),
                  //temporary grey circle muna
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

                  // STAR RATING (wala pang backend)
                  RatingBar.builder(
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 30,
                    itemPadding: const EdgeInsets.symmetric(
                      horizontal: 3.0,
                    ),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                  ),

                  // MESSAGE AND LIKE/HEART
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      // *message btn
                      Expanded(
                        child: StyledButton(
                          btnText: "MESSAGE",
                          onClick: () {
                            // TODO NAVIGATE TO CONVERSATION PAGE
                            // TODO PASS THE SHOP UID & SHOP NAME TO THE CONVERSATION PAGE
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (BuildContext context) => Conversation(
                            //         shopUid: shopData['uid'],
                            //         shopName:
                            //             shopeData['service_provider_name']),
                            //   ),
                            // );
                          },
                          noShadow: true,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),

                      // * like btn
                      Container(
                        decoration: const BoxDecoration(
                            color: Color(0xFF00A2FF),
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: IconButton(
                          onPressed: isLiked == true ? null : handleLike,
                          icon: const Icon(
                            Icons.favorite,
                            color: Colors.white,
                          ),
                        ),
                      )
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
                          category: shopData['category'] ?? "Loading",
                          shopAddress: shopData['service_address'] ?? "Loading",
                          contactNum: shopData['contact_num'] ?? "Loading",
                          workingHours:
                              '${shopData['service_start']} - ${shopData['service_end']}' ??
                                  "Loading",
                        )
                      : const WorksSection()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
