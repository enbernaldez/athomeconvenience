import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class StarRating extends StatefulWidget {
  final Function(double)? onRatingChange;
  final double? initialRating;
  final bool? allowHalfRating;
  final bool? ignoreGestures;

  const StarRating({
    super.key,
    required this.onRatingChange,
    this.initialRating,
    this.allowHalfRating,
    this.ignoreGestures,
  });

  @override
  State<StarRating> createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      glow: false,
      itemSize: 30,
      itemPadding: const EdgeInsets.symmetric(
        horizontal: 3.0,
      ),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      initialRating: widget.initialRating ?? 0.0,
      allowHalfRating: widget.allowHalfRating ?? false,
      ignoreGestures: widget.ignoreGestures ?? false,
      onRatingUpdate: widget.onRatingChange ?? (rating) {},
    );
  }
}
