import 'package:athomeconvenience/widgets/buttons.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class TermsAndConditionsPage extends StatefulWidget {
  const TermsAndConditionsPage({super.key});

  @override
  State<TermsAndConditionsPage> createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  String termsAndConditions = "";

  @override
  void initState() {
    super.initState();
    _loadTermsAndConditions();
  }

  Future<void> _loadTermsAndConditions() async {
    final String text =
        await rootBundle.loadString('terms/terms_and_conditions.md');
    setState(() {
      termsAndConditions = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackArrow(),
        title: const Text('Terms and Conditions'),
        centerTitle: true,
      ),
      body: Markdown(data: termsAndConditions),
    );
  }
}
