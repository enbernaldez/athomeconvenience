import 'package:athomeconvenience/landing_page.dart';
import 'package:athomeconvenience/navigation.dart';
import 'package:athomeconvenience/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckAuth extends ConsumerWidget {
  const CheckAuth({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<bool> isSignedIn = ref.watch(authProvider);

    return isSignedIn.when(
      data: (bool data) {
        // Here, 'data' represents the value retrieved from SharedPreferences
        // You can conditionally return different widgets based on the authentication status
        return data ? const Navigation() : const LandingPage();
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ), // Show a loading indicator while fetching data
      error: (error, stack) =>
          Text('Error: $error'), // Show an error message if fetching fails
    );
  }
}
