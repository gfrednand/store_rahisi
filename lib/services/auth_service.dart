import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:storeRahisi/locator.dart';
import 'package:storeRahisi/models/user.dart';
import 'package:storeRahisi/services/dialog_service.dart';
import 'package:storeRahisi/services/firestore_service.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  User _currentUser;
  User get currentUser => _currentUser;

  Future<dynamic> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final AuthResult authResult =
          await _firebaseAuth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;

      // Checking if email and name is null
      assert(user.email != null);
      assert(user.displayName != null);
      assert(user.photoUrl != null);

      // name = user.displayName;
      // email = user.email;
      // imageUrl = user.photoUrl;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _firebaseAuth.currentUser();
      assert(user.uid == currentUser.uid);

      await _populateCurrentUser(user);
      return authResult.user != null;
    } catch (e) {
      return e?.message ?? e;
    }
  }

  Future<void> logOut() async {
    var isGoogleSignIn = await googleSignIn.isSignedIn();
    if (isGoogleSignIn) {
      await googleSignIn.signOut();
    } else {
      await _firebaseAuth.signOut();
    }
    print("User Sign Out");
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
    @required String companyName,
  }) async {
    try {
      var authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _currentUser = User(
          uid: authResult.user.uid,
          email: email,
          fullName: fullName,
          // lname: lname,
          phoneNumber: phoneNumber,
          designation: designation,
          companyName: companyName);
      // create a new user profile on firestore
      final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
        functionName: 'addUser',
      )..timeout = const Duration(seconds: 30);

      final HttpsCallableResult result =
          await callable.call([_currentUser.toMap()]);
      print(result.data);
//

      // await _firestoreService.createUser(_currentUser);
      return authResult.user != null;
    } on CloudFunctionsException catch (e) {
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

  saveDeviceToken() async {
    // Get the current user

    try {
      FirebaseUser user = await _firebaseAuth.currentUser();
      if (user != null) {
        print("Firebase User UID: " + user.uid);

        _fcm.getToken().then((token) {
          print("Firebase Messaging Token: " + token);

          Firestore.instance
              .collection("users")
              .document(user.uid)
              .updateData({"androidNotificationToken": token});
        });
      }
    } catch (e) {
      print('************$e');
    }
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
