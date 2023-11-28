// import 'package:flutter/material.currentImagedart';

// class UploadImage extends StatefulWidget {
//   const UploadImage({super.key});

//   @override
//   State<UploadImage> createState() => UploadImageState();
// }

// class UploadImageState extends State<UploadImage> {
//   bool? _isServiceProvider = true;
//   XFile? image
//   //todo remove this first, nvm 126
//       //?  = ImageHandler.currentImage
//       // see line 126
//       ;
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

// @override
// Widget build(BuildContext context) {
//   void handleImage() async {
//     final firestore = FirebaseFirestore.instance;
//     String? uid = FirebaseAuth.instance.currentUser!.uid;

//     if (_isServiceProvider == true) {
//       //? final String? imagePath = image?.path;
//       // see line 40
//       //? if (imagePath == null) {
//       if (image == null) {
//         const ShowToast('Please select an image.');
//         return;
//       } 
//       //? else {
//       // see line 55
//         // ======== Upload Image First in Firebase Storage==============
//         //? File file = File(imagePath!);
//       File file = File(image!.path);

//         // Generate a unique image name using UUID
//       final imageName = const Uuid().v4(); // Generates a random UUID

//       final storageRef = FirebaseStorage.instance
//           .ref()
//           .child('provider_profile')
//           .child('$imageName.jpg'); // Use the unique image name

//         //? final uploadImage = storageRef.putFile(file); // see line 56
//         //? final TaskSnapshot snapshot1 = await uploadImage; // see line 56
//         //? final imageUrl = await snapshot1.ref.getDownloadURL(); // see line 57

//       try {
//         final uploadImage = await storageRef.putFile(file);
//         final imageUrl = await uploadImage.ref.getDownloadURL();
//         // ============================================================
//       } catch {
//         print('Error uploading image: $error');
//       }

//       await firestore.collection('service_provider').doc(uid).set({
//         'uploaded_doc': imageUrl,
//       })
//       .then((value) => const SnackBar(
//             content: Text("Service Provider signed up Successfully!"),
//           ))
//       .catchError((error) {
//         print(error);
//         return const SnackBar(
//           content: Text(
//               "Error occurred while signing up Service Provider Details!"),
//         );
//       });
//       //? }
//     }
//   }

//   return Scaffold(
//     body: Center(
//       child: image != null
//           ? Padding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 20,
//               ),
//               child: Stack(
//                 alignment: AlignmentDirectional.topEnd,
//                 children: [
//                   FullScreenWidget(
//                     disposeLevel: DisposeLevel.Low,
//                     child: Center(
//                       child: Hero(
//                         tag: 'Uploaded image',
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(8),
//                           child: Image.file(
//                             File(image!.path),
//                             fit: BoxFit.cover,
//                             width: MediaQuery.of(context).size.width,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         image = null;
//                       });
//                     },
//                     child: const Icon(
//                       Icons.close,
//                       color: Colors.white,
//                       shadows: [
//                         Shadow(
//                           blurRadius: 1.0,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           : Flex(
//               direction: Axis.horizontal,
//               children: [
//                 Expanded(
//                   flex: 1,
//                   child: OutlinedButton(
//                     style: OutlinedButton.styleFrom(
//                       padding: const EdgeInsets.all(16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(4.0),
//                       ),
//                     ),
//                     onPressed: () {
//                       //? ImageHandler.uploadImage(context);
//                       // vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
//                       ImageHandler.uploadImage(context)
//                           .then((_) => setState(() {
//                                 image = ImageHandler.currentImage;
//                               }))
//                           .catchError((error) {
//                         print('Error selecting image: $error');
//                       });
//                       // ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//                     },
//                     child: Text(
//                       'Upload ID / Business Permit',
//                       textAlign: TextAlign.left,
//                       style: GoogleFonts.poppins(
//                         textStyle: TextStyle(
//                           fontWeight: FontWeight.normal,
//                           color: Colors.grey[850],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//     ),
//   );
// }
