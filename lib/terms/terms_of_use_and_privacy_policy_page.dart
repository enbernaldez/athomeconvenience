import 'package:athomeconvenience/widgets/buttons.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';

class TermsOfUseAndPrivacyPolicy extends StatefulWidget {
  const TermsOfUseAndPrivacyPolicy({super.key});

  @override
  State<TermsOfUseAndPrivacyPolicy> createState() =>
      _TermsOfUseAndPrivacyPolicyState();
}

class _TermsOfUseAndPrivacyPolicyState
    extends State<TermsOfUseAndPrivacyPolicy> {
  String termsOfUseAndPrivacyPolicy = "";

  @override
  void initState() {
    super.initState();
    _loadTermsOfUseAndPrivacyPolicy();
  }

  Future<void> _loadTermsOfUseAndPrivacyPolicy() async {
    final String text =
        await rootBundle.loadString('terms/terms_of_use_and_privacy_policy.md');
    setState(() {
      termsOfUseAndPrivacyPolicy = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackArrow(),
        title: Text(
          'Terms of Use and Privacy Policy',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        titleSpacing: 0,
        centerTitle: true,
      ),
      body: Markdown(data: termsOfUseAndPrivacyPolicy),
    );
  }
}
