import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:storeRahisi/constants/logger.dart';
import 'package:storeRahisi/models/user.dart';

class SharedPrefsUtil {
  final String _isLoggedIn = "USER_IS_LOGGED_IN";
  final String _userDetails = "userDetails";
  final String _lastLoginEmail = "userEmail";
  final String _darkTheme = "darkTheme";
  final String _notification = "notification";
  final String _languageCode = "language_code";
  final String _countryCode = "countryCode";

  Future<bool> getIsDarkThemeOn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkTheme) ?? false;
  }

  Future<bool> setIsDarkThemeOn(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_darkTheme, value);
  }

  Future<bool> getIsNotificationOn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notification) ?? false;
  }

  Future<bool> setIsNotificationOn(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_notification, value);
  }

  Future<bool> getIsLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedIn) ?? false;
  }

  Future<bool> setIsLoggedIn(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_isLoggedIn, value);
  }

  Future<bool> setLanguageCode(String code) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_languageCode, code);
  }

  Future<bool> setCountryCode(String code) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_countryCode, code);
  }

  Future<String> getLanguageCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageCode);
  }

  Future<String> getCountryCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_countryCode);
  }

  Future<bool> setLastLoginEmail(String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_lastLoginEmail, email);
  }

  Future<String> getLastLoginEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastLoginEmail);
  }

  // Future<bool> setUserDetails(User user) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString(_userDetails, user.toJson());
  // }

  // Future<User> getUserDetails() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   dynamic u = prefs.getString(_userDetails);
  //   print('################$u');
  //   return u != null ? User.fromJson(u) : null;
  // }

  // Future<bool> removeUserDetails() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.remove(_userDetails);
  // }
}
