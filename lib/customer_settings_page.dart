import 'package:athomeconvenience/change_password_page.dart';
import 'package:athomeconvenience/contact_us_page.dart';
import 'package:athomeconvenience/landing_page.dart';
import 'package:athomeconvenience/terms_and_conditions_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerSettingsPage extends StatefulWidget {
  const CustomerSettingsPage({super.key});

  @override
  State<CustomerSettingsPage> createState() => _CustomerSettingsPageState();
}

class _CustomerSettingsPageState extends State<CustomerSettingsPage> {
  bool _readonly = true;
  String action = 'Edit';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.titleLarge!,
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                _readonly = !_readonly;
                action == 'Edit' ? action = 'Done' : action = 'Edit';
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                action,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: FractionallySizedBox(
                widthFactor: 0.8,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 640,
                  ),
                  child: Form(
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: 'Ben Mcdowell',
                          readOnly: _readonly,
                          decoration: const InputDecoration(
                            labelText: 'NAME',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Divider(
                            height: 1,
                          ),
                        ),
                        TextFormField(
                          initialValue: 'Tuburan, Ligao City',
                          readOnly: _readonly,
                          decoration: const InputDecoration(
                            labelText: 'ADDRESS',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Divider(
                            height: 1,
                          ),
                        ),
                        TextFormField(
                          initialValue: '0912 345 6789',
                          readOnly: _readonly,
                          decoration: const InputDecoration(
                            labelText: 'PHONE NUMBER',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Divider(
                            height: 1,
                          ),
                        ),
                        TextFormField(
                          initialValue: 'mcdowell.ben@gmail.com',
                          readOnly: _readonly,
                          decoration: const InputDecoration(
                            labelText: 'EMAIL ADDRESS',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: _readonly ?? false,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Divider(),
                  ),
                  FractionallySizedBox(
                    widthFactor: 0.8,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 640,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 8,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return const ChangePasswordPage();
                                  }),
                                );
                              },
                              child: Text(
                                'CHANGE PASSWORD',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ),
                          const Divider(height: 1),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 8,
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                // ?========set SharedPreference========
                                final SharedPreferences s =
                                    await SharedPreferences.getInstance();
                                s.setBool("is_signedin", false);
                                // ?==================================

                                await FirebaseAuth.instance.signOut();

                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            LandingPage()),
                                    (route) => false);
                              },
                              child: Text(
                                'LOG OUT',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  FractionallySizedBox(
                    widthFactor: 0.8,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 640,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 8,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return const ContactUsPage();
                                  }),
                                );
                              },
                              child: Text(
                                'CONTACT US',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ),
                          const Divider(height: 1),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 8,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return const TermsAndConditionsPage();
                                    },
                                  ),
                                );
                              },
                              child: Text(
                                'TERMS AND CONDITIONS',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
