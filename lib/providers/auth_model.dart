import 'package:flutter/material.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/locator.dart';
import 'package:storeRahisi/models/user.dart';
import 'package:storeRahisi/providers/base_model.dart';
import 'package:storeRahisi/providers/settings_model.dart';
import 'package:storeRahisi/services/auth_service.dart';
import 'package:storeRahisi/services/dialog_service.dart';
import 'package:storeRahisi/services/navigation_service.dart';
import 'package:storeRahisi/services/push_notification_service.dart';

class AuthModel extends BaseModel {
  final AuthService _authService = locator<AuthService>();
  final DialogService _dialogService = locator<DialogService>();
  final PushNotificationService _pushNotificationService =
      locator<PushNotificationService>();
  NavigationService _navigationService = locator<NavigationService>();
  final SettingsModel _settingsModel = locator<SettingsModel>();
  User get user => _authService.currentUser;
  String _selectedRole = 'Select a User Role';
  String get selectedRole => _selectedRole;
  logout() async {
    await _authService.logOut();
    return true;
  }

  void setSelectedRole(dynamic role) {
    _selectedRole = role;
    notifyListeners();
  }

  signInWithGoogle() async {
    setBusy(true);
    var result = await _authService.signInWithGoogle();
    setBusy(false);
    if (result is bool) {
      if (result) {
        _navigationService.navigateTo(routeName: AppRoutes.layout);
      } else {
        await _dialogService.showDialog(
          title: 'Login Failure',
          description: 'General login failure. Please try again later',
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Login Failure',
        description: result,
      );
    }
  }

  login(String email, String password) async {
    setBusy(true);

    var result = await _authService.loginWithEmail(
      email: email,
      password: password,
    );

    setBusy(false);

    if (result is bool) {
      if (result) {
        _navigationService.navigateTo(routeName: AppRoutes.layout);
      } else {
        await _dialogService.showDialog(
          title: 'Login Failure',
          description: 'General login failure. Please try again later',
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Login Failure',
        description: result,
      );
    }
  }

  Future signUp({
    @required String email,
    @required String password,
    @required String fullName,
    // @required String lname,
    @required String phoneNumber,
    @required String companyName,
  }) async {
    setBusy(true);

    var result = await _authService.signUpWithEmail(
        email: email,
        password: password,
        fullName: fullName,
        // lname: lname,
        phoneNumber: phoneNumber,
        designation: _selectedRole,
        companyName: companyName);

    setBusy(false);

    if (result is bool) {
      if (result) {
        _navigationService.navigateTo(routeName: AppRoutes.layout);
      } else {
        await _dialogService.showDialog(
          title: 'Sign Up Failure',
          description: 'General sign up failure. Please try again later',
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Sign Up Failure',
        description: result,
      );
    }
  }

  Future handleStartUpLogic() async {
    await _pushNotificationService.initialise();
    var hasLoggedInUser = await _authService.isUserLoggedIn();
    await _settingsModel.initThemeSettings();
    if (hasLoggedInUser) {
      await _settingsModel.initNotificationSettings();
      _navigationService.navigateTo(routeName: AppRoutes.layout);
    } else {
      _navigationService.navigateTo(routeName: AppRoutes.login);
    }
  }
}
