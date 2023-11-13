import 'package:athomeconvenience/widgets/shop_card.dart';
import 'package:flutter/material.dart';

class ShopListPage extends StatelessWidget {
  final String category;
  const ShopListPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          category,
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
              Divider(
                height: 0,
              ),
              const SizedBox(
                height: 10,
              ),
              ShopCard(),
              ShopCard(),
              ShopCard(),
            ],
          ),
        ),
      )),
    );
  }
}
