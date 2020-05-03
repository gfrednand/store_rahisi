import 'dart:async';

import 'package:flutter/material.dart';
import 'package:storeRahisi/locator.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/providers/base_model.dart';
import 'package:storeRahisi/providers/cart_model.dart';
import 'package:storeRahisi/providers/index.dart';
import 'package:storeRahisi/providers/payment_model.dart';
import 'package:storeRahisi/services/api.dart';
import 'package:storeRahisi/services/dialog_service.dart';
import 'package:storeRahisi/services/navigation_service.dart';

class SaleModel extends BaseModel {
  final StreamController<List<Sale>> _salesController =
      StreamController<List<Sale>>.broadcast();

  List<Sale> _sales = [];

  List<Sale> get sales => _sales;

  final DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  PaymentModel _paymentModel = locator<PaymentModel>();
  CartModel _cartModel = locator<CartModel>();
  PurchaseModel _purchaseModel = locator<PurchaseModel>();
  ExpenseModel _expenseModel = locator<ExpenseModel>();

  Sale _sale;
  bool get _editting => _sale != null;

  double _totalSaleAmount = 0.0;
  int _totalQuantity = 0;
  double get totalSaleAmount => _totalSaleAmount;
  double _totalPurchaseAmount = 0;

  double get totalPurchaseAmount => _totalPurchaseAmount;

  int get totalQuantity => _totalQuantity;

  fetchSales() async {
    setBusy(true);
    var result = await Api(path: 'sales', companyId: currentUser.companyId)
        .getDataCollection();
    _sales = result.documents.map((doc) => Sale.fromFirestore(doc)).toList();
    setBusy(false);
  }

  listenToSales() async {
    Api(path: 'sales', companyId: currentUser.companyId)
        .streamDataCollection()
        .listen((snapshot) {
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
        //   purchase.client =
        //       _clientModel.getClientById(purchase.clientId)?.name;

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

  List<Sale> getSaleHistoryByClientId(String id) {
    if (_sales.length == 0) {
      listenToSales();
    }
    List<Sale> sals = [];
    _sales.forEach((sale) {
      if (sale.clientId == id) {
        sals.add(sale);
      }
    });
    return sals;
  }

  List<Sale> getSaleHistoryByItemId(String id) {
    if (_sales.length == 0) {
      listenToSales();
    }
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
    var doc = await Api(path: 'sales', companyId: currentUser.companyId)
        .getDocumentById(id);
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
      await Api(path: 'sales', companyId: currentUser.companyId)
          .removeDocument(id);
      _navigationService.pop();
    }
  }

  saveSale({@required Sale data}) async {
    setBusy(true);
    var result;

    data.userId = currentUser?.id;

    if (!_editting) {
      result = await Api(path: 'sales', companyId: currentUser.companyId)
          .addDocument(data.toMap());
    } else {
      result = await Api(path: 'sales', companyId: currentUser.companyId)
          .updateDocument(data.toMap(), data.id);
    }
    setBusy(false);

    if (result is String) {
      await _dialogService.showDialog(
        title: 'Cound not sale',
        description: result,
      );
    } else {
      await _paymentModel.savePayment(
          data: Payment(
              amount: data.paidAmount,
              method: data.paymentMethod,
              referenceNo: data.referenceNumber,
              note: 'Paid for Invoice ${data.referenceNumber}',
              clientId: data.clientId,
              type: 'Credit'));
      _cartModel.removeAllItems();
      await _dialogService.showDialog(
        title: 'Successful',
        description: 'Item Sold',
      );
    }

    if (_editting) {
      _navigationService.pop();
      _navigationService.pop();
    } else {
      _navigationService.pop();
    }
  }

  List<Sale> generateReport(DateTime fromDate, DateTime toDate) {
    _totalSaleAmount = 0.0;
    _totalPurchaseAmount = 0.0;
    _totalQuantity = 0;
    var qtys = 0;
    DateTime purchaseDate;
    List<Sale> sals = [];
    if (_sales.length == 0) {
      listenToSales();
    } else {
      List<Purchase> purchases =
          _purchaseModel.generateReport(fromDate, toDate);
      purchases.forEach((purchase) {
        if (purchaseDate != null) {
          if (purchase.purchaseDate.isAfter(purchaseDate)) {
            purchaseDate = purchase.purchaseDate;
          }
        } else {
          purchaseDate = purchase.purchaseDate;
        }
        purchase.items.forEach((item) {
          _totalPurchaseAmount =
              (item.purchasePrice * item.quantity) + _totalPurchaseAmount;
          qtys = item.quantity + qtys;
          // print(
          //     'PURCHASES::: :${item.id},${item.quantity}, $qtys, ${item.purchasePrice}, $_totalPurchaseAmount');
        });
      });

      sals = _sales
          .where((sale) =>
              sale.saleDate.isAfter(fromDate.add(const Duration(days: -1))) &&
              sale.saleDate.isBefore(toDate.add(const Duration(days: 1))))
          .toList();

      sals.forEach((sale) {
        sale.items.forEach((item) {
          _totalSaleAmount =
              (item.paidAmount * item.quantity) + _totalSaleAmount;
          // print('SALES::${item.id},:${item.quantity}, ${item.paidAmount}');
          _totalQuantity = item.quantity + _totalQuantity;
        });
      });
      // print(sals.toString());
    }

    return sals;
  }

  Map<String, dynamic> getSaleQuantityAmount(
      String itemId, DateTime fromDate, DateTime toDate) {
    int quantity = 0;
    double purchaseAmount = 0;

    if (_sales.length == 0) {
      listenToSales();
    }
    List<Sale> sals = _sales
        .where((purchase) =>
            purchase.saleDate.isAfter(fromDate.add(const Duration(days: -1))) &&
            purchase.saleDate.isBefore(toDate.add(const Duration(days: 1))))
        .toList();

    sals.forEach((sale) {
      sale.items.forEach((item) {
        if (item.id == itemId) {
          quantity = item.quantity + quantity;
          purchaseAmount = item.paidAmount + purchaseAmount;
        }
      });
    });
    Map<String, dynamic> data = {};
    data['quantity'] = quantity;
    data['purchaseAmount'] = purchaseAmount;
    return data;
  }

  Map<String, dynamic> getTotalSales(DateTime fromDate, DateTime toDate) {
    double totalSales = 0;
    double beginningInventory = 0.0;
    double endingInventory = 0.0;
    double totalExpenses = 0.0;
    List<Expense> expenses = _expenseModel.generateReport(fromDate, toDate);
    expenses.forEach((expense) {
      totalExpenses = totalExpenses + expense.amount;
    });
    if (_sales.length == 0) {
      listenToSales();
    }
    List<Sale> sals = _sales
        .where((purchase) =>
            purchase.saleDate.isAfter(fromDate.add(const Duration(days: -1))) &&
            purchase.saleDate.isBefore(toDate.add(const Duration(days: 1))))
        .toList();

    sals.forEach((sale) {
      sale.items.forEach((item) {
        totalSales = (item.paidAmount * item.quantity) + totalSales;
      });
    });
    Map<String, dynamic> data = {};
    data['totalSales'] = totalSales;
    data['totalExpenses'] = totalExpenses;
    data['costOfSales'] = beginningInventory + totalSales - endingInventory;
    data['grossProfit'] =data['totalSales'] -  data['costOfSales'];
    return data;
  }
}
