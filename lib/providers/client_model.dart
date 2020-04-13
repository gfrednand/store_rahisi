import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:storeRahisi/locator.dart';
import 'package:storeRahisi/providers/base_model.dart';
import 'package:storeRahisi/services/api.dart';
import 'package:storeRahisi/models/client.dart';
import 'package:storeRahisi/services/dialog_service.dart';
import 'package:storeRahisi/services/navigation_service.dart';

class ClientModel extends BaseModel {
  // Api _api = locator<Api>();

  Api _api = Api(path: 'clients', companyId: '1');
  String _documentID;
  String get documentID => _documentID;

  List<Client> _clients = [];
  List<Client> get clients => _clients;

  Client _client;
  Client get client => _client;

  bool get _editting => _client != null;
  final DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();

  final StreamController<List<Client>> _clientController =
      StreamController<List<Client>>.broadcast();

  Client getById(String id) =>
      _clients.firstWhere((client) => client.id == id);

  fetchClients() async {
    setBusy(true);
    var result = await _api.getDataCollection();
    _clients = result.documents
        .map((doc) => Client.fromMap(doc.data, doc.documentID))
        .toList();
    setBusy(false);
  }

  listenToClients() async {
    _api.streamDataCollection().listen((postsSnapshot) {
      if (postsSnapshot.documents.isNotEmpty) {
        var posts = postsSnapshot.documents
            .map((snapshot) =>
                Client.fromMap(snapshot.data, snapshot.documentID))
            .toList();

        // Add the posts onto the controller
        _clientController.add(posts);
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
    var doc = await _api.getDocumentById(id);
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
      await _api.removeDocument(id);
      _navigationService.pop();
    }

  }

    void setEdittingclient(Client edittingclient) {
    _client = edittingclient;

  }

  updateClient(Client data, String id) async {
    setBusy(true);
    await _api.updateDocument(data.toMap(), id);
    setBusy(false);
  }

  addClient(Client data) async {
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
        title: 'Cound not create client',
        description: result,
      );
    } else {
      await _dialogService.showDialog(
        title: 'client successfully Added',
        description: 'client has been created',
      );
    }

    _navigationService.pop();
  }
}
