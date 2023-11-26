import 'package:athomeconvenience/widgets/buttons.dart';
import 'package:athomeconvenience/widgets/shop_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShopListPage extends StatefulWidget {
  final String category;

  const ShopListPage({
    super.key,
    required this.category,
  });

  @override
  State<ShopListPage> createState() => _ShopListPageState();
}

class _ShopListPageState extends State<ShopListPage> {
  List<Map<String, dynamic>> shopList = [];

  @override
  void initState() {
    super.initState();
    fetchShop();
  }

  Future<void> fetchShop() async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection("service_provider")
          .where("category", isEqualTo: widget.category)
          .get();

      List<Map<String, dynamic>> tempShop = [];

      querySnapshot.docs.forEach((doc) {
        tempShop.add(doc.data());
      });

      // Update the state with the fetched data
      setState(() {
        shopList = tempShop;
      });
    } catch (e) {
      print("Error fetching notifications: $e");
      // Handle errors
    }
  }

  @override
  Widget build(BuildContext context) {
    print(shopList);
    return Scaffold(
      appBar: AppBar(
        leading: const BackArrow(),
        title: Text(
          widget.category,
          style: Theme.of(context).textTheme.titleLarge!,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Align(
            alignment: Alignment.topCenter,
            child: FractionallySizedBox(
              widthFactor: 0.85,
              child: Column(
                children: [
                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("service_provider")
                        .where("category", isEqualTo: widget.category)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SizedBox(child: CircularProgressIndicator()),
                        );
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else if (snapshot.hasData) {
                        if (snapshot.data!.docs.isNotEmpty) {
                          var serviceProviderData =
                              snapshot.data!.docs.first.data();
                          return ShopCard(
                              shopAddress:
                                  serviceProviderData['service_address'],
                              shopName:
                                  serviceProviderData['service_provider_name'],
                              shopUid: serviceProviderData['uid']);
                        } else {
                          return const Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Divider(
                                height: 0,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: Text(
                                  "No data",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      } else {
                        return const Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Divider(
                              height: 0,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Text(
                                "No data",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  // for (final shop in shopList)
                  //   ShopCard(
                  //     shopAddress: shop['service_address'],
                  //     shopName: shop['service_provider_name'],
                  //     shopUid: shop['uid'],
                  //   )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
