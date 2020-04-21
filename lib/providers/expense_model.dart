import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:storeRahisi/locator.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/providers/base_model.dart';
import 'package:storeRahisi/providers/index.dart';
import 'package:storeRahisi/services/api.dart';
import 'package:storeRahisi/services/dialog_service.dart';
import 'package:storeRahisi/services/navigation_service.dart';

class ExpenseModel extends BaseModel {
  // Api Api(path: 'expenses', companyId: currentUser.companyId) = locator<Api>();
  static String _unitConst = 'Select a Product Unit';
  static String _categoryConst = 'Select a Product Category';

  final StreamController<List<Expense>> _expensesController =
      StreamController<List<Expense>>.broadcast();

  List<Expense> _expenses = [];
  List<Expense> _searchExpenses;
  List<Expense> get expenses => _expenses;
  List<Expense> get searchExpenses => _searchExpenses;

  final DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  PaymentModel _paymentModel = locator<PaymentModel>();
  Expense _expense;
  Expense _selectedExpense;
  Expense get expense => _selectedExpense;
  bool get _editting => _expense != null;

  String _selectedCategory = _categoryConst;
  String get selectedCategory => _selectedCategory;

  double _totalProfit = 0.0;
  double get totalProfit => _totalProfit;
  void setSelectedCategory(dynamic category) {
    _selectedCategory = category;
    notifyListeners();
  }

  String _selectedUnit = _unitConst;
  String get selectedUnit => _selectedUnit;
  void setSelectedUnit(dynamic unit) {
    _selectedUnit = unit;
    notifyListeners();
  }

  fetchExpenses() async {
    setBusy(true);
    var result = await Api(path: 'expenses', companyId: currentUser.companyId)
        .getDataCollection();
    _expenses = result.documents
        .map((doc) => Expense.fromMap(doc.data, doc.documentID))
        .toList();
    setBusy(false);
  }

  listenToExpenses() async {
    Api(path: 'expenses', companyId: currentUser.companyId)
        .streamDataCollection()
        .listen((snapshot) {
      if (snapshot.documents.isNotEmpty) {
        var data = snapshot.documents
            .map((doc) => Expense.fromMap(doc.data, doc.documentID))
            .toList();

        // Add the data onto the controller
        _expensesController.add(data);
      }
    });

    _expensesController.stream.listen((purchaseData) {
      List<Expense> updatedClients = purchaseData;
      if (updatedClients != null && updatedClients.length > 0) {
        _expenses = updatedClients;
        notifyListeners();
      }
    });
  }

  List<Expense> getExpenseByIds(List<String> ids) {
    return ids
        .map((id) => _expenses.firstWhere(
              (expense) => expense.id == id,
              orElse: () => null,
            ))
        .toList();
  }

  Expense getExpenseById(String id) {
    return _expenses.firstWhere(
      (expense) => expense.id == id,
      orElse: () => null,
    );
  }

  getExpenseByIdFromServer(String id) async {
    setBusy(true);
    var doc = await Api(path: 'expenses', companyId: currentUser.companyId)
        .getDocumentById(id);
    _expense = Expense.fromMap(doc.data, doc.documentID);
    setBusy(false);
  }

  removeExpense(String id) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Are you sure?',
      description: 'Do you really want to delete product?',
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
    );
    if (dialogResponse.confirmed) {
      await Api(path: 'expenses', companyId: currentUser.companyId)
          .removeDocument(id);
      _navigationService.pop();
    }
  }

  saveExpense({@required Expense data}) async {
    setBusy(true);
    var result;

    data.userId = currentUser?.id;
    if (!_editting) {
      result = await Api(path: 'expenses', companyId: currentUser.companyId)
          .addDocument(data.toMap());
    } else {
      result = await Api(path: 'expenses', companyId: currentUser.companyId)
          .updateDocument(data.toMap(), data.id);
    }

    setBusy(false);

    if (result is String) {
      await _dialogService.showDialog(
        title: 'Cound not create item',
        description: result,
      );
    } else {
      await _paymentModel.savePayment(
          data: Payment(
              amount: data.amount,
              method: 'Cash',
              referenceNo: null,
              note: 'Paid for Expense of ${data.responsiblePerson}',
              clientId: null,
              type: 'Debit'));
      await _dialogService.showDialog(
        title: 'Expense successfully Added',
        description: 'Item has been created',
      );
    }

    if (_editting) {
      _navigationService.pop();
      _navigationService.pop();
    } else {
      _navigationService.pop();
    }
  }

  void setEdittingExpense(Expense edittingExpense) {
    _expense = edittingExpense;
  }

  checkItem(String name) async {
    _searchExpenses = [];
    setBusy(true);
    _searchExpenses = _expenses
        .where((e) => e.responsiblePerson
            .toLowerCase()
            .trim()
            .contains(name.toLowerCase().trim()))
        .toList();
    setBusy(false);
  }

  List<Expense> generateReport(DateTime fromDate, DateTime toDate) {
    _totalProfit = 0.0;

    return _expenses.map((item) {
      return item;
    }).toList();
  }
}
