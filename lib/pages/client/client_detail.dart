import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/constants/app_constants.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/pages/client/client_detail_widget.dart';
import 'package:storeRahisi/providers/index.dart';

class ClientDetail extends StatelessWidget {
  final Client client;
  final ClientModel clientModel;

  const ClientDetail({Key key, this.client, this.clientModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = client.clientType == AppConstants.clientTypeSupplier
        ? client?.companyName?.toUpperCase()
        : client?.contactPerson?.toUpperCase();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: client.companyName == null
            ? Text(AppLocalizations.of(context).translate('clientDetails'))
            : Text(title,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline6),
      ),
      body: ClientDetailWidget(
        client: client,
        clientModel: clientModel,
      ),
    );
  }
}
