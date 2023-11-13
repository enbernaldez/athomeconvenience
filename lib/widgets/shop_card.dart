import 'package:athomeconvenience/shop_profile_page.dart';
import 'package:flutter/material.dart';

class ShopCard extends StatelessWidget {
  final String shopName;
  final String shopAddress;
  final String shopUid;
  const ShopCard(
      {super.key,
      required this.shopName,
      required this.shopAddress,
      required this.shopUid});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    ShopProfilePage(shopUid: shopUid),
              ),
            );
          },
          child: Row(
            children: [
              // Image/Icon
              Container(
                height: 60,
                width: 60,
                decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(100))),
              ),
              const SizedBox(
                width: 20,
              ),

              // Column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SHOP NAME
                  Text(
                    shopName,
                    style:
                        const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  // Address
                  Text(
                    shopAddress,
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              )
            ],
          ),
        ),
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
    );
  }
}
