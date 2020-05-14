import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:storeRahisi/locator.dart';
import 'package:storeRahisi/models/category.dart';
import 'package:storeRahisi/models/item.dart';
import 'package:storeRahisi/providers/base_model.dart';
import 'package:storeRahisi/providers/index.dart';
import 'package:storeRahisi/services/api.dart';
import 'package:storeRahisi/services/dialog_service.dart';
import 'package:storeRahisi/services/navigation_service.dart';

class ItemModel extends BaseModel {
  // Api Api(path: 'items', companyId: currentUser?.companyId) = locator<Api>();

  final StreamController<List<Item>> _itemsController =
      StreamController<List<Item>>.broadcast();
  final StreamController<List<Category>> _categoriesController =
      StreamController<List<Category>>.broadcast();

  List<Item> _items = [];
  List<Category> _categories = [];
  List<Item> _searchItems;
  List<Item> get items => _items;
  List<Category> get categories => _categories;
  List<Item> get searchItems => _searchItems;

  final DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  PurchaseModel _purchaseModel = locator<PurchaseModel>();
  SaleModel _saleModel = locator<SaleModel>();
  Item _item;
  Item _selectedItem;
  Item get item => _selectedItem;
  bool get _editting => _item != null;

  // String _selectedCategory = _categoryConst;
  // String get selectedCategory => _selectedCategory;

  double _totalProfit = 0.0;
  double get totalProfit => _totalProfit;

  Category _filter;

  Category get filter => _filter;

  set filter(Category filter) {
    _filter = filter;
    notifyListeners();
  }

  fetchItems() async {
    setBusy(true);
    var result = await Api(path: 'items', companyId: currentUser?.companyId)
        .getDataCollection();
    _items = result.documents
        .map((doc) => Item.fromMap(doc.data, doc.documentID))
        .toList();
    setBusy(false);
  }

  listenToItems() async {
    Api(path: 'items', companyId: currentUser?.companyId)
        .streamDataCollection()
        .listen((snapshot) {
      if (snapshot.documents.isNotEmpty) {
        var itms =
            snapshot.documents.map((doc) => Item.fromFirestore(doc)).toList();

        // Add the itms onto the controller
        _itemsController.add(itms);
      }
    });

    _itemsController.stream.listen((itemData) {
      List<Item> updatedItem = itemData;
      if (updatedItem != null && updatedItem.length > 0) {
        _items = updatedItem;
        // updatedItem.map((item) {
        //   item.totalPurchase = _purchaseModel.getTotalPurchaseByItemId(item.id);
        //   item.totalSales = _saleModel.getTotalSaleByItemId(item.id);
        //   item.inStock =
        //       (item.totalPurchase + item.openingStock) - item.totalSales;
        //   item.category = getCategoryById(item.categoryId)?.name;
        //   return item;
        // }).toList();
        notifyListeners();
      }
    });
  }

  List<Item> get filteredItems {
    if (filter == null || filter.name == Category.all().name) {
      return _items;
    }
    return _items.where((item) => item.categoryId == filter.id).toList();
  }

  List<Category> get filters {
    List<Category> cats = [];

    cats = _categories;
    Category all = cats.firstWhere(
      (cat) => cat.name == Category.all().name,
      orElse: () => null,
    );
    if (all == null) cats.insert(0, Category.all());
    return cats;
  }

  listenToCategories() async {
    Api(path: 'categories', companyId: currentUser?.companyId)
        .streamDataCollection()
        .listen((snapshot) {
      if (snapshot.documents.isNotEmpty) {
        var itms = snapshot.documents
            .map((doc) => Category.fromMap(doc.data, doc.documentID))
            .toList();

        // Add the itms onto the controller
        _categoriesController.add(itms);
      }
    });

    _categoriesController.stream.listen((categoryData) {
      List<Category> updatedCategory = categoryData;
      if (updatedCategory != null && updatedCategory.length > 0) {
        _categories = updatedCategory;
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

  List<Item> getItemByCategory(String category) {
    return _items.where((p) => p.category == category).toList();
  }

  Category getCategoryById(String id) {
    if (_categories.length == 0) {
      listenToCategories();
    }
    return _categories.firstWhere(
      (item) => item.id == id,
      orElse: () => null,
    );
  }

  getItemByIdFromServer(String id) async {
    setBusy(true);
    var doc = await Api(path: 'items', companyId: currentUser?.companyId)
        .getDocumentById(id);
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
      await Api(path: 'items', companyId: currentUser?.companyId)
          .removeDocument(id);
      _navigationService.pop();
    }
  }

  Future<bool> saveItem({@required Item data}) async {
    setBusy(true);
    var result;

    data.userId = currentUser?.id;
    if (!_editting) {
      result = await Api(path: 'items', companyId: currentUser?.companyId)
          .addDocument(data.toMap());
    } else {
      result = await Api(path: 'items', companyId: currentUser?.companyId)
          .updateDocument(data.toMap(), data.id);
    }

    setBusy(false);

    if (result is String) {
      await _dialogService.showDialog(
        title: 'Cound not create item',
        description: result,
      );
      return false;
    } else {
      return true;
    }
  }

  Future<bool> saveCategory({@required Category data}) async {
    setBusy(true);
    var result;

    if (!_editting) {
      result = await Api(path: 'categories', companyId: currentUser?.companyId)
          .addDocument(data.toMap());
    } else {
      result = await Api(path: 'categories', companyId: currentUser?.companyId)
          .updateDocument(data.toMap(), data.id);
    }

    setBusy(false);

    if (result is String) {
      await _dialogService.showDialog(
        title: 'Cound not create Category',
        description: result,
      );
      return false;
    } else {
      _navigationService.pop();
      return true;
    }
  }

  Future<bool> updateItemsFromPurchase({@required List<Item> items}) async {
    // setBusy(true);
    var result;

    result = await Api(path: 'items', companyId: currentUser?.companyId)
        .updateMultipleDocument(items.map((item) => item.toMap()).toList());

    setBusy(false);

    if (result is String) {
      await _dialogService.showDialog(
        title: 'Cound not update Prices',
        description: result,
      );
      return false;
    } else {
      return true;
    }
  }

  void setEdittingItem(Item edittingItem) {
    _item = edittingItem;
  }

  search(String searchTerms) async {
    _searchItems = [];
    setBusy(true);
    _searchItems = _items
        .where((i) => i.name
            .toLowerCase()
            .trim()
            .contains(searchTerms.toLowerCase().trim()))
        .toList();
    setBusy(false);
  }

  List<Item> generateReport(DateTime fromDate, DateTime toDate) {
    _totalProfit = 0.0;

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
