import 'package:athomeconvenience/navigation.dart';
import 'package:athomeconvenience/registration_page.dart';
import 'package:athomeconvenience/widgets/buttons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;

  const OtpScreen({
    super.key,
    required this.verificationId,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final otpController = TextEditingController();

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    void handleClick() async {
      if (otpController.text.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        final auth = FirebaseAuth.instance;
        final firestore = FirebaseFirestore.instance;
        try {
          PhoneAuthCredential phoneAuthCredential =
              PhoneAuthProvider.credential(
                  verificationId: widget.verificationId,
                  smsCode: otpController.text);

          // ! result of verification
          UserCredential userCredential =
              await auth.signInWithCredential(phoneAuthCredential);

          print('User signed in: ${userCredential.user}');

          setState(() {
            isLoading = false;
          });

          if (userCredential.user != null) {
            // ! check the firestore for user details
            final userDetails = await firestore
                .collection('users')
                .where("uid", isEqualTo: userCredential.user!.uid)
                .get();

            if (userDetails.docs.isNotEmpty) {
              // ! if it is not empty then user has an account

              // ?========set SharedPreference========
              final SharedPreferences s = await SharedPreferences.getInstance();
              s.setBool("is_signedin", true);
              // ?==================================

              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const Navigation(),
                  ),
                  (route) => false);
            } else {
              // ! empty == no account yet
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => const RegistrationPage(),
                ),
              );
            }
          }
        } catch (e) {
          print('Error verifying OTP: $e');
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.blue,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  AutoSizeText(
                    'Verification',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text("Enter the OTP sent to your phone number"),
                  const SizedBox(
                    height: 10,
                  ),
                  // VERIFICATION CODE INPUT
                  Pinput(
                    length: 6,
                    controller: otpController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // VERIFY BUTTON
                  Button(
                    buttonText: 'VERIFY',
                    textType: Theme.of(context).textTheme.displaySmall,
                    onPress: handleClick,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text("Didn't receive any code?"),
                  const Text(
                    "Resend new code",
                    style: TextStyle(color: Colors.blue),
                  )
                ],
              ),
            ),
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            )
        ],
      ),
    );
  }
}
