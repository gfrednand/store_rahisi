import 'dart:async';

import 'package:flutter/material.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/locator.dart';
import 'package:storeRahisi/models/user.dart';
import 'package:storeRahisi/providers/base_model.dart';
import 'package:storeRahisi/providers/settings_model.dart';
import 'package:storeRahisi/services/api.dart';
import 'package:storeRahisi/services/auth_service.dart';
import 'package:storeRahisi/services/dialog_service.dart';
import 'package:storeRahisi/services/navigation_service.dart';
import 'package:storeRahisi/services/push_notification_service.dart';

class AuthModel extends BaseModel {
  final StreamController<List<User>> _userController =
      StreamController<List<User>>.broadcast();
  List<User> _users = [];
  List<User> get users => _users;

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
    await _navigateToPage(result);
  }

  login(String email, String password) async {
    setBusy(true);

    var result = await _authService.loginWithEmail(
      email: email,
      password: password,
    );

    await _navigateToPage(result);
    setBusy(false);
  }

  _navigateToPage(result) async {
    if (result is bool) {
      if (result) {
        if (currentUser != null && currentUser.companyId != null) {
          _navigationService.navigateTo(routeName: AppRoutes.layout);
        } else {
          _navigationService.navigateTo(
              routeName: AppRoutes.company_registration,
              arguments: currentUser);
        }
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

  saveUserCompany({String companyName, String companyId}) async {
    setBusy(true);
    var result;
    Map<String, dynamic> data = {
      "name": companyName,
      "userId": currentUser.uid
    };
    if (companyId == null) {
      result = await Api(path: 'companies').addDocument(data);
    } else {
      result = await Api(path: 'users')
          .updateDocument({"companyId": companyId}, currentUser.uid);
    }
    await _navigateToPage(result);
    setBusy(false);
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
      if (currentUser.companyId != null) {
        await listenToUsers();
        await _settingsModel.initNotificationSettings();
        _navigationService.navigateTo(routeName: AppRoutes.layout);
      } else {
        _navigationService.navigateTo(routeName: AppRoutes.landing);
      }
    } else {
      _navigationService.navigateTo(routeName: AppRoutes.landing);
    }
  }

  listenToUsers() async {
    Api(path: 'users')
        .streamUserDataCollection(currentUser.companyId)
        .listen((snapshot) {
      if (snapshot.documents.isNotEmpty) {
        var usrs = snapshot.documents.map((snapshot) {
          Map<String, dynamic> json = snapshot.data;
          json["uid"] = snapshot.documentID;

          return User.fromMap(json);
        }).toList();

        // Add the purchases onto the controller
        _userController.add(usrs);
      }
    });

    _userController.stream.listen((userData) {
      List<User> updatedUsers = userData;
      if (updatedUsers != null && updatedUsers.length > 0) {
        _users = updatedUsers;
        notifyListeners();
      }
    });
  }
}
