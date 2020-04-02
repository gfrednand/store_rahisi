import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:storeRahisi/locator.dart';
import 'package:storeRahisi/providers/base_model.dart';
import 'package:storeRahisi/services/api.dart';
import 'package:storeRahisi/models/supplier.dart';
import 'package:storeRahisi/services/dialog_service.dart';

class SupplierModel extends BaseModel {
  // Api _api = locator<Api>();

  Api _api = Api(path: 'suppliers', companyId: '1');
  String _documentID;
  String get documentID => _documentID;

  List<Supplier> _suppliers;
  List<Supplier> get suppliers => _suppliers;

  Supplier _supplier;
  Supplier get supplier => _supplier;
  final DialogService _dialogService = locator<DialogService>();
  fetchSuppliers() async {
    setBusy(true);
    var result = await _api.getDataCollection();
    _suppliers = result.documents
        .map((doc) => Supplier.fromMap(doc.data, doc.documentID))
        .toList();
    setBusy(false);
  }

  listenToSuppliers() async {
    setBusy(true);
    var result = _api.streamDataCollection();
    setBusy(false);

    if (result is String) {
      await _dialogService.showDialog(
        title: 'Error',
        description: result,
      );
    } else if (result != null) {
      _supplier = result
          .map((snapshot) =>
              Supplier.fromMap(snapshot.data, snapshot.documentID))
          .toList();
      ;
    }
  }

  getSupplierById(String id) async {
    setBusy(true);
    var doc = await _api.getDocumentById(id);
    _supplier = Supplier.fromMap(doc.data, doc.documentID);
    setBusy(false);
  }

  removeSupplier(String id) async {
    setBusy(true);
    await _api.removeDocument(id);
    setBusy(false);
  }

  updateSupplier(Supplier data, String id) async {
    setBusy(true);
    await _api.updateDocument(data.toMap(), id);
    setBusy(false);
  }

  addSupplier(Supplier data) async {
    setBusy(true);
    var result = await _api.addDocument(data.toMap());
    _documentID = result.documentID;
    setBusy(false);
  }
}
