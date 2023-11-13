import 'package:athomeconvenience/widgets/shop_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShopListPage extends StatefulWidget {
  final String category;
  const ShopListPage({super.key, required this.category});

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
        title: Text(
          widget.category,
          style: Theme.of(context).textTheme.titleLarge!,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              const Divider(
                height: 0,
              ),
              const SizedBox(
                height: 10,
              ),
              for (final shop in shopList)
                ShopCard(
                  shopAddress: shop['service_address'],
                  shopName: shop['service_provider_name'],
                  shopUid: shop['uid'],
                )
            ],
          ),
        ),
      )),
    );
  }
}
