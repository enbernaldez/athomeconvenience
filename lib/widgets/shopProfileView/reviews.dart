import 'package:athomeconvenience/functions/fetch_data.dart';
import 'package:athomeconvenience/widgets/list_else.dart';
import 'package:athomeconvenience/widgets/review_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReviewsSection extends StatefulWidget {
  final String shopUid;

  const ReviewsSection({
    super.key,
    required this.shopUid,
  });

  @override
  State<ReviewsSection> createState() => _ReviewsSectionState();
}

class _ReviewsSectionState extends State<ReviewsSection> {
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
                future: FirebaseFirestore.instance
                    .collection('ratings')
                    .where('shop_id', isEqualTo: widget.shopUid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const DataLoading();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    if (snapshot.data!.docs.isNotEmpty) {
                      var shopReview = snapshot.data!.docs.first.data();
                      print(shopReview);

                      fetchUserDetails(shopReview['user_id']);

                      DateTime strTimeStamp = shopReview['timestamp'].toDate();
                      String timeStamp = DateFormat('MMMM dd, yyyy h:mm a')
                          .format(strTimeStamp);

                      double customerRating = double.parse(shopReview['star_rating']);

                      return ReviewCard(
                        customerId: shopReview['user_id'],
                        timeStamp: timeStamp,
                        customerRating: customerRating,
                        customerReview: shopReview['review'],
                      );
                    } else {
                      return const NoData();
                    }
                  } else {
                    return const NoData();
                  }
                },
              ),
              Text(
                '--- End ---',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.grey,
                    ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
