import 'dart:async';

import 'package:flutter/material.dart';
import 'package:storeRahisi/locator.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/providers/base_model.dart';
import 'package:storeRahisi/providers/payment_model.dart';
import 'package:storeRahisi/services/api.dart';
import 'package:storeRahisi/services/dialog_service.dart';
import 'package:storeRahisi/services/navigation_service.dart';

class SaleModel extends BaseModel {
  Api _api = Api(path: 'sales', companyId: '1');

  final StreamController<List<Sale>> _salesController =
      StreamController<List<Sale>>.broadcast();

  List<Sale> _sales = [];

  List<Sale> get sales => _sales;

  final DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  PaymentModel _paymentModel = locator<PaymentModel>();

  Sale _sale;
  bool get _editting => _sale != null;

  fetchSales() async {
    setBusy(true);
    var result = await _api.getDataCollection();
    _sales = result.documents.map((doc) => Sale.fromFirestore(doc)).toList();
    setBusy(false);
  }

  listenToSales() async {
    _api.streamDataCollection().listen((snapshot) {
      if (snapshot.documents.isNotEmpty) {
        var sals = snapshot.documents
            .map((snapshot) => Sale.fromFirestore(snapshot))
            .toList();

        _salesController.add(sals);
      }
    });

    _salesController.stream.listen((data) {
      List<Sale> updatedSales = data;
      if (updatedSales != null && updatedSales.length > 0) {
        _sales = updatedSales;

        // _sales.map((purchase) {
        //   purchase.supplier =
        //       _supplierModel.getSupplierById(purchase.supplierId)?.name;

        //   List<Payment> payments =
        //       _paymentModel.getPaymentsByPurchaseId(purchase.id);
        //   purchase.paidAmount = 0.0;
        //   payments.forEach((payment) {
        //     purchase.paidAmount = purchase.paidAmount + payment.amount;
        //   });
        //   return purchase;
        // });
        notifyListeners();
      }
    });
  }

  List<Sale> getSaleHistoryByItemId(String id) {
    List<Sale> sal = [];
    _sales.forEach((sale) {
      sale.items.forEach((item) {
        if (item.id == id) {
          sal.add(sale);
        }
      });
    });

    return sal;
  }

  int getTotalSaleByItemId(String id) {
    int total = 0;
    if (_sales.length == 0) {
      listenToSales();
    }
    _sales.forEach((sale) {
      sale.items.forEach((item) {
        if (item.id == id) {
          total += item.quantity;
        }
      });
    });
    return total;
  }



  getSaleByIdFromServer(String id) async {
    setBusy(true);
    var doc = await _api.getDocumentById(id);
    _sale = Sale.fromFirestore(doc);
    setBusy(false);
  }

  removeSale(String id) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Are you sure?',
      description: 'Do you really want to delete sale?',
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
    );
    if (dialogResponse.confirmed) {
      await _api.removeDocument(id);
      _navigationService.pop();
    }
  }

  saveSale({@required Sale data}) async {
    setBusy(true);
    var result;

    data.userId = currentUser?.id;

    if (!_editting) {
      result = await _api.addDocument(data.toMap());
    } else {
      result = await _api.updateDocument(data.toMap(), data.id);
    }
    setBusy(false);

    if (result is String) {
      await _dialogService.showDialog(
        title: 'Cound not sale',
        description: result,
      );
    } else {
      await _dialogService.showDialog(
        title: 'Successful',
        description: 'Item Sold',
      );
    }
    _navigationService.pop();
  }
}
