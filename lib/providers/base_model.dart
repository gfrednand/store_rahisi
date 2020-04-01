import 'package:flutter/material.dart';
import 'package:storeRahisi/locator.dart';
import 'package:storeRahisi/models/user.dart';
import 'package:storeRahisi/services/auth_service.dart';

class BaseModel extends ChangeNotifier {
  final AuthService _authService = locator<AuthService>();

  User get currentUser => _authService.currentUser;

  bool _busy = false;
  bool get busy => _busy;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }
}
