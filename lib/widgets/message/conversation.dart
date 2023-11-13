import 'package:flutter/material.dart';

class Conversation extends StatelessWidget {
  const Conversation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Jonnel Banka Services",
          style: Theme.of(context).textTheme.titleLarge!,
        ),
        centerTitle: true,
      ),
      body: SafeArea(child: Column()),
    );
  }
}
