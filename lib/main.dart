import 'package:athomeconvenience/authentication/check_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'landing_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'At-Home Convenience',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),

        // for uniformity fo text styles -edma
        textTheme: TextTheme(
          bodyLarge: GoogleFonts.dmSans(
            color: Colors.black87,
          ), // TextFormField widget (default) / HomePage banner
          bodyMedium: GoogleFonts.dmSans(), // Text widget (default)
          bodySmall: GoogleFonts.dmSans(
            color: Colors.red[100],
          ),
          displayLarge: GoogleFonts.dmSans(
            color: Colors.orange[900],
          ),
          displayMedium: GoogleFonts.dmSans(
            color: Colors.orange,
          ),
          displaySmall: GoogleFonts.dmSans(
            color: Colors.orange[100],
          ),
          headlineLarge: GoogleFonts.dmSans(
            color: Colors.green[900],
          ),
          headlineMedium: GoogleFonts.poppins(
            color: Colors.green,
          ),
          headlineSmall: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ), // AppName / LogIn / CreateAnAccount / Alert title
          labelLarge: GoogleFonts.dmSans(
            color: Colors.blue,
          ), // AppBar widget action property
          labelMedium: GoogleFonts.dmSans(
            color: Colors.blue,
          ),
          labelSmall: GoogleFonts.dmSans(
            color: Colors.blue[100],
          ),
          titleLarge: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ), // 'Services Available' / AppBar title property
          titleMedium: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.blue[50],
          ), // ElevatedButton widget
          titleSmall:
              GoogleFonts.poppins(), // categories' ElevatedButton widget
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.lightBlue[100]),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            padding: const MaterialStatePropertyAll(
              EdgeInsets.all(8),
            ),
          ),
        ),
      ),
      home: const CheckAuth(),
    );
  }
}
