import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'package:flutter/services.dart';

class Api {
  final Firestore _db = Firestore.instance;
  String path;
  String companyId;

  CollectionReference ref;

  Api({this.path, this.companyId}) {
    ref = _db.collection("companies").document(companyId).collection(path);
  }

  Future<QuerySnapshot> getDataCollection() {
    return ref.getDocuments();
  }

  streamDataCollection() {
    try {
      ref.snapshots().listen((snapShot) {
        if (snapShot.documents.isNotEmpty) {
          return snapShot.documents;
             
        }
        return 'Nothing Found';
      });
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.document(id).get();
  }

  Future removeDocument(String id) async {
    try {
      await ref.document(id).delete();
      return true;
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future addDocument(Map data) async {
    try {
      DocumentReference docRef = await ref.add(data);
      return docRef.documentID != null;
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future updateDocument(Map data, String id) async {
    try {
      await ref.document(id).updateData(data);
      return true;
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }
}
