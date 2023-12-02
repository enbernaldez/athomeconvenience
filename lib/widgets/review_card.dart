import 'package:athomeconvenience/functions/fetch_data.dart';
import 'package:athomeconvenience/shop_profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class ReviewCard extends StatefulWidget {
  final String customerName;
  final String shopId;
  final String timeStamp;
  final double customerRating;
  final String customerReview;
  final bool shopReviews;

  const ReviewCard({
    super.key,
    required this.customerName,
    required this.shopId,
    required this.timeStamp,
    required this.customerRating,
    required this.customerReview,
    required this.shopReviews,
  });

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: widget.shopReviews == true,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.customerName,
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.timeStamp,
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ],
                    ),
                  ),
                  RatingBarIndicator(
                    rating: widget.customerRating,
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemSize: 15.0,
                  )
                ],
              ),
            ),
            Visibility(
              visible: widget.shopReviews == false,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ShopProfilePage(shopUid: widget.shopId),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight: 50,
                                  maxWidth:
                                      MediaQuery.sizeOf(context).width * 0.64,
                                ),
                                child: Text(
                                  shopName,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(
                                width: 8.0,
                              ),
                              const Text('>'),
                            ],
                          ),
                        ),
                        RatingBarIndicator(
                          rating: widget.customerRating,
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemSize: 15.0,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: <TextSpan>[
                        TextSpan(
                          text: widget.customerRating.toString(),
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const TextSpan(text: '/5'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              widget.customerReview,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
            Visibility(
              visible: widget.shopReviews == false,
              child: Column(
                children: [
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    widget.timeStamp,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        const Divider(
          height: 0,
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
