import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storeRahisi/locator.dart';
import 'package:storeRahisi/services/dialog_service.dart';
import 'package:storeRahisi/services/navigation_service.dart';
class SettingsModel extends ChangeNotifier {
  bool _isDarkModeOn = false;

  Locale _appLocale = Locale('en');

  Locale get appLocal => _appLocale ?? Locale("en");
  bool get isDarkModeOn => _isDarkModeOn;
  final DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();

  GlobalKey<NavigatorState> get dialogNavigationKey =>_dialogService.dialogNavigationKey;
  GlobalKey<NavigatorState> get navigatorKey => _navigationService.navigatorKey;

  void updateTheme(bool isDarkModeOn) {
    _isDarkModeOn = isDarkModeOn;
    notifyListeners();
  }

  fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('language_code') == null) {
      _appLocale = Locale('en');
      return Null;
    }
    _appLocale = Locale(prefs.getString('language_code'));
    return Null;
  }

  void changeLanguage(Locale type) async {
    var prefs = await SharedPreferences.getInstance();
    if (_appLocale == type) {
      return;
    }
    if (type == Locale("sw")) {
      _appLocale = Locale("sw");
      await prefs.setString('language_code', 'sw');
      await prefs.setString('countryCode', 'TZ');
    } else {
      _appLocale = Locale("en");
      await prefs.setString('language_code', 'en');
      await prefs.setString('countryCode', 'US');
    }
    notifyListeners();
  }
}
