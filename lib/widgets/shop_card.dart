import 'package:athomeconvenience/shop_profile_page.dart';
import 'package:flutter/material.dart';

class ShopCard extends StatelessWidget {
  const ShopCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => ShopProfilePage(),
              ),
            );
          },
          child: Container(
            child: Row(
              children: [
                // Image/Icon
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                ),
                const SizedBox(
                  width: 20,
                ),

                // Column
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SHOP NAME
                    Text(
                      "Jonnel Banka Services",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),

                    // Address
                    Text(
                      "Balinad, Poland, Earth 616",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                )
              ],
            ),
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
