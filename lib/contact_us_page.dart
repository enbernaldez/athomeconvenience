import 'package:athomeconvenience/widgets/buttons.dart';
import 'package:flutter/material.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Us"),
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'images/app_logo.png',
                      width: MediaQuery.sizeOf(context).width * 0.30,
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'At-Home',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(color: const Color(0xFF2F75E2)),
                        ),
                        Text(
                          'Convenience',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(color: const Color(0xFFEf8A31)),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 48.0,
                ),
                const ContactButton(
                  text: "09296835734",
                  icon: Icon(Icons.phone),
                ),
                const SizedBox(height: 16.0),
                const ContactButton(
                  text: "HomeServicesAppBUP@gmail.com",
                  icon: Icon(Icons.email),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
