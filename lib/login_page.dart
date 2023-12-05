import 'package:athomeconvenience/authentication/otp_screen.dart';
import 'package:athomeconvenience/functions/functions.dart';
import 'package:athomeconvenience/navigation.dart';
import 'package:athomeconvenience/registration_page.dart';
import 'package:athomeconvenience/widgets/auth/orSeparator.dart';
import 'package:athomeconvenience/widgets/buttons.dart';
import 'package:athomeconvenience/widgets/styledButton.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogInPage extends StatefulWidget {
  final bool isRegister;

  const LogInPage({
    super.key,
    required this.isRegister,
  });

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  // bool _passwordVisible = false;
  final _loginFormKey = GlobalKey<FormState>();

  final phoneController = TextEditingController();

// ! PHONE
  Country selectedCountry = Country(
      phoneCode: '63',
      countryCode: 'PH',
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: 'Philippines',
      example: "Philippines",
      displayName: 'Philippines',
      displayNameNoCountryCode: 'PH',
      e164Key: "");

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // !  ============HANDLE CLICK================
    void handleClick() async {
      if (phoneController.text.isEmpty) {
        showToast("Please enter your number");
        print("empty");
        return;
      }

      setState(() {
        isLoading = true;
      });

      final String phoneNum =
          '+${selectedCountry.phoneCode}${phoneController.text}';

      print(phoneNum);

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNum,
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException e) {
          // throw Exception(e);
          print("error here line 57");
          print(e);
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            isLoading = false; // Set isLoading back to false here
          });
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) {
              return OtpScreen(verificationId: verificationId);
            }),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    }

    // ! =================================================

    // !=========HANDLE GOOGLE SIGN IN=====================
    void handleGoogleSignIn() async {
      setState(() {
        isLoading = true;
      });
      try {
        GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        final firestore = FirebaseFirestore.instance;

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
        print('failed to sign in with google: $e');
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: const BackArrow(),
      ),
      body: Stack(
        children: [
          Center(
            child: FractionallySizedBox(
              widthFactor: 0.8,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Column(
                  children: [
                    AutoSizeText(
                      widget.isRegister == true
                          ? 'Register your Number'
                          : 'Log In',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 96),
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 640,
                      ),
                      child: Form(
                        key: _loginFormKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: phoneController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10),
                              ],
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: 'Phone Number',
                                  contentPadding: const EdgeInsets.all(15),
                                  prefixIcon: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: InkWell(
                                      onTap: () {
                                        showCountryPicker(
                                            context: context,
                                            countryListTheme:
                                                const CountryListThemeData(
                                                    bottomSheetHeight: 400),
                                            onSelect: (value) {
                                              setState(() {
                                                selectedCountry = value;
                                              });
                                            });
                                      },
                                      child: Text(
                                        "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )),
                            ),
                            const SizedBox(height: 30),
                            // TODO: option to login or register thru gmail or fb
                            Button(
                              buttonText: widget.isRegister == true
                                  ? 'NEXT'
                                  : 'SIGN IN',
                              textType:
                                  Theme.of(context).textTheme.displaySmall,
                              onPress: handleClick,
                            ),
                            const SizedBox(height: 10),
                            widget.isRegister == true
                                ? const SizedBox()
                                : Column(
                                    children: [
                                      const Text("Don't have an account yet?"),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(builder:
                                                (BuildContext context) {
                                              return const LogInPage(
                                                isRegister: true,
                                              );
                                            }),
                                          );
                                        },
                                        child: const Text(
                                          'Click here to register.',
                                          style: TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            const SizedBox(
                              height: 20,
                            ),
                            const OrSeparator(),
                            const SizedBox(
                              height: 20,
                            ),
                            StyledButton(
                              btnText: widget.isRegister == true
                                  ? "CONTINUE WITH GOOGLE"
                                  : "SIGN IN WITH GOOGLE",
                              onClick: handleGoogleSignIn,
                              btnWidth: double.infinity,
                              noShadow: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
