import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/pages/client/client_detail_widget.dart';

import 'package:storeRahisi/pages/client/client_form.dart';
import 'package:storeRahisi/providers/index.dart';

import 'package:storeRahisi/widgets/custom_modal_sheet.dart';

class ClientDetail extends StatelessWidget {
  final Client client;
  final ClientModel clientModel;

  const ClientDetail({Key key, this.client, this.clientModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: client.companyName == null
            ? Text(AppLocalizations.of(context).translate('clientDetails'))
            : Text(
                '${client.companyName.toUpperCase()}',
                overflow: TextOverflow.ellipsis,
              ),
      ),
      body: ClientDetailWidget(
        client: client,
        clientModel: clientModel,
      ),
    );
  }
}
