import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:storeRahisi/locator.dart';
import 'package:storeRahisi/models/user.dart';
import 'package:storeRahisi/services/dialog_service.dart';
import 'package:storeRahisi/services/firestore_service.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();

  User _currentUser;
  User get currentUser => _currentUser;
  Future<void> logOut() {
    return _firebaseAuth.signOut();
  }

  Future loginWithEmail({
    @required String email,
    @required String password,
  }) async {
    try {
      var authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _populateCurrentUser(authResult.user);
      return authResult.user != null;
    } catch (e) {
      return e.message;
    }
  }

  Future signUpWithEmail({
    @required String email,
    @required String password,
    @required String fullName,
    // @required String lname,
    @required String phoneNumber,
    @required String designation,
    @required String businessName,
  }) async {
    try {
      var authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // create a new user profile on firestore
      _currentUser = User(
          id: authResult.user.uid,
          email: email,
          fullName: fullName,
          // lname: lname,
          phoneNumber: phoneNumber,
          designation: designation,
          businessName: businessName);

      await _firestoreService.createUser(_currentUser);

      return authResult.user != null;
    } catch (e) {
      return e.message;
    }
  }

  Future<bool> isUserLoggedIn() async {
    var user = await _firebaseAuth.currentUser();

    if (user != null) {
      await _populateCurrentUser(user);
    }
    return user != null;
  }

  Future _populateCurrentUser(FirebaseUser user) async {
    var result = await _firestoreService.getUser(user.uid);
    if (user != null) {
      if (result is String) {
        await _dialogService.showDialog(
          title: 'Error',
          description: result,
        );
      } else {
        _currentUser = result;

      }
    }
  }
}
