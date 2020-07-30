import 'package:flutter/material.dart';
import 'package:storeRahisi/locator.dart';
import 'package:storeRahisi/services/dialog_service.dart';
import 'package:storeRahisi/services/navigation_service.dart';
import 'package:storeRahisi/services/push_notification_service.dart';
import 'package:storeRahisi/services/shared_pref_util.dart';
import 'package:storeRahisi/providers/base_model.dart';

class SettingsModel extends BaseModel {
  Locale _appLocale = Locale('en');
  bool _isDarkModeOn = false;
  bool _isNotificationOn = false;
  Locale get appLocal => _appLocale ?? Locale("en");
  bool get isDarkModeOn => _isDarkModeOn;
  bool get isNotificationOn => _isNotificationOn;
  final DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  PushNotificationService _pushNotificationService =
      locator<PushNotificationService>();

  final SharedPrefsUtil _sharedPrefsUtil = locator<SharedPrefsUtil>();

  GlobalKey<NavigatorState> get dialogNavigationKey =>
      _dialogService.dialogNavigationKey;
  GlobalKey<NavigatorState> get navigatorKey => _navigationService.navigatorKey;

  Future<void> updateTheme(bool isDarkModeOn) async {
    await _sharedPrefsUtil.setIsDarkThemeOn(isDarkModeOn);
    _isDarkModeOn = isDarkModeOn;
  }

  Future initThemeSettings() async {
    _isDarkModeOn = await _sharedPrefsUtil.getIsDarkThemeOn();

    notifyListeners();
  }

  Future initNotificationSettings() async {
    _isNotificationOn = await _sharedPrefsUtil.getIsNotificationOn();
    if (currentUser != null && currentUser.companyId != null) {
      print(currentUser.toMap());
      if (_isNotificationOn) {
        _pushNotificationService.fcmSubscribe();
      } else {
        _pushNotificationService.fcmUnSubscribe();
      }
      notifyListeners();
    }
  }

  Future<void> updateNotification(bool isNotificationOn) async {
    await _sharedPrefsUtil.setIsNotificationOn(isNotificationOn);
    _isNotificationOn = isNotificationOn;
    if (_isNotificationOn) {
      _pushNotificationService.fcmSubscribe();
    } else {
      _pushNotificationService.fcmUnSubscribe();
    }
  }

  fetchLocale() async {
    var langCode = await _sharedPrefsUtil.getLanguageCode();
    if (langCode == null) {
      _appLocale = Locale('en');
      return Null;
    }

    _appLocale = Locale(langCode);
    return Null;
  }

  void changeLanguage(Locale type) async {
    if (_appLocale == type) {
      return;
    }
    if (type == Locale("sw")) {
      _appLocale = Locale("sw");
      await _sharedPrefsUtil.setLanguageCode('sw');
      await _sharedPrefsUtil.setCountryCode('TZ');
    } else {
      _appLocale = Locale("en");
      await _sharedPrefsUtil.setLanguageCode('en');
      await _sharedPrefsUtil.setCountryCode('US');
    }
    notifyListeners();
  }
}
