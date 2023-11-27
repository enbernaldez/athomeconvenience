import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  const NoData({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Divider(
          height: 0,
        ),
        SizedBox(
          height: 10,
        ),
        Center(
          child: Text(
            "No data",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}

class DataLoading extends StatelessWidget {
  const DataLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Divider(
          height: 0,
        ),
        SizedBox(
          height: 10,
        ),
        Center(
          child: SizedBox(child: CircularProgressIndicator()),
        ),
      ],
    );
  }
}
