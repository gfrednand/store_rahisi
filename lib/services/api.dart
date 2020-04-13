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

  Stream<QuerySnapshot> streamDataCollection() {
    return ref.snapshots();
  }

  getDocumentById(String id) {
    return ref.document(id).get();
  }

  removeDocument(String id) {
    try {
      ref.document(id).delete();
      return true;
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  addDocument(Map data) {
    try {
      ref.add(data);
      return true;
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  updateDocument(Map data, String id) {
    try {
      ref.document(id).updateData(data);
      return true;
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }
}
