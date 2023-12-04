import 'package:athomeconvenience/widgets/buttons.dart';
import 'package:athomeconvenience/widgets/list_else.dart';
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
  @override
  Widget build(BuildContext context) {
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
              child: FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("service_provider")
                    .where("category", isEqualTo: widget.category)
                    .where('status', isEqualTo: "Accepted")
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const DataLoading();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    if (snapshot.data!.docs.isNotEmpty) {
                      var serviceProviderData = snapshot.data!.docs;

                      return Column(
                        children: [
                          for (final doc in serviceProviderData)
                            Column(
                              children: [
                                ShopCard(
                                    shopAddress: doc['service_address'],
                                    shopName: doc['service_provider_name'],
                                    shopUid: doc['uid']),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Divider(
                                  height: 0,
                                ),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            )
                        ],
                      );
                    } else {
                      return const NoData();
                    }
                  } else {
                    return const NoData();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
