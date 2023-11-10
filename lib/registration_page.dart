import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:full_screen_image/full_screen_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'landing_page.dart';

// void addUserToFirestore() async {
//   // Create a new user with a first and last name
//   final user = <String, dynamic>{
//     "fullName": "test",
//     "phoneNumber": "09123456789",
//     "address": "qwertyuiop",
//     "emailAddress": "asdfghjkl",
//     "password": "qazwsxedcrfvtgb",
//     "profileName": "",
//     "category": "",
//     "contactNumber": "",
//     "workingHours": "",
//     "location": "",
//     "gcashNumber": "",
//     "forPhotoVerification": "",
//   };

//   // Get a reference to your Firestore database
//   final db = FirebaseFirestore.instance;

//   // Add a new document with a generated ID
//   await db.collection("users").add(user).then((DocumentReference doc) =>
//       print('DocumentSnapshot added with ID: ${doc.id}'));
// }

List<String> serviceCategoryList = <String>[
  'Electrical',
  'Handyman',
  'Bodygroomer',
  'Plumber',
  'Cleaning',
  'Technician',
  'Greenscaping',
  'Pet Care',
];

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool _passwordVisible = false;
  bool? _isServiceProvider = false;
  String serviceCategory = serviceCategoryList.first;
  final _registrationFormKey = GlobalKey<FormState>();
  TimeOfDay? selectedTimeST;
  TimeOfDay? selectedTimeET;
  TimePickerEntryMode entryMode = TimePickerEntryMode.dialOnly;
  TextDirection textDirection = TextDirection.ltr;
  MaterialTapTargetSize tapTargetSize = MaterialTapTargetSize.padded;
  Orientation orientation = Orientation.portrait;
  bool use24HourTime = false;
  String startTime = '';
  String buttonTextST = 'Start Time';
  String buttonTextET = 'End Time';
  XFile? image;
  final ImagePicker picker = ImagePicker();

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
  }

  void myAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Text('Upload'),
          content: SizedBox(
            height: MediaQuery.of(context).size.height / 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    side: const BorderSide(color: Colors.blueAccent),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    getImage(ImageSource.gallery);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.image,
                        color: Colors.blue[700],
                      ),
                      const SizedBox(width: 8),
                      const Text('From Gallery'),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    side: const BorderSide(color: Colors.blueAccent),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    getImage(ImageSource.camera);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.camera,
                        color: Colors.blue[700],
                      ),
                      const SizedBox(width: 8),
                      const Text('From Camera'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.blue,
          ),
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
            padding: const EdgeInsets.symmetric(vertical: 48),
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
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Address',
                            contentPadding: EdgeInsets.all(15),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
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
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Password',
                            contentPadding: const EdgeInsets.all(15),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
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
                                    dropdownMenuEntries: serviceCategoryList
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
                                        TimeOfDay? time = await showTimePicker(
                                          context: context,
                                          initialTime:
                                              selectedTimeST ?? TimeOfDay.now(),
                                          initialEntryMode: entryMode,
                                          orientation: orientation,
                                          builder: (BuildContext context,
                                              Widget? child) {
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                materialTapTargetSize:
                                                    tapTargetSize,
                                              ),
                                              child: Directionality(
                                                textDirection: textDirection,
                                                child: MediaQuery(
                                                  data: MediaQuery.of(context)
                                                      .copyWith(
                                                    alwaysUse24HourFormat:
                                                        use24HourTime,
                                                  ),
                                                  child: child!,
                                                ),
                                              ),
                                            );
                                          },
                                        );
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
                                        TimeOfDay? time = await showTimePicker(
                                          context: context,
                                          initialTime:
                                              selectedTimeET ?? TimeOfDay.now(),
                                          initialEntryMode: entryMode,
                                          orientation: orientation,
                                          builder: (BuildContext context,
                                              Widget? child) {
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                materialTapTargetSize:
                                                    tapTargetSize,
                                              ),
                                              child: Directionality(
                                                textDirection: textDirection,
                                                child: MediaQuery(
                                                  data: MediaQuery.of(context)
                                                      .copyWith(
                                                    alwaysUse24HourFormat:
                                                        use24HourTime,
                                                  ),
                                                  child: child!,
                                                ),
                                              ),
                                            );
                                          },
                                        );
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
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Location',
                                  contentPadding: EdgeInsets.all(15),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
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
                                              myAlert();
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
                        FractionallySizedBox(
                          widthFactor: 1,
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_registrationFormKey.currentState!
                                    .validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Processing Data')),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              child: AutoSizeText(
                                'SUBMIT',
                                style: Theme.of(context).textTheme.titleMedium,
                                minFontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text('By signing up, you agree to the'),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return const RegistrationPage();
                              }),
                            );
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
