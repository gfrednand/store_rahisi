import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:storeRahisi/locator.dart';
import 'package:storeRahisi/models/item.dart';
import 'package:storeRahisi/providers/base_model.dart';
import 'package:storeRahisi/services/api.dart';
import 'package:storeRahisi/services/dialog_service.dart';
import 'package:storeRahisi/services/navigation_service.dart';

class ItemModel extends BaseModel {
  // Api _api = locator<Api>();
  static String _unitConst = 'Select a Product Unit';
  static String _categoryConst = 'Select a Product Category';
  Api _api = Api(path: 'items', companyId: '1');
  String _documentID;
  String get documentID => _documentID;

  List<Item> _items;
  List<Item> _searchItems;
  List<Item> get items => _items;
  List<Item> get searchItems => _searchItems;

  final DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  Item _item;
  // Item get item => _item;
  bool get _editting => _item != null;
  String _selectedCategory = _categoryConst;
  String get selectedCategory => _selectedCategory;
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

  Stream<QuerySnapshot> fetchItemsAsStream() {
    return _api.streamDataCollection();
  }

  getItemById(String id) async {
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
      setBusy(true);
      await _api.removeDocument(id);
      setBusy(false);
    }
  }

  saveItem({@required Item data, String id}) async {
    setBusy(true);
    var result;
    if (_selectedUnit != _unitConst) {
      data.unit = _selectedUnit;
    }

    if (_selectedCategory != _categoryConst) {
      data.category = _selectedCategory;
    }
    data.userId = currentUser.id;
    if (!_editting) {
      result = await _api.addDocument(data.toMap());
    } else {
      result = await _api.updateDocument(data.toMap(), id);
    }

    setBusy(false);

       if (result is String) {
      await _dialogService.showDialog(
        title: 'Cound not create post',
        description: result,
      );
    } else {
      await _dialogService.showDialog(
        title: 'Product successfully Added',
        description: 'Product has been created',
      );
    }

    _navigationService.pop();
    // print('***********$id');
    // var result;
    // setBusy(true);

    // if (_selectedUnit != _unitConst) {
    //   data.unit = _selectedUnit;
    // }

    // if (_selectedCategory != _categoryConst) {
    //   data.category = _selectedCategory;
    // }
    // if (id == null) {
    //   result = await _api.addDocument(data.toMap());
    //   _documentID = result.documentID;
    // } else {
    //   print('***********$result');
    //   result = await _api.updateDocument(data.toMap(), id);
    // }
    // setBusy(false);

    // if (result is bool) {
    //   print('***********$result');
    //   if (result) {
    //     _navigationService.pop();
    //   } else {
    //     await _dialogService.showDialog(
    //       title: 'Failure',
    //       description: 'General failure. Please try again later',
    //     );
    //   }
    // } else {
    //   print('***********$result');

    //   await _dialogService.showDialog(
    //     title: 'Failure',
    //     description: result,
    //   );
    // }
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
}
