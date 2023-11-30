import 'package:athomeconvenience/functions/fetch_data.dart';
import 'package:athomeconvenience/widgets/list_else.dart';
import 'package:athomeconvenience/widgets/review_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReviewsSection extends StatefulWidget {
  final String? shopUid;
  final bool shopReviews;

  const ReviewsSection({
    super.key,
    this.shopUid,
    required this.shopReviews,
  });

  @override
  State<ReviewsSection> createState() => _ReviewsSectionState();
}

class _ReviewsSectionState extends State<ReviewsSection> {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              const Divider(
                height: 0,
              ),
              const SizedBox(
                height: 10,
              ),
              FutureBuilder(
                future: widget.shopUid != null
                    ? FirebaseFirestore.instance
                        .collection('ratings')
                        .where('shop_id', isEqualTo: widget.shopUid)
                        .get()
                    : FirebaseFirestore.instance
                        .collection('ratings')
                        .where('user_id', isEqualTo: uid)
                        .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const DataLoading();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    if (snapshot.data!.docs.isNotEmpty) {
                      List<Widget> reviewWidgets = [];

                      for (QueryDocumentSnapshot doc in snapshot.data!.docs) {
                        Map<String, dynamic> shopReviewData =
                            doc.data() as Map<String, dynamic>;

                        if (widget.shopReviews == true) {
                          fetchUserDetails(shopReviewData['user_id'], 'users');
                        } else {
                          fetchUserDetails(
                              shopReviewData['shop_id'], 'service_provider');
                        }

                        DateTime strTimeStamp =
                            shopReviewData['timestamp'].toDate();
                        String timeStamp = DateFormat('MMMM dd, yyyy h:mm a')
                            .format(strTimeStamp);

                        double customerRating =
                            double.parse(shopReviewData['star_rating']);

                        reviewWidgets.add(
                          ReviewCard(
                            shopId: shopReviewData['shop_id'],
                            timeStamp: timeStamp,
                            customerRating: customerRating,
                            customerReview: shopReviewData['review'],
                            shopReviews: widget.shopReviews,
                          ),
                        );
                      }return Column(
          children: reviewWidgets,
        );

                    } else {
                      return const Text(
                        "You don't have reviews yet.",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      );
                    }
                  }
                  return const NoData();
                },
              ),
              Text(
                '--- End ---',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
