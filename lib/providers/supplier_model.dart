import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:storeRahisi/locator.dart';
import 'package:storeRahisi/providers/base_model.dart';
import 'package:storeRahisi/services/api.dart';
import 'package:storeRahisi/models/supplier.dart';
import 'package:storeRahisi/services/dialog_service.dart';
import 'package:storeRahisi/services/navigation_service.dart';

class SupplierModel extends BaseModel {
  // Api _api = locator<Api>();

  Api _api = Api(path: 'suppliers', companyId: '1');
  String _documentID;
  String get documentID => _documentID;

  List<Supplier> _suppliers = [];
  List<Supplier> get suppliers => _suppliers;

  Supplier _supplier;
  Supplier get supplier => _supplier;

  bool get _editting => _supplier != null;
  final DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();

  final StreamController<List<Supplier>> _supplierController =
      StreamController<List<Supplier>>.broadcast();

  Supplier getById(String id) =>
      _suppliers.firstWhere((supplier) => supplier.id == id);

  fetchSuppliers() async {
    setBusy(true);
    var result = await _api.getDataCollection();
    _suppliers = result.documents
        .map((doc) => Supplier.fromMap(doc.data, doc.documentID))
        .toList();
    setBusy(false);
  }

  listenToSuppliers() async {
    _api.streamDataCollection().listen((postsSnapshot) {
      if (postsSnapshot.documents.isNotEmpty) {
        var posts = postsSnapshot.documents
            .map((snapshot) =>
                Supplier.fromMap(snapshot.data, snapshot.documentID))
            .toList();

        // Add the posts onto the controller
        _supplierController.add(posts);
      }
    });

    _supplierController.stream.listen((purchaseData) {
      List<Supplier> updatedSuppliers = purchaseData;
      if (updatedSuppliers != null && updatedSuppliers.length > 0) {
        _suppliers = updatedSuppliers;
        notifyListeners();
      }
    });
  }

  Supplier getSupplierById(String id) {
    if (_suppliers.length == 0) {
      listenToSuppliers();
    }
    return _suppliers.firstWhere(
      (item) => item.id == id,
      orElse: () => null,
    );
  }

  getSupplierByIdFromServer(String id) async {
    setBusy(true);
    var doc = await _api.getDocumentById(id);
    _supplier = Supplier.fromMap(doc.data, doc.documentID);
    setBusy(false);
  }

  removeSupplier(String id) async {

     var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Are you sure?',
      description: 'Do you really want to delete supplier?',
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
    );
    if (dialogResponse.confirmed) {
      await _api.removeDocument(id);
      _navigationService.pop();
    }

  }

    void setEdittingSupplier(Supplier edittingSupplier) {
    _supplier = edittingSupplier;

  }

  updateSupplier(Supplier data, String id) async {
    setBusy(true);
    await _api.updateDocument(data.toMap(), id);
    setBusy(false);
  }

  addSupplier(Supplier data) async {
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
        title: 'Cound not create supplier',
        description: result,
      );
    } else {
      await _dialogService.showDialog(
        title: 'Supplier successfully Added',
        description: 'Supplier has been created',
      );
    }

    _navigationService.pop();
  }
}
