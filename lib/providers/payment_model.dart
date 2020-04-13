import 'dart:async';

import 'package:flutter/material.dart';
import 'package:storeRahisi/locator.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/providers/index.dart';
import 'package:storeRahisi/services/api.dart';
import 'package:storeRahisi/services/dialog_service.dart';
import 'package:storeRahisi/services/navigation_service.dart';

class PaymentModel extends BaseModel {
  Api _api = Api(path: 'payments', companyId: '1');
  final DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();

  final StreamController<List<Payment>> _paymentsController =
      StreamController<List<Payment>>.broadcast();
  List<Payment> _payments = [];
  List<Payment> get payments => _payments;

  Payment _payment;


  // Item get item => _payment;
  bool get _editting => _payment != null;

  fetchItems() async {
    setBusy(true);
    var result = await _api.getDataCollection();
    _payments = result.documents
        .map((doc) => Payment.fromMap(doc.data, doc.documentID))
        .toList();
    

          

    setBusy(false);
  }

  listenToPayments() async {
    _api.streamDataCollection().listen((postsSnapshot) {
      if (postsSnapshot.documents.isNotEmpty) {
        var posts = postsSnapshot.documents
            .map((snapshot) =>
                Payment.fromMap(snapshot.data, snapshot.documentID))
            .toList();

        // Add the posts onto the controller
        _paymentsController.add(posts);
      }
    });

    _paymentsController.stream.listen((purchaseData) {
      List<Payment> updatedClients = purchaseData;
      if (updatedClients != null && updatedClients.length > 0) {
        _payments = updatedClients;
        notifyListeners();
      }
    });
  }

  List<Payment> getPaymentsByPurchaseId(String id) {
    if (_payments.length == 0) {
      listenToPayments();
    }
    return _payments.where((payment) => payment.purchaseId == id).toList();
  }

  removePayment(String id) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Are you sure?',
      description: 'Do you really want to delete Payment?',
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
    );
    if (dialogResponse.confirmed) {
      await _api.removeDocument(id);
      _navigationService.pop();
    }
  }

  savePayment({@required Payment data}) async {
    // setBusy(true);
    var result;
    if (!_editting) {
      result = await _api.addDocument(data.toMap());
    } else {
      print('*********************${data.toMap()}');

      result = await _api.updateDocument(data.toMap(), data.id);
    }
    
    // setBusy(false);

    // if (result is String) {
    //   await _dialogService.showDialog(
    //     title: 'Cound not create Payment',
    //     description: result,
    //   );
    // } else {
    //   await _dialogService.showDialog(
    //     title: 'Payment successfully Added',
    //     description: 'Payment has been created',
    //   );
    // }

    // _navigationService.pop();
  }
}
