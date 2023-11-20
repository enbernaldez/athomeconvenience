import 'dart:io';
import 'package:athomeconvenience/constants.dart';
import 'package:athomeconvenience/landing_page.dart';
import 'package:athomeconvenience/navigation.dart';
import 'package:athomeconvenience/widgets/buttons.dart';
import 'package:athomeconvenience/widgets/functions.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

Iterable<String> categoryKeys = serviceCategoryMap.keys;
List<String> categoryKeyList = categoryKeys.toList();

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();

  void showToast() {
    Fluttertoast.showToast(
      msg: "This is Center Short Toast",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

class _RegistrationPageState extends State<RegistrationPage> {
  // ! ====TextEditing Controllers=====
  // * USER
  final fullNameController = TextEditingController();
  final phoneNumController = TextEditingController();
  final addressController = TextEditingController();
  final emailAddressController = TextEditingController();

  // * SERVICE PROVIDER
  final serviceNameController = TextEditingController();
  final contactNumController = TextEditingController();
  final serviceAddressController = TextEditingController();
  final gcashNumController = TextEditingController();
  // !=================================

  bool? _isServiceProvider = false;
  String serviceCategory = categoryKeyList.first; //*
  final _registrationFormKey = GlobalKey<FormState>();
  XFile? image = ImageHandler.currentImage;

  // ==========Time Picker==========
  TimeOfDay? selectedTimeST; //*
  TimeOfDay? selectedTimeET; //*
  TimePickerEntryMode entryMode = TimePickerEntryMode.dialOnly;
  TextDirection textDirection = TextDirection.ltr;
  MaterialTapTargetSize tapTargetSize = MaterialTapTargetSize.padded;
  Orientation orientation = Orientation.portrait;
  bool use24HourTime = false;
  String startTime = '';
  String buttonTextST = 'Start Time';
  String buttonTextET = 'End Time';
  //================================

  @override
  Widget build(BuildContext context) {
    // !  ============HANDLE REGISTER================
    void handleRegister() async {
      final firestore = FirebaseFirestore.instance;
      String? uid = FirebaseAuth.instance.currentUser!.uid;
      final String fullName = fullNameController.text;
      final String u_address = addressController.text;
      final String u_phoneNum = phoneNumController.text;
      final String emailAdd = emailAddressController.text;

      if (fullName.isEmpty &&
          u_address.isEmpty &&
          u_phoneNum.isEmpty &&
          emailAdd.isEmpty) {
        const SnackBar(
          content: Text("Please fill up the form!"),
        );

        return;
      } else {
        // ?========= insert user details to firestore=================
        await firestore
            .collection('users')
            .doc(uid)
            .set({
              'uid': uid,
              'name': fullName,
              'address': u_address,
              'phone_num': u_phoneNum,
              'email_add': emailAdd,
              'likes': []
            })
            .then((value) => const SnackBar(
                  content: Text("User signed up Successfully!"),
                ))
            .catchError((error) {
              print(error);
              return const SnackBar(
                content: Text("Error occurred while signing up User Details!"),
              );
            });
        // ?======================================================
      }

      if (_isServiceProvider == true) {
        final String serviceName = serviceNameController.text;
        final String serviceCat = serviceCategory;
        final String serviceNum = contactNumController.text;
        final TimeOfDay? startTime = selectedTimeST;
        final TimeOfDay? endTime = selectedTimeET;
        final String serviceAddress = serviceAddressController.text;
        final String gcashNum = gcashNumController.text;
        final String? imagePath = image?.path;

        if (serviceName.isEmpty &&
            serviceCategory.isEmpty &&
            serviceNum.isEmpty &&
            startTime == null &&
            endTime == null &&
            serviceAddress.isEmpty &&
            gcashNum.isEmpty &&
            imagePath == null) {
          const SnackBar(
            content: Text("Please fill up the form!"),
          );
          return;
        } else {
          final String serviceStart = startTime!.format(context).toString();
          final String serviceEnd = endTime!.format(context).toString();

          // ?======== Upload Image First in Firebase Storage==============
          File file = File(imagePath!);

          // Generate a unique image name using UUID
          final imageName = const Uuid().v4(); // Generates a random UUID

          final storageRef = FirebaseStorage.instance
              .ref()
              .child('provider_profile')
              .child('$imageName.jpg'); // Use the unique image name

          final uploadImage = storageRef.putFile(file);

          final TaskSnapshot snapshot1 = await uploadImage;
          final imageUrl = await snapshot1.ref.getDownloadURL();
          // ?============================================================

          // ?==========insert service provider details================
          await firestore
              .collection('service_provider')
              .doc(uid)
              .set({
                'uid': uid,
                'service_provider_name': serviceName,
                'category': serviceCat,
                'contact_num': serviceNum,
                'service_start': serviceStart,
                'service_end': serviceEnd,
                'service_address': serviceAddress,
                'gcash_num': gcashNum,
                'uploaded_doc': imageUrl,
                'is_disabled': false,
              })
              .then((value) => const SnackBar(
                    content: Text("Service Provider signed up Successfully!"),
                  ))
              .catchError((error) {
                print(error);
                return const SnackBar(
                  content: Text(
                      "Error occurred while signing up Service Provider Details!"),
                );
              });
          // ?=========================================================
        }
      }

      if (image == null) {
        widget.showToast();
      }

      // ?========set SharedPreference========
      final SharedPreferences s = await SharedPreferences.getInstance();
      s.setBool("is_signedin", true);
      // ?==================================

      // ? Navigate to Navigation after successful registration
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => const Navigation()),
          (route) => false);
    }
    // ! =================================================

    return Scaffold(
      appBar: AppBar(
        leading: BackArrow(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) {
                return const LandingPage();
              }),
            );
          },
        ),
      ),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.8,
          child: SingleChildScrollView(
            // padding: const EdgeInsets.symmetric(vertical: 48),
            child: Column(
              children: [
                const SizedBox(height: 48),
                AutoSizeText(
                  'Create New Account',
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
                    key: _registrationFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: fullNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Full Name',
                            contentPadding: EdgeInsets.all(15),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: phoneNumController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            if (value.length != 11) {
                              return 'Phone number must be 11 digits';
                            }
                            return null;
                          },
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(11),
                          ],
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Phone Number',
                            contentPadding: EdgeInsets.all(15),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: addressController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Address',
                            contentPadding: EdgeInsets.all(15),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: emailAddressController,
                          validator: (value) {
                            if (!EmailValidator.validate(value!)) {
                              return 'Please enter a valid email address.';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email Address',
                            contentPadding: EdgeInsets.all(15),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.topLeft,
                          child: AutoSizeText(
                            'Are you a service provider?',
                            style: Theme.of(context).textTheme.bodyMedium!,
                            minFontSize: 16,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<bool>(
                                title: const Text('Yes'),
                                value: true,
                                groupValue: _isServiceProvider,
                                activeColor: Colors.blue,
                                onChanged: (value) {
                                  setState(() {
                                    _isServiceProvider = value;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<bool>(
                                title: const Text('No'),
                                value: false,
                                groupValue: _isServiceProvider,
                                activeColor: Colors.blue,
                                onChanged: (value) {
                                  setState(() {
                                    _isServiceProvider = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: _isServiceProvider ?? false,
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: serviceNameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Required';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Shop Name / Profile Name',
                                  contentPadding: EdgeInsets.all(15),
                                ),
                              ),
                              const SizedBox(height: 20),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  return DropdownMenu<String>(
                                    width: constraints.maxWidth,
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                    ),
                                    label: const Text('Service Category'),
                                    onSelected: (String? value) {
                                      setState(() {
                                        serviceCategory = value!;
                                      });
                                    },
                                    dropdownMenuEntries: categoryKeyList
                                        .map<DropdownMenuEntry<String>>(
                                            (String value) {
                                      return DropdownMenuEntry<String>(
                                        value: value,
                                        label: value,
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: contactNumController,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(11),
                                ],
                                validator: (value) {
                                  if (value?.length != 11 && value == null) {
                                    return 'Contact number must be 11 digits';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Contact Number',
                                  contentPadding: EdgeInsets.all(15),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.all(16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                      ),
                                      onPressed: () async {
                                        TimeOfDay? time =
                                            await showTimePickerFunction(
                                                context, selectedTimeST);
                                        setState(() {
                                          selectedTimeST = time;
                                          if (selectedTimeST != null) {
                                            buttonTextST =
                                                selectedTimeST!.format(context);
                                          }
                                        });
                                      },
                                      child: Text(
                                        buttonTextST,
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey[850],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'to',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.all(16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                      ),
                                      onPressed: () async {
                                        TimeOfDay? time =
                                            await showTimePickerFunction(
                                                context, selectedTimeST);
                                        setState(() {
                                          selectedTimeET = time;
                                          if (selectedTimeET != null) {
                                            buttonTextET =
                                                selectedTimeET!.format(context);
                                          }
                                        });
                                      },
                                      child: Text(
                                        buttonTextET,
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey[850],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: serviceAddressController,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Location',
                                  contentPadding: EdgeInsets.all(15),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: gcashNumController,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(11),
                                ],
                                validator: (value) {
                                  if (value?.length != 11 && value == null) {
                                    return 'Gcash number must be 11 digits';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'GCash Number',
                                  contentPadding: EdgeInsets.all(15),
                                ),
                              ),
                              const SizedBox(height: 20),
                              image != null
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      child: Stack(
                                        alignment: AlignmentDirectional.topEnd,
                                        children: [
                                          FullScreenWidget(
                                            disposeLevel: DisposeLevel.Low,
                                            child: Center(
                                              child: Hero(
                                                tag: 'Uploaded image',
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Image.file(
                                                    File(image!.path),
                                                    fit: BoxFit.cover,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                image = null;
                                              });
                                            },
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              shadows: [
                                                Shadow(
                                                  blurRadius: 1.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Flex(
                                      direction: Axis.horizontal,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              padding: const EdgeInsets.all(16),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                              ),
                                            ),
                                            onPressed: () {
                                              ImageHandler.uploadImage(context);
                                            },
                                            child: Text(
                                              'Upload ID / Business Permit',
                                              textAlign: TextAlign.left,
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.grey[850],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        Button(
                          buttonText: 'SUBMIT',
                          textType: Theme.of(context).textTheme.displaySmall,
                          onPress: handleRegister,
                        ),
                        const SizedBox(height: 10),
                        const Text('By signing up, you agree to the'),
                        GestureDetector(
                          onTap: () {
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //       builder: (BuildContext context) {
                            //     return const RegistrationPage();
                            //   }),
                            // );
                          },
                          child: const Text(
                            'Terms of Use and Privacy Policy',
                            style: TextStyle(
                              color: Colors.blue,
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
        ),
      ),
    );
  }
}
