import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: widget.client.companyName == null
            ? Text('Client Details')
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
                chipDesign("Edit", Color(0xFF4db6ac)),
                purchases.length == 0
                    ? chipDesign("Delete", Color(0xFFf06292))
                    : Container(),
              ],
            ),
            Divider(
              thickness: 10.0,
            ),
            ListTile(
              title: Text('${widget.client.companyName}'),
              subtitle: Text(' Company Name'),
            ),
            ListTile(
              title: Text('${widget.client.contactPerson}'),
              subtitle: Text('Contact Person'),
            ),
            Divider(
              thickness: 10.0,
            ),
            ListTile(
              title: Text('${widget.client.phoneNumber}'),
              subtitle: Text('Phone Number'),
            ),
            ListTile(
              title: Text('${widget.client.email}'),
              subtitle: Text('Email'),
            ),
            ListTile(
              title: Text('${widget.client.address}'),
              subtitle: Text('Address'),
            ),
            ListTile(
              title: Text('${widget.client.description}'),
              subtitle: Text('Note'),
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
        label == 'Delete'
            ? widget.clientModel.removeClient(widget.client.id)
            : label == 'Edit'
                ? _showModalSheetAppBar(
                    context,
                    'Edit Product',
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
