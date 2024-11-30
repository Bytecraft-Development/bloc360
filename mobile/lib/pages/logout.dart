import 'package:shared_preferences/shared_preferences.dart';

class Logout {
  Future<void> logout(Function onLogoutComplete) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');

    // Call the provided callback function to handle navigation after logout
    onLogoutComplete();
  }
}