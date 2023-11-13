import 'package:athomeconvenience/authentication/otp_screen.dart';
import 'package:athomeconvenience/navigation.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'registration_page.dart';
import 'package:athomeconvenience/forgot_password_page.dart';

class LogInPage extends StatefulWidget {
  bool isRegister;
  LogInPage({super.key, required this.isRegister});

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

  @override
  Widget build(BuildContext context) {
    // !  ============HANDLE CLICK================
    void handleClick() async {
      if (phoneController.text.isEmpty) {
        print("empty");
        return;
      }

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
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  OtpScreen(verificationId: verificationId),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    }

    // ! =================================================
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
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.8,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: Column(
              children: [
                AutoSizeText(
                  widget.isRegister == true ? 'Register your Number' : 'Log In',
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
                              contentPadding: EdgeInsets.all(15),
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
                        // const SizedBox(height: 20),
                        // TextFormField(
                        //   validator: (value) {
                        //     if (value == null || value.isEmpty) {
                        //       return 'Required';
                        //     }
                        //     return null;
                        //   },
                        //   obscureText: !_passwordVisible,
                        //   inputFormatters: [
                        //     LengthLimitingTextInputFormatter(11),
                        //   ],
                        //   keyboardType: TextInputType.text,
                        //   decoration: InputDecoration(
                        //     border: const OutlineInputBorder(),
                        //     labelText: 'Password',
                        //     contentPadding: const EdgeInsets.all(15),
                        //     suffixIcon: IconButton(
                        //       icon: Icon(
                        //         _passwordVisible
                        //             ? Icons.visibility
                        //             : Icons.visibility_off,
                        //       ),
                        //       onPressed: () {
                        //         setState(() {
                        //           _passwordVisible = !_passwordVisible;
                        //         });
                        //       },
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(height: 5),
                        // Row(
                        //   children: [
                        //     const Text('Forgot password? '),
                        //     GestureDetector(
                        //       onTap: () {
                        //         Navigator.of(context).push(
                        //           MaterialPageRoute(
                        //             builder: (BuildContext context) {
                        //               return const ForgotPasswordPage();
                        //             },
                        //           ),
                        //         );
                        //       },
                        //       child: const Text(
                        //         'Click here.',
                        //         style: TextStyle(
                        //           color: Colors.blue,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        const SizedBox(height: 30),
                        FractionallySizedBox(
                          widthFactor: 1,
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: handleClick,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              child: Text(
                                widget.isRegister == true ? 'NEXT' : 'SIGN IN',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        widget.isRegister == true
                            ? SizedBox()
                            : Column(
                                children: [
                                  const Text("Don't have an account yet?"),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
                                          return LogInPage(
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
                              )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
