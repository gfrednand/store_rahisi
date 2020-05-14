import 'dart:async';

import 'package:flutter/material.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/providers/index.dart';
import 'package:storeRahisi/services/api.dart';

class TransactionModel extends BaseModel {
  final StreamController<List<Transaction>> _transactionController =
      StreamController<List<Transaction>>.broadcast();
  List<Transaction> _transactions = [];
  List<Transaction> get transactions => _transactions;

  Transaction _transaction;

  // Item get item => _transaction;
  bool get _editting => _transaction != null;

  fetchTransactions() async {
    setBusy(true);
    var result =
        await Api(path: 'transactions', companyId: currentUser?.companyId)
            .getDataCollection();
    _transactions = result.documents
        .map((doc) => Transaction.fromMap(doc.data, doc.documentID))
        .toList();

    setBusy(false);
  }

  listenToTransactions() async {
    Api(path: 'transactions', companyId: currentUser?.companyId)
        .streamDataCollection()
        .listen((snapshot) {
      if (snapshot.documents.isNotEmpty) {
        var transactions = snapshot.documents
            .map((snapshot) =>
                Transaction.fromMap(snapshot.data, snapshot.documentID))
            .toList();

        // Add the transactions onto the controller
        _transactionController.add(transactions);
      }
    });

    _transactionController.stream.listen((purchaseData) {
      List<Transaction> updatedTransactions = purchaseData;
      if (updatedTransactions != null && updatedTransactions.length > 0) {
        _transactions = updatedTransactions;
        notifyListeners();
      }
    });
  }

  Future<bool> saveTransaction({@required Transaction data}) async {
    // setBusy(true);
    var result;
    if (!_editting) {
      result =
          await Api(path: 'transactions', companyId: currentUser?.companyId)
              .addDocument(data.toMap());
    } else {
      result =
          await Api(path: 'transactions', companyId: currentUser?.companyId)
              .updateDocument(data.toMap(), data.id);
    }

    // setBusy(false);

    if (result is String) {
      // await _dialogService.showDialog(
      //   title: 'Cound not create Payment',
      //   description: result,
      // );
      return false;
    } else {
      return true;
    }

    // _navigationService.pop();
  }
}
