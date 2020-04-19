import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/models/index.dart';

import 'package:storeRahisi/pages/client/client_form.dart';
import 'package:storeRahisi/providers/index.dart';

import 'package:storeRahisi/widgets/custom_modal_sheet.dart';

class ClientDetail extends StatefulWidget {
  final Client client;
  final ClientModel clientModel;

  const ClientDetail({Key key, this.client, this.clientModel})
      : super(key: key);

  @override
  _ClientDetailState createState() => _ClientDetailState();
}

class _ClientDetailState extends State<ClientDetail> {
  _showModalSheetAppBar(
      BuildContext context, String title, Widget body, double heightFactor) {
    CustomModalSheet.show(
      title: title,
      context: context,
      body: body,
      heightFactor: heightFactor,
    );
  }

  @override
  Widget build(BuildContext context) {
    PurchaseModel purchaseModel = Provider.of<PurchaseModel>(context);
    List<Purchase> purchases =
        purchaseModel.getPurchaseHistoryByClientId(widget.client.id);
    SaleModel saleModel = Provider.of<SaleModel>(context);
    List<Sale> sales =
        saleModel.getSaleHistoryByClientId(widget.client.id);
        print(sales.length);
        print(purchases.length);
    return Scaffold(
      appBar: AppBar(
        title: widget.client.companyName == null
            ? Text(AppLocalizations.of(context).translate('clientDetails'))
            : Text(
                '${widget.client.companyName.toUpperCase()}',
                overflow: TextOverflow.ellipsis,
              ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Wrap(
              spacing: 0.0, // gap between adjacent chips
              runSpacing: 0.0, // gap between lines
              children: <Widget>[
                chipDesign(AppLocalizations.of(context).translate('edit'), Color(0xFF4db6ac)),
                purchases.length == 0 && sales.length == 0
                    ? chipDesign(AppLocalizations.of(context).translate('delete'), Color(0xFFf06292))
                    : Container(),
              ],
            ),
            Divider(
              thickness: 10.0,
            ),
            ListTile(
              title: Text('${widget.client.companyName}'),
              subtitle: Text(AppLocalizations.of(context).translate('companyName')),
            ),
            ListTile(
              title: Text('${widget.client.contactPerson}'),
              subtitle: Text(AppLocalizations.of(context).translate('contactPerson')),
            ),
            Divider(
              thickness: 10.0,
            ),
            ListTile(
              title: Text('${widget.client.phoneNumber}'),
              subtitle: Text(AppLocalizations.of(context).translate('phoneNumber')),
            ),
            ListTile(
              title: Text('${widget.client.email}'),
              subtitle: Text(AppLocalizations.of(context).translate('email')),
            ),
            ListTile(
              title: Text('${widget.client.address}'),
              subtitle: Text(AppLocalizations.of(context).translate('address')),
            ),
            ListTile(
              title: Text('${widget.client.description}'),
              subtitle: Text(AppLocalizations.of(context).translate('notes')),
            ),
            Divider(
              thickness: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget chipDesign(String label, Color color) {
    return GestureDetector(
      onTap: () {
        label == AppLocalizations.of(context).translate('delete')
            ? widget.clientModel.removeClient(widget.client.id)
            : label == AppLocalizations.of(context).translate('edit')
                ? _showModalSheetAppBar(
                    context,
                    AppLocalizations.of(context).translate('editItem'),
                    ClientForm(
                      client: widget.client,
                    ),
                    0.81)
                : Container();
      },
      child: Container(
        child: Chip(
          label: Text(
            label,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: color,
          elevation: 4,
          shadowColor: Colors.grey[50],
          padding: EdgeInsets.all(4),
        ),
        margin: EdgeInsets.only(left: 12, right: 12, top: 2, bottom: 2),
      ),
    );
  }
}
