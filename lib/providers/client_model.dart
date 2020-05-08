import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:storeRahisi/locator.dart';
import 'package:storeRahisi/providers/base_model.dart';
import 'package:storeRahisi/providers/cart_model.dart';
import 'package:storeRahisi/services/api.dart';
import 'package:storeRahisi/models/client.dart';
import 'package:storeRahisi/services/dialog_service.dart';
import 'package:storeRahisi/services/navigation_service.dart';

class ClientModel extends BaseModel {
  // Api Api(path: 'items', companyId: currentUser?.companyId) = locator<Api>();

  String _documentID;
  String get documentID => _documentID;

  List<Client> _clients = [];
  List<Client> get clients => _clients;
  CartModel _cartModel = locator<CartModel>();

  Client _client;
  Client get client => _client;
  Client _checkedClient = Client.defaultCustomer();
  Client get checkedClient =>
      _cartModel.carts.length > 0 ? _checkedClient : Client.defaultCustomer();

  bool get _editting => _client != null;
  final DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();

  final StreamController<List<Client>> _clientController =
      StreamController<List<Client>>.broadcast();

  Client getById(String id) {
    if (_clients.length == 0) {
      listenToClients();
    }
    return _clients.firstWhere(
      (client) => client.id == id,
      orElse: () => null,
    );
  }

  List<Client> getByClientType(String clientType) {
    if (_clients.length == 0) {
      listenToClients();
    }
    return _clients.where((client) => client.clientType == clientType).toList();
  }

  fetchClients() async {
    setBusy(true);
    var result = await Api(path: 'clients', companyId: currentUser?.companyId)
        .getDataCollection();
    _clients = result.documents
        .map((doc) => Client.fromMap(doc.data, doc.documentID))
        .toList();
    setBusy(false);
  }

  listenToClients() async {
    Api(path: 'clients', companyId: currentUser?.companyId)
        .streamDataCollection()
        .listen((snapShot) {
      if (snapShot.documents.isNotEmpty) {
        var clents = snapShot.documents
            .map((snapshot) =>
                Client.fromMap(snapshot.data, snapshot.documentID))
            .toList();
        // Add the clents onto the controller
        _clientController.add(clents);
      }
    });

    _clientController.stream.listen((purchaseData) {
      List<Client> updatedclients = purchaseData;
      if (updatedclients != null && updatedclients.length > 0) {
        _clients = updatedclients;
        notifyListeners();
      }
    });
  }

  Client getClientById(String id) {
    if (_clients.length == 0) {
      listenToClients();
    }
    return _clients.firstWhere(
      (item) => item.id == id,
      orElse: () => null,
    );
  }

  getClientByIdFromServer(String id) async {
    setBusy(true);
    var doc = await Api(path: 'clients', companyId: currentUser?.companyId)
        .getDocumentById(id);
    _client = Client.fromMap(doc.data, doc.documentID);
    setBusy(false);
  }

  removeClient(String id) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Are you sure?',
      description: 'Do you really want to delete client?',
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
    );
    if (dialogResponse.confirmed) {
      await Api(path: 'clients', companyId: currentUser?.companyId)
          .removeDocument(id);
      _navigationService.pop();
    }
  }

  void setEdittingclient(Client edittingclient) {
    _client = edittingclient;
  }

  void setCheckedclient(Client client) {
    _checkedClient = client;
  }

  updateClient(Client data, String id) async {
    setBusy(true);
    await Api(path: 'clients', companyId: currentUser?.companyId)
        .updateDocument(data.toMap(), id);
    setBusy(false);
  }

  Future<bool> addClient(Client data) async {
    setBusy(true);

    var result;

    data.userId = currentUser?.id;
    if (!_editting) {
      result = await Api(path: 'clients', companyId: currentUser?.companyId)
          .addDocument(data.toMap());
    } else {
      result = await Api(path: 'clients', companyId: currentUser?.companyId)
          .updateDocument(data.toMap(), data.id);
    }

    setBusy(false);

    if (result is String) {
      await _dialogService.showDialog(
        title: 'Cound not create client',
        description: result,
      );
    } else {
      _navigationService.pop();
      return true;
    }

    _navigationService.pop();
    return false;
  }
}
