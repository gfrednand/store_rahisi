import 'dart:async';

import 'package:flutter/material.dart';
import 'package:storeRahisi/locator.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/providers/index.dart';

import 'package:storeRahisi/services/api.dart';
import 'package:storeRahisi/services/dialog_service.dart';
import 'package:storeRahisi/services/navigation_service.dart';


class PurchaseModel extends BaseModel {
  Api _api = Api(path: 'purchases', companyId: '1');

  final StreamController<List<Purchase>> _purchasesController =
      StreamController<List<Purchase>>.broadcast();

  int _count = 0;
  List<Purchase> _purchases = [];
  List<Purchase> _searchPurchases;
  // List<Client> _clients;
  // List<Client> get clients => _clients;
  List<Item> _items;
  List<Item> get items => _items;
  List<Purchase> get purchases => _purchases;
  List<Purchase> get searchPurchases => _searchPurchases;

  List<Item> _selectedItems = [];
  List<Item> get selectedItems => _selectedItems;

  final DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  ClientModel _clientModel = locator<ClientModel>();
  PaymentModel _paymentModel = locator<PaymentModel>();

  Purchase _purchase;
  bool get _editting => _purchase != null;

  // ClientModel _clientModel = ClientModel();

  // getclients() {
  //   _clientModel.fetchclients();
  //   _clients = _clientModel.clients;
  //   // setBusy(false);
  // }

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
    _api.streamDataCollection().listen((snapshot) {
      if (snapshot.documents.isNotEmpty) {
        var purs = snapshot.documents
            .map((snapshot) =>
                Purchase.fromMap(snapshot.data, snapshot.documentID))
            .toList();

        // Add the purchases onto the controller
        _purchasesController.add(purs);
      }
    });

    _purchasesController.stream.listen((purchaseData) {
      List<Purchase> updatedPurchases = purchaseData;
      if (updatedPurchases != null && updatedPurchases.length > 0) {
        _purchases = updatedPurchases;

        // _purchases.map((purchase) {
        //   purchase.Client =
        //       _clientModel.getClientById(purchase.ClientId)?.name;

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

  List<Purchase> getPurchaseHistoryByClientId(String id) {
    List<Purchase> purs = [];
    _purchases.forEach((purchase) {
      if (purchase.clientId == id) {
        purs.add(purchase);
      }
    });
    return purs;
  }

  int getTotalPurchaseByItemId(String id) {
    int total = 0;

    if (_purchases.length == 0) {
      listenToPurchases();
    }
    _purchases.forEach((purchase) {
      purchase.items.forEach((item) {
        if (item.id == id) {
          total += item.quantity;
        }
      });
    });

    return total;
  }

  List<Item> getUnPaidItems(String id) {
    List<Item> items = [];

    Purchase p = _purchases.firstWhere(
      (purchase) => purchase.id == id,
      orElse: () => null,
    );
    if (p != null) {
      p.items.forEach((item) {
        if ((item.purchasePrice - item.paidAmount) > 0) {
          items.add(item);
        }
      });
    }

    return items;
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

    data.userId = currentUser?.id;
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
              referenceNo: data.referenceNumber,
              note: 'Paid for Bill ${data.referenceNumber}',
              clientId: data.clientId,
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
