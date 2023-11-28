import 'package:athomeconvenience/functions/fetch_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class ReviewCard extends StatelessWidget {
  final String customerId;
  final String timeStamp;
  final double customerRating;
  final String customerReview;

  const ReviewCard({
    super.key,
    required this.customerId,
    required this.timeStamp,
    required this.customerRating,
    required this.customerReview,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customerName,
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        timeStamp,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
                RatingBarIndicator(
                  rating: customerRating,
                  itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemSize: 15.0,
                )
              ],
            ),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              customerReview,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
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
