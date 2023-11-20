import 'package:athomeconvenience/widgets/functions.dart';
import 'package:flutter/material.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Messages'),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              InteractionHandler.showInteractionDialog(context);
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
    );
  }
}
