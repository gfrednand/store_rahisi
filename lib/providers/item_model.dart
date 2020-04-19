import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:storeRahisi/locator.dart';
import 'package:storeRahisi/models/item.dart';
import 'package:storeRahisi/providers/base_model.dart';
import 'package:storeRahisi/providers/index.dart';
import 'package:storeRahisi/services/api.dart';
import 'package:storeRahisi/services/dialog_service.dart';
import 'package:storeRahisi/services/navigation_service.dart';

class ItemModel extends BaseModel {
  // Api _api = locator<Api>();
  static String _unitConst = 'Select a Product Unit';
  static String _categoryConst = 'Select a Product Category';
  Api _api = Api(path: 'items', companyId: '1');

  final StreamController<List<Item>> _itemsController =
      StreamController<List<Item>>.broadcast();

  List<Item> _items = [];
  List<Item> _searchItems;
  List<Item> get items => _items;
  List<Item> get searchItems => _searchItems;

  final DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  PurchaseModel _purchaseModel = locator<PurchaseModel>();
  SaleModel _saleModel = locator<SaleModel>();
  Item _item;
  Item _selectedItem;
  Item get item => _selectedItem;
  bool get _editting => _item != null;

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

  fetchItems() async {
    setBusy(true);
    var result = await _api.getDataCollection();
    _items = result.documents
        .map((doc) => Item.fromMap(doc.data, doc.documentID))
        .toList();
    setBusy(false);
  }

  listenToItems() async {
    _api.streamDataCollection().listen((postsSnapshot) {
      if (postsSnapshot.documents.isNotEmpty) {
        var posts = postsSnapshot.documents
            .map((doc) => Item.fromFirestore(doc))
            .toList();

        // Add the posts onto the controller
        _itemsController.add(posts);
      }
    });

    _itemsController.stream.listen((purchaseData) {
      List<Item> updatedClients = purchaseData;
      if (updatedClients != null && updatedClients.length > 0) {
        _items = updatedClients;
        notifyListeners();
      }
    });
  }

  List<Item> getItemByIds(List<String> ids) {
    return ids
        .map((id) => _items.firstWhere(
              (item) => item.id == id,
              orElse: () => null,
            ))
        .toList();
  }

  Item getItemById(String id) {
    return _items.firstWhere(
      (item) => item.id == id,
      orElse: () => null,
    );
  }

  getItemByIdFromServer(String id) async {
    setBusy(true);
    var doc = await _api.getDocumentById(id);
    _item = Item.fromMap(doc.data, doc.documentID);
    setBusy(false);
  }

  removeItem(String id) async {
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

  saveItem({@required Item data}) async {
    setBusy(true);
    var result;
    if (_selectedUnit != _unitConst) {
      data.unit = _selectedUnit;
    }

    if (_selectedCategory != _categoryConst) {
      data.category = _selectedCategory;
    }
    data.userId = currentUser?.id;
    if (!_editting) {
      result = await _api.addDocument(data.toMap());
    } else {
      result = await _api.updateDocument(data.toMap(), data.id);
    }

    setBusy(false);

    if (result is String) {
      await _dialogService.showDialog(
        title: 'Cound not create item',
        description: result,
      );
    } else {
      await _dialogService.showDialog(
        title: 'Item successfully Added',
        description: 'Item has been created',
      );
    }

    _navigationService.pop();
  }

  void setEdittingItem(Item edittingItem) {
    _item = edittingItem;
  }

  checkItem(String name) async {
    _searchItems = [];
    setBusy(true);
    _searchItems = _items
        .where((i) =>
            i.name.toLowerCase().trim().contains(name.toLowerCase().trim()))
        .toList();
    setBusy(false);
  }

  List<Item> generateReport(DateTime fromDate, DateTime toDate) {
   _totalProfit=0.0;

    return _items.map((item) {
      Map<String, dynamic> purMap =
          _purchaseModel.getPurchaseQuantityAmount(item.id, fromDate, toDate);
      Map<String, dynamic> salMap =
          _saleModel.getSaleQuantityAmount(item.id, fromDate, toDate);
      item.purchaseQuantity = purMap['quantity'];
      item.saleQuantity = salMap['quantity'];
      item.profit = salMap['purchaseAmount'] - purMap['purchaseAmount'];
      _totalProfit = _totalProfit + item.profit;
      return item;
    }).toList();
  }
}
