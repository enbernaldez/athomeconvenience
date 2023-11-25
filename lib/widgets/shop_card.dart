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
        const SizedBox(
          height: 10,
        ),
        const Divider(
          height: 0,
        ),
        const SizedBox(
          height: 10,
        ),
        FractionallySizedBox(
          widthFactor: 0.9,
          child: GestureDetector(
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
                const CircleAvatar(
                  backgroundImage: AssetImage('images/default_profile_pic.png'),
                  maxRadius: 30,
                ),
                const SizedBox(
                  width: 20,
                ),

                // Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SHOP NAME
                      Text(
                        shopName,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.black),
                      ),

                      // Address
                      Text(
                        shopAddress,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
