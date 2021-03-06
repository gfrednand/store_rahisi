import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase/firebase.dart' as fb;
import 'package:flutter/services.dart';
import 'package:storeRahisi/models/user.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection('users');

  Future createUser(User user) async {
    try {
      await _usersCollectionReference.document(user.uid).setData(user.toMap());
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future getUser(String uid) async {
    try {
      var userData = await _usersCollectionReference.document(uid).get();
      return User.fromMap(userData.data);
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }
}
