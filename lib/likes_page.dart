import 'package:athomeconvenience/widgets/shop_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'text_theme_page.dart';

class LikesPage extends StatefulWidget {
  const LikesPage({super.key});

  @override
  State<LikesPage> createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  List<String> userLikes = [];

  @override
  void initState() {
    super.initState();
    fetchLikes();
  }

  Future<void> fetchLikes() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      var userQuerySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("uid", isEqualTo: uid)
          .get();

      if (userQuerySnapshot.docs.isNotEmpty) {
        var userLikesData = userQuerySnapshot.docs.first.data();
        setState(() {
          userLikes = List<String>.from(userLikesData['likes'] ?? []);
        });
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
        title: const Text('Likes'),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) {
                  return const TextThemePage();
                }),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Edit',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: userLikes.map((like) {
              return Align(
                alignment: Alignment.topCenter,
                child: FractionallySizedBox(
                  widthFactor: 0.85,
                  child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("service_provider")
                        .where("uid", isEqualTo: like)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SizedBox(child: CircularProgressIndicator()),
                        );
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else if (snapshot.hasData) {
                        var serviceProviderData =
                            snapshot.data!.docs.first.data();
                        return ShopCard(
                            shopName:
                                serviceProviderData['service_provider_name'],
                            shopAddress: serviceProviderData['service_address'],
                            shopUid: like);
                      } else {
                        return const Center(child: Text("No data"));
                      }
                    },
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
