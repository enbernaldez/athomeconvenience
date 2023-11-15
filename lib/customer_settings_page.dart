import 'package:athomeconvenience/contact_us_page.dart';
import 'package:athomeconvenience/landing_page.dart';
import 'package:athomeconvenience/terms_and_conditions_page.dart';
import 'package:athomeconvenience/widgets/profile_pic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneNumController = TextEditingController();
  final emailAddController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      var documentSnapshot =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();

      if (documentSnapshot.exists) {
        // Access the data within the document
        var userData = documentSnapshot.data();
        if (userData != null) {
          // Access specific fields within userData
          // var username = userData['username'];
          // var email = userData['email'];
          // // Use the retrieved data as needed
          // print('Username: $username');
          // print('Email: $email');
          setState(() {
            nameController.text = userData['name'] ?? 'Loading';
            addressController.text = userData['address'] ?? 'Loading';
            phoneNumController.text = userData['phone_num'] ?? 'Loading';
            emailAddController.text = userData['email_add'] ?? 'Loading';
          });
        }
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print(e);
    }
  }

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
            onTap: () async {
              if (action == "Done") {
                try {
                  final String newName = nameController.text;
                  final String newAddress = addressController.text;
                  final String newPhoneNum = phoneNumController.text;
                  final String newEmailAdd = emailAddController.text;

                  final uid = FirebaseAuth.instance.currentUser!.uid;

                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .update({
                    'name': newName,
                    'address': newAddress,
                    'phone_num': newPhoneNum,
                    'email_add': newEmailAdd,
                  });
                } catch (e) {
                  print(e);
                }
              }
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
                        ProfilePic(
                          edit: !_readonly,
                          iconSize: 20,
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: nameController,
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
                          controller: addressController,
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
                          controller: phoneNumController,
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
                          controller: emailAddController,
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
                      child: Padding(
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
                                        const LandingPage()),
                                (route) => false);
                          },
                          child: Text(
                            'LOG OUT',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
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
