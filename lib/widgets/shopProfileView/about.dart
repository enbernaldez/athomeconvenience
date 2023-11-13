import 'package:flutter/material.dart';

class AboutSection extends StatelessWidget {
  final String category;
  final String shopAddress;
  final String contactNum;
  final String workingHours;

  const AboutSection(
      {super.key,
      required this.category,
      required this.shopAddress,
      required this.contactNum,
      required this.workingHours});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Category",
                  style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                ),
              ),
              Expanded(
                child: Text(
                  category,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Location",
                  style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                ),
              ),
              Expanded(
                child: Text(
                  shopAddress,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Contact Number",
                  style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                ),
              ),
              Expanded(
                child: Text(
                  contactNum,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Working Hours",
                  style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                ),
              ),
              Expanded(
                child: Text(
                  workingHours,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Payment Options",
                  style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                ),
              ),
              Expanded(
                child: Text(
                  "Gcash, Cash",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
