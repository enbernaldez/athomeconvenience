import 'package:athomeconvenience/functions/fetch_data.dart';
import 'package:athomeconvenience/widgets/buttons.dart';
import 'package:athomeconvenience/widgets/shopProfileView/reviews.dart';
import 'package:athomeconvenience/widgets/star_rating.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReviewsPage extends StatefulWidget {
  final String whatReview;
  final bool shopReviews;

  const ReviewsPage({
    super.key,
    required this.whatReview,
    required this.shopReviews,
  });

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    fetchAverageRating(context, uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackArrow(),
        title: Text(widget.whatReview),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: FractionallySizedBox(
            widthFactor: 0.85,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Visibility(
                    visible: widget.shopReviews == true,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: strAverageRating,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                      ),
                                      const TextSpan(text: '/5'),
                                    ],
                                  ),
                                ),
                                Text(
                                  '$numberOfRatings reviews',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                            const Expanded(child: SizedBox()),
                            StarRating(
                              onRatingChange: (p0) {},
                              initialRating: averageRating ?? 0.0,
                              allowHalfRating: true,
                              ignoreGestures: true,
                            ),
                          ],
                        ),
                        ReviewsSection(
                          shopUid: uid,
                          shopReviews: widget.shopReviews,
                        ), // review for a specific shop
                      ],
                    ),
                  ),
                  Visibility(
                    visible: widget.shopReviews == false,
                    child: ReviewsSection(
                      shopReviews: widget.shopReviews,
                    ), // reviews of a specifc user
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
