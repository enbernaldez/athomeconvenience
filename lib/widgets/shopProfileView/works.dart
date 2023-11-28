import 'package:flutter/material.dart';

class WorksSection extends StatelessWidget {
  const WorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "This is the Works Section. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
