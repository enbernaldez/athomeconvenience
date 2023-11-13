import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authProvider = FutureProvider<bool>((ref) async {
  final SharedPreferences s = await SharedPreferences.getInstance();
  return s.getBool("is_signedin") ?? false;
});
