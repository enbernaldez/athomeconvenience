import 'package:athomeconvenience/constants.dart';
import 'package:athomeconvenience/landing_page.dart';
import 'package:athomeconvenience/model/search_items.dart';
import 'package:athomeconvenience/shop_list_page.dart';
import 'package:athomeconvenience/shop_profile_page.dart';
import 'package:athomeconvenience/widgets/buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var serviceCategories = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('service_provider')
                      .where('status', isEqualTo: "Accepted")
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                      return FractionallySizedBox(
                        widthFactor: 0.9,
                        child: SearchAnchor(
                          builder: (BuildContext context,
                              SearchController controller) {
                            return SearchBar(
                              controller: controller,
                              padding:
                                  const MaterialStatePropertyAll<EdgeInsets>(
                                EdgeInsets.symmetric(horizontal: 16),
                              ),
                              onTap: () {
                                controller.openView();
                              },
                              onChanged: (_) {
                                controller.openView();
                              },
                              leading: const Icon(Icons.search),
                              hintText: 'Search...',
                            );
                          },
                          suggestionsBuilder: (BuildContext context,
                              SearchController controller) {
                            if (controller.text.isEmpty) {
                              final List<SearchItem> items =
                                  snapshot.data!.docs.map((doc) {
                                // Modify this according to your Firestore document structure
                                return SearchItem(
                                    shopName: doc['service_provider_name'],
                                    shopId: doc['uid']);
                              }).toList();

                              final List<SearchItem> itemsLimit =
                                  items.take(5).toList();

                              List<Widget> searchItem = [];
                              print(items);
                              print(itemsLimit);

                              for (final item in itemsLimit) {
                                searchItem.add(
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ShopProfilePage(
                                                  shopUid: item.shopId),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      child: Text(
                                        item.shopName,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                );
                              }

                              return searchItem;
                            } else {
                              final List<SearchItem> items =
                                  snapshot.data!.docs.map((doc) {
                                // Modify this according to your Firestore document structure
                                return SearchItem(
                                    shopName: doc['service_provider_name'],
                                    shopId: doc['uid']);
                              }).toList();

                              // final SearchItem singleItem = items.singleWhere(
                              //     (item) => item.shopName
                              //         .toLowerCase()
                              //         .contains(controller.text.toLowerCase()));

                              // print(singleItem);

                              final filteredItems = items.where(
                                (item) => item.shopName.toLowerCase().contains(
                                      controller.text.toLowerCase(),
                                    ),
                              );

                              List<Widget> searchItem = [];
                              for (final item in filteredItems) {
                                searchItem.add(
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ShopProfilePage(
                                                  shopUid: item.shopId),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      child: Row(
                                        children: [
                                          const CircleAvatar(
                                            backgroundImage: AssetImage(
                                                'images/default_profile_pic.png'),
                                            maxRadius: 10,
                                          ), //! issue: not displaying
                                          Text(
                                            item.shopName,
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }

                              return searchItem;
                            }
                          },
                        ),
                      );
                    }

                    return const SizedBox();
                  }),
              const SizedBox(height: 24),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 104,
                ),
                child: Container(
                  color: Colors.blue[50],
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 0, 16),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Home services available exclusively in Ligao City!',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Image.asset('images/pic.png'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Services Available',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(24.0),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (var entry in serviceCategoryMap.entries)
                    Button(
                      padding: 8.0,
                      onPress: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ShopListPage(category: entry.key),
                        ));
                      },
                      buttonColor: Colors.lightBlue[100],
                      haveAdditional: true,
                      textType: Theme.of(context).textTheme.titleSmall,
                      image: entry.value,
                      buttonText: entry.key,
                    ),
                ],
              ),
              Button(
                  onPress: () async {
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
                  buttonText: "LOG OUT")
            ],
          ),
        ),
      ),
    );
  }
}
