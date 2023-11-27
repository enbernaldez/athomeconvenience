import 'package:athomeconvenience/functions/functions.dart';
import 'package:athomeconvenience/likes_page.dart';
import 'package:athomeconvenience/shop_profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShopCard extends StatelessWidget {
  final String shopName;
  final String shopAddress;
  final String shopUid;
  final bool? deleteMode;

  const ShopCard({
    super.key,
    required this.shopName,
    required this.shopAddress,
    required this.shopUid,
    this.deleteMode,
  });

  @override
  Widget build(BuildContext context) {
    double widthFactor = 0.6;
    if (deleteMode == true) {
      widthFactor = 0.472;
    }

    void handleUnlike() async {
      try {
        final String uid = FirebaseAuth.instance.currentUser!.uid;
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
          if (currentLikes.contains(shopUid)) {
            userDocRef.update({
              'likes': FieldValue.arrayRemove([shopUid])
            });
          } else {
            showToast('$shopName have been unliked.');
          }
        } else {
          showToast('$shopName have been unliked.');
        }
      } catch (e) {
        print(e);
      }
    }

    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        const Divider(
          height: 0,
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ShopProfilePage(shopUid: shopUid),
                    ),
                  );
                },
                child: Row(
                  children: [
                    // Image/Icon
                    const CircleAvatar(
                      backgroundImage:
                          AssetImage('images/default_profile_pic.png'),
                      maxRadius: 30,
                    ),

                    const SizedBox(
                      width: 10, // Adjusted width for better spacing
                    ),

                    // Flexible Column
                    SizedBox(
                      width: MediaQuery.of(context).size.width * widthFactor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SHOP NAME
                          Text(
                            shopName,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: Colors.black),
                          ),

                          // Address
                          Text(
                            shopAddress,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: deleteMode ?? false,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        handleUnlike();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
