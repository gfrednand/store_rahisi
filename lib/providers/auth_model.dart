import 'package:flutter/material.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/locator.dart';
import 'package:storeRahisi/models/user.dart';
import 'package:storeRahisi/providers/base_model.dart';
import 'package:storeRahisi/services/auth_service.dart';
import 'package:storeRahisi/services/dialog_service.dart';
import 'package:storeRahisi/services/navigation_service.dart';

class AuthModel extends BaseModel {
  final AuthService _authService = locator<AuthService>();
  final DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  User _user;
  User get user => _user;
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
    @required String fname,
    @required String lname,
    @required String phoneNumber,
    @required String companyId,
  }) async {
    setBusy(true);

    var result = await _authService.signUpWithEmail(
        email: email,
        password: password,
        fname: fname,
        lname: lname,
        phoneNumber: phoneNumber,
        designation: _selectedRole,
        companyId: companyId);

    setBusy(false);

    if (result is bool) {
      if (result) {
        _navigationService.navigateTo(routeName: AppRoutes.home);
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
    var hasLoggedInUser = await _authService.isUserLoggedIn();

    if (hasLoggedInUser) {
      _navigationService.navigateTo(routeName: AppRoutes.layout);
    } else {
      _navigationService.navigateTo(routeName: AppRoutes.login);
    }
  }

  void navigateToSignUp() {
    _navigationService.navigateTo(routeName: AppRoutes.register);
  }
}
