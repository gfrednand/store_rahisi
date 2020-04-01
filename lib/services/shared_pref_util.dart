import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:storeRahisi/models/user.dart';

class SharedPrefsUtil {
  final String _isLoggedIn = "USER_IS_LOGGED_IN";
  final String _userDetails = "userDetails";
  final String _lastLoginEmail = "userEmail";

  Future<bool> getIsLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedIn) ?? false;
  }

  Future<bool> setIsLoggedIn(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_isLoggedIn, value);
  }

  Future<bool> setUserDetails(String user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_userDetails, user);
  }

  Future<bool> setLastLoginEmail(String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_lastLoginEmail, email);
  }

  Future<String> getLastLoginEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastLoginEmail);
  }

  Future<User> getUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var u = prefs.getString(_userDetails);
    return u != null ? User.fromMap(jsonDecode(u)) : null;
  }

  Future<bool> removeUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(_userDetails);
  }
}
