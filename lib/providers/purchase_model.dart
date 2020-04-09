import 'dart:async';

import 'package:flutter/material.dart';
import 'package:storeRahisi/locator.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/providers/base_model.dart';
import 'package:storeRahisi/providers/payment_model.dart';
import 'package:storeRahisi/services/api.dart';
import 'package:storeRahisi/services/dialog_service.dart';
import 'package:storeRahisi/services/navigation_service.dart';
import 'package:storeRahisi/providers/supplier_model.dart';

class PurchaseModel extends BaseModel {
  Api _api = Api(path: 'purchases', companyId: '1');

  final StreamController<List<Purchase>> _purchasesController =
      StreamController<List<Purchase>>.broadcast();

  List<Purchase> _purchases;
  List<Purchase> _searchPurchases;
  List<Supplier> _suppliers;
  List<Supplier> get suppliers => _suppliers;
  List<Item> _items;
  List<Item> get items => _items;
  List<Purchase> get purchases => _purchases;
  List<Purchase> get searchPurchases => _searchPurchases;

  List<Item> _selectedItems = [];
  List<Item> get selectedItems => _selectedItems;

  final DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  Purchase _purchase;
  bool get _editting => _purchase != null;

  SupplierModel _supplierModel = SupplierModel();
  PaymentModel _paymentModel = PaymentModel();

  getSuppliers() {
    _supplierModel.fetchSuppliers();
    _suppliers = _supplierModel.suppliers;
    // setBusy(false);
  }

  Item findItemById(String id) {
    return _items.firstWhere((element) => element.id == id);
    // setBusy(false);
  }

  setSelectedItem(Item data) {
    _selectedItems.add(data);
    notifyListeners();
  }

  fetchPurchases() async {
    setBusy(true);
    var result = await _api.getDataCollection();
    _purchases = result.documents
        .map((doc) => Purchase.fromMap(doc.data, doc.documentID))
        .toList();
    setBusy(false);
  }

  listenToPurchases() async {
    _api.streamDataCollection().listen((postsSnapshot) {
      if (postsSnapshot.documents.isNotEmpty) {
        var posts = postsSnapshot.documents
            .map((snapshot) =>
                Purchase.fromMap(snapshot.data, snapshot.documentID))
            .toList();

        // Add the posts onto the controller
        _purchasesController.add(posts);
      }
    });

    _purchasesController.stream.listen((purchaseData) {
      List<Purchase> updatedPurchases = purchaseData;
      if (updatedPurchases != null && updatedPurchases.length > 0) {
        _purchases = updatedPurchases;
        notifyListeners();
      }
    });
  }

  List<Purchase> getPurchaseHistoryByItemId(String id) {
    List<Purchase> pur = [];
    _purchases.forEach((purchase) {
      purchase.items.forEach((item) {
        if (item.id == id) {
          pur.add(purchase);
        }
      });
    });

    return pur;
  }

  getPurchaseByIdFromServer(String id) async {
    setBusy(true);
    var doc = await _api.getDocumentById(id);
    _purchase = Purchase.fromMap(doc.data, doc.documentID);
    setBusy(false);
  }

  removePurchase(String id) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Are you sure?',
      description: 'Do you really want to delete product?',
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
    );
    if (dialogResponse.confirmed) {
      await _api.removeDocument(id);
      _navigationService.pop();
    }
  }

  savePurchase({@required Purchase data}) async {
    setBusy(true);
    var result;

    data.userId = currentUser.id;
    if (!_editting) {
      result = await _api.addDocument(data.toMap());

    } else {
      result = await _api.updateDocument(data.toMap(), data.id);
    }

    setBusy(false);

    if (result is String) {
      await _dialogService.showDialog(
        title: 'Cound not create purchase',
        description: result,
      );
    } else {
          await _paymentModel.savePayment(
          data: Payment(
              amount: data.paidAmount,
              method: 'Cash',
              purchaseId: data.id,
              note: 'Paid For ${_purchase.id}',
              supplierId: data.supplierId,
              type: 'Debit'));
      _selectedItems = [];
      await _dialogService.showDialog(
        title: 'Purchase successfully Added',
        description: 'Purchase has been created',
      );
    }

    _navigationService.pop();
  }

  void setEdittingPurchase(Purchase edittingPurchase) {
    _purchase = edittingPurchase;
    // _selectedCategory = edittingPurchase.category;
    // _selectedUnit = edittingPurchase.unit;
    // notifyListeners();
  }

  // checkPurchase(String name) async {
  //   _searchPurchases = [];
  //   setBusy(true);
  //   _searchPurchases = _purchases
  //       .where((i) =>
  //           i.name.toLowerCase().trim().contains(name.toLowerCase().trim()))
  //       .toList();
  //   setBusy(false);
  // }
}
