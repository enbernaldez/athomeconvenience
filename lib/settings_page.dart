import 'dart:io';
import 'package:athomeconvenience/contact_us_page.dart';
import 'package:athomeconvenience/functions/constants.dart';
import 'package:athomeconvenience/functions/fetch_data.dart';
import 'package:athomeconvenience/functions/functions.dart';
import 'package:athomeconvenience/landing_page.dart';
import 'package:athomeconvenience/reviews_page.dart';
import 'package:athomeconvenience/shop_profile_page.dart';
import 'package:athomeconvenience/terms/terms_and_conditions_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

Iterable<String> categoryKeys = serviceCategoryMap.keys;
List<String> categoryKeyList = categoryKeys.toList();

class CustomerSettingsPage extends StatefulWidget {
  const CustomerSettingsPage({super.key});

  @override
  State<CustomerSettingsPage> createState() => _CustomerSettingsPageState();
}

class _CustomerSettingsPageState extends State<CustomerSettingsPage> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  XFile? image; //*
  final ImagePicker picker = ImagePicker();

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
  }

  void uploadImage() {
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

  bool _readonly = true;
  String action = 'Edit';

  TimeOfDay? selectedTimeST; //*
  TimeOfDay? selectedTimeET; //*

  String profilePic = '';
  final nameController = TextEditingController();
  final phoneNumController = TextEditingController();
  final addressController = TextEditingController();
  final emailAddController = TextEditingController();
  final profileNameController = TextEditingController();
  String serviceCategory = categoryKeyList.first; //*
  final servicesOfferedController = TextEditingController();
  final contactNumController = TextEditingController();
  String startTime = 'Start Time';
  String endTime = 'End Time';
  final locationController = TextEditingController();
  final gCashNumController = TextEditingController();
  bool isDisabled = false;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
    checkIfServiceProvider();
  }

  Future<void> fetchUserDetails() async {
    try {
      var cDocumentSnapshot =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();

      if (cDocumentSnapshot.exists) {
        // Access the data within the document
        var cData = cDocumentSnapshot.data();
        if (cData != null) {
          // Access specific fields within userData
          // var username = userData['username'];
          // var email = userData['email'];
          // // Use the retrieved data as needed
          // print('Username: $username');
          // print('Email: $email');
          setState(() {
            profilePic = cData['profile_pic'] ?? 'null';
            nameController.text = cData['name'] ?? 'Loading';
            addressController.text = cData['address'] ?? 'Loading';
            phoneNumController.text = cData['phone_num'] ?? 'Loading';
            emailAddController.text = cData['email_add'] ?? 'Loading';
          });
        }
      } else {
        print('User document does not exist');
      }

      var spDocumentSnapshot = await FirebaseFirestore.instance
          .collection("service_provider")
          .doc(uid)
          .get();

      if (spDocumentSnapshot.exists) {
        var spData = spDocumentSnapshot.data();
        if (spData != null) {
          setState(() {
            String? placeHolder;
            if (!spDocumentSnapshot.data()!.containsKey('services_offered')) {
              placeHolder = "";
            }

            profileNameController.text =
                spData['service_provider_name'] ?? 'Loading';
            serviceCategory = spData['category'] ?? "Loading";
            servicesOfferedController.text =
                spData['services_offered'] ?? placeHolder ?? 'Loading';
            contactNumController.text = spData['contact_num'] ?? 'Loading';
            startTime = spData['service_start'] ?? "Loading";
            endTime = spData['service_end'] ?? "Loading";
            locationController.text = spData['service_address'] ?? 'Loading';
            gCashNumController.text = spData['gcash_num'] ?? 'Loading';
            isDisabled = spData['disabled'] ?? 'false';
          });
        }
      } else {
        print('Service provider document does not exist');
      }
    } catch (e) {
      print(e);
    }
  }

  bool _isServiceProvider = false;

  Future<void> checkIfServiceProvider() async {
    print('uid: $uid');
    print('_isServiceProvider = $_isServiceProvider');
    bool exists = await isServiceProvider();
    if (exists) {
      setState(() {
        _isServiceProvider = exists;
        print(_isServiceProvider);
      });
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
                  final String? imagePath = image?.path;

                  final String newName = nameController.text;
                  final String newAddress = addressController.text;
                  final String newPhoneNum = phoneNumController.text;
                  final String newEmailAdd = emailAddController.text;

                  final String newProfileName = profileNameController.text;
                  final String newServiceCat = serviceCategory;
                  final String newServicesOffered =
                      servicesOfferedController.text;
                  final String newContactNum = contactNumController.text;
                  final String newStartTime = startTime;
                  final String newEndTime = endTime;
                  final String newLocation = locationController.text;
                  final String newGCashNum = gCashNumController.text;

                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .update({
                    'name': newName,
                    'address': newAddress,
                    'phone_num': newPhoneNum,
                    'email_add': newEmailAdd,
                  });
                  await FirebaseFirestore.instance
                      .collection('service_provider')
                      .doc(uid)
                      .update({
                    'service_provider_name': newProfileName,
                    'category': newServiceCat,
                    'services_offered': newServicesOffered,
                    'contact_num': newContactNum,
                    'service_start': newStartTime,
                    'service_end': newEndTime,
                    'service_address': newLocation,
                    'gcash_num': newGCashNum,
                  });

                  // ?======== Upload Image First in Firebase Storage ==============
                  File file = File(imagePath!);

                  // Generate a unique image name using UUID
                  final imageName =
                      const Uuid().v4(); // Generates a random UUID

                  final storageRef = FirebaseStorage.instance
                      .ref()
                      .child('profile_pic')
                      .child('$imageName.jpg'); // Use the unique image name

                  final uploadImage = storageRef.putFile(file);

                  final TaskSnapshot snapshot1 = await uploadImage;
                  final imageUrl = await snapshot1.ref.getDownloadURL();
                  // ?==============================================================

                  final userDoc =
                      FirebaseFirestore.instance.collection('users').doc(uid);
                  final userDocSnapshot = await userDoc.get();

                  if (!userDocSnapshot.exists ||
                      !userDocSnapshot.data()!.containsKey('profile_pic')) {
                    await userDoc.set({
                      'profile_pic': imageUrl,
                    }, SetOptions(merge: true));
                  } else {
                    await userDoc.update({'profile_pic': imageUrl});
                  }

                  final spDoc = FirebaseFirestore.instance
                      .collection('service_provider')
                      .doc(uid);
                  final spDocSnapshot = await spDoc.get();

                  if (!spDocSnapshot.exists ||
                      !spDocSnapshot.data()!.containsKey('profile_pic')) {
                    await spDoc.set({
                      'profile_pic': imageUrl,
                    }, SetOptions(merge: true));
                  } else {
                    await spDoc.update({'profile_pic': imageUrl});
                  }

                  if (!spDocSnapshot.exists ||
                      !spDocSnapshot.data()!.containsKey('services_offered')) {
                    await spDoc.set({
                      'services_offered': newServicesOffered,
                    }, SetOptions(merge: true));
                  } else {
                    await spDoc
                        .update({'services_offered': newServicesOffered});
                  }
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
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            (image != null)
                                ? CircleAvatar(
                                    backgroundImage:
                                        FileImage(File(image!.path)),
                                    maxRadius: 60,
                                  )
                                : (profilePic != "null")
                                    ? CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(profilePic),
                                        maxRadius: 60,
                                      )
                                    : const CircleAvatar(
                                        backgroundImage: AssetImage(
                                            'images/default_profile_pic.png'),
                                        maxRadius: 60,
                                      ),
                            Visibility(
                              visible: !_readonly,
                              child: FractionallySizedBox(
                                widthFactor: 0.12,
                                child: Container(
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blueGrey,
                                  ),
                                  child: IconButton(
                                    padding: const EdgeInsets.all(0.0),
                                    onPressed: () {
                                      uploadImage();
                                    },
                                    icon: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: nameController,
                          keyboardType: TextInputType.text,
                          readOnly: _readonly,
                          decoration: const InputDecoration(
                            labelText: 'NAME',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                        const PaddedDivider(),
                        TextFormField(
                          controller: addressController,
                          keyboardType: TextInputType.text,
                          readOnly: _readonly,
                          decoration: const InputDecoration(
                            labelText: 'ADDRESS',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                        const PaddedDivider(),
                        TextFormField(
                          controller: phoneNumController,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(11),
                          ],
                          keyboardType: TextInputType.phone,
                          readOnly: _readonly,
                          decoration: const InputDecoration(
                            labelText: 'PHONE NUMBER',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                        const PaddedDivider(),
                        TextFormField(
                          controller: emailAddController,
                          keyboardType: TextInputType.emailAddress,
                          readOnly: _readonly,
                          decoration: const InputDecoration(
                            labelText: 'EMAIL ADDRESS',
                            hintText: 'Add your email address',
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
              visible: _isServiceProvider,
              child: Center(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Divider(),
                    ),
                    FractionallySizedBox(
                      widthFactor: 0.8,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 640,
                        ),
                        child: Form(
                          child: Column(
                            children: [
                              TextFormField(
                                controller: profileNameController,
                                keyboardType: TextInputType.text,
                                readOnly: _readonly,
                                decoration: const InputDecoration(
                                  labelText: 'PROFILE NAME',
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 8),
                                ),
                              ),
                              const PaddedDivider(),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  return IgnorePointer(
                                    ignoring: _readonly,
                                    child: DropdownMenu<String>(
                                      width: constraints.maxWidth,
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                      ),
                                      label: const Text('SERVICE CATEGORY'),
                                      initialSelection: serviceCategory,
                                      inputDecorationTheme:
                                          const InputDecorationTheme(
                                        contentPadding: EdgeInsets.fromLTRB(
                                            8.0, 8.0, 8.0, 4.0),
                                        border: InputBorder.none,
                                      ),
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
                                    ),
                                  );
                                },
                              ),
                              const PaddedDivider(),
                              TextFormField(
                                controller: servicesOfferedController,
                                keyboardType: TextInputType.text,
                                readOnly: _readonly,
                                decoration: const InputDecoration(
                                  labelText: 'SERVICES OFFERED',
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 8),
                                ),
                              ),
                              const PaddedDivider(),
                              TextFormField(
                                controller: contactNumController,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(11),
                                ],
                                keyboardType: TextInputType.phone,
                                readOnly: _readonly,
                                decoration: const InputDecoration(
                                  labelText: 'CONTACT NUMBER',
                                  hintText: 'Add your contact number',
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 8),
                                ),
                              ),
                              const PaddedDivider(),
                              Stack(
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 8.0,
                                      ),
                                      Text(
                                        "WORKING HOURS",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(color: Colors.grey[800]),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.all(0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                            side: BorderSide.none,
                                          ),
                                          onPressed: _readonly
                                              ? null
                                              : () async {
                                                  TimeOfDay? time =
                                                      await showTimePickerFunction(
                                                          context,
                                                          selectedTimeST);
                                                  setState(() {
                                                    selectedTimeST = time;
                                                    if (selectedTimeST !=
                                                        null) {
                                                      startTime =
                                                          selectedTimeST!
                                                              .format(context);
                                                    }
                                                  });
                                                },
                                          child: Container(
                                            width: MediaQuery.sizeOf(context)
                                                .width,
                                            height: 50,
                                            alignment: Alignment.bottomCenter,
                                            padding: const EdgeInsets.only(
                                                bottom: 8),
                                            child: Text(
                                              startTime,
                                              style: GoogleFonts.poppins(
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
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
                                            padding: const EdgeInsets.all(0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                            side: BorderSide.none,
                                          ),
                                          onPressed: _readonly
                                              ? null
                                              : () async {
                                                  TimeOfDay? time =
                                                      await showTimePickerFunction(
                                                          context,
                                                          selectedTimeST);
                                                  setState(() {
                                                    selectedTimeET = time;
                                                    if (selectedTimeET !=
                                                        null) {
                                                      endTime = selectedTimeET!
                                                          .format(context);
                                                    }
                                                  });
                                                },
                                          child: Container(
                                            width: MediaQuery.sizeOf(context)
                                                .width,
                                            height: 50,
                                            alignment: Alignment.bottomCenter,
                                            padding: const EdgeInsets.only(
                                                bottom: 8),
                                            child: Text(
                                              endTime,
                                              textAlign: TextAlign.left,
                                              style: GoogleFonts.poppins(
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const PaddedDivider(),
                              TextFormField(
                                controller: locationController,
                                keyboardType: TextInputType.text,
                                readOnly: _readonly,
                                decoration: const InputDecoration(
                                  labelText: 'LOCATION',
                                  hintText: 'Add your location',
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 8),
                                ),
                              ),
                              const PaddedDivider(),
                              TextFormField(
                                controller: gCashNumController,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(11),
                                ],
                                keyboardType: TextInputType.phone,
                                readOnly: _readonly,
                                decoration: const InputDecoration(
                                  labelText: 'GCASH NUMBER',
                                  hintText: 'Add your GCash number',
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
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
                          Visibility(
                            visible: _isServiceProvider,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    // vertical: 12,
                                    horizontal: 8,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'DISABLE ACCOUNT',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      const SizedBox(width: 8.0),
                                      Tooltip(
                                        triggerMode: TooltipTriggerMode.tap,
                                        richMessage: WidgetSpan(
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            constraints: const BoxConstraints(
                                                maxWidth: 250),
                                            child: const Text(
                                              "By disabling your account, you won't receive notifications from customer messages.",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        showDuration:
                                            const Duration(seconds: 5),
                                        child: const Icon(
                                          Icons.info_outline_rounded,
                                          size: 16.0,
                                        ),
                                      ),
                                      const Expanded(child: SizedBox()),
                                      Switch(
                                        // This bool value toggles the switch.
                                        value: isDisabled,
                                        activeColor: Colors.blue,
                                        onChanged: (bool value) async {
                                          // This is called when the user toggles the switch.
                                          setState(() {
                                            isDisabled = value;
                                          });
                                          String status = isDisabled
                                              ? 'disabled'
                                              : 'enabled';
                                          showToast(
                                              "You have $status your account!");

                                          final userDoc = FirebaseFirestore
                                              .instance
                                              .collection('service_provider')
                                              .doc(uid);
                                          final userDocSnapshot =
                                              await userDoc.get();

                                          if (!userDocSnapshot.exists ||
                                              !userDocSnapshot
                                                  .data()!
                                                  .containsKey('disabled')) {
                                            await userDoc.set({
                                              'disabled': isDisabled,
                                            }, SetOptions(merge: true));
                                          } else {
                                            await userDoc.update(
                                                {'disabled': isDisabled});
                                          }
                                        },
                                      ),
                                    ],
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
                                          builder: (BuildContext context) =>
                                              ShopProfilePage(shopUid: uid),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'PREVIEW PROFILE',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
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
                                          return const ReviewsPage(
                                            whatReview: 'Service Reviews',
                                            shopReviews: true,
                                          );
                                        }),
                                      );
                                    },
                                    child: Text(
                                      'SERVICE REVIEWS',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ),
                                ),
                                const Divider(height: 1),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 8,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const ReviewsPage(
                                      whatReview: 'Your Reviews',
                                      shopReviews: false,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                'YOUR REVIEWS',
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
                                            const LandingPage()),
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

class PaddedDivider extends StatelessWidget {
  const PaddedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Divider(
        height: 1,
      ),
    );
  }
}
