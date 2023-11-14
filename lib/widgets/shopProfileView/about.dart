import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
                  "Category:",
                  style: GoogleFonts.dmSans(
                      fontSize: 16, color: Colors.grey.shade600),
                ),
              ),
              Expanded(
                child: Text(
                  category,
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Location:",
                  style: GoogleFonts.dmSans(
                      fontSize: 16, color: Colors.grey.shade600),
                ),
              ),
              Expanded(
                child: Text(
                  shopAddress,
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Contact Number:",
                  style: GoogleFonts.dmSans(
                      fontSize: 16, color: Colors.grey.shade600),
                ),
              ),
              Expanded(
                child: Text(
                  contactNum,
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Working Hours:",
                  style: GoogleFonts.dmSans(
                      fontSize: 16, color: Colors.grey.shade600),
                ),
              ),
              Expanded(
                child: Text(
                  workingHours,
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Payment Options:",
                  style: GoogleFonts.dmSans(
                      fontSize: 16, color: Colors.grey.shade600),
                ),
              ),
              Expanded(
                child: Text(
                  "Gcash, Cash",
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
