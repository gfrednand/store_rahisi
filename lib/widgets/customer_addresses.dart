import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/constants/app_constants.dart';
import 'package:storeRahisi/models/client.dart';
import 'package:storeRahisi/pages/client/client_form.dart';
import 'package:storeRahisi/providers/client_model.dart';
import 'package:storeRahisi/widgets/custom_modal_sheet.dart';

class CustomerAddresses extends StatefulWidget {
  final List<Client> clients;

  const CustomerAddresses({Key key, this.clients}) : super(key: key);

  @override
  _CustomerAddressesState createState() => _CustomerAddressesState();
}

class _CustomerAddressesState extends State<CustomerAddresses> {
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
    ClientModel clientModel = Provider.of<ClientModel>(context, listen: true);

    return SizedBox(
      height: 165.0,
      child: ListView.builder(
        itemCount: widget.clients.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) =>  index == 0
            ? Wrap(
              direction: Axis.horizontal,
                children: [
                  Container(
                    margin: EdgeInsets.all(7.0),
                    width: 56.0,
                    color: Theme.of(context).accentColor,
                    child: Card(
                      elevation: 3.0,
                      child: new Center(
                          child: IconButton(
                              icon: Icon(Icons.add, color: Theme.of(context).accentColor,),
                              onPressed: () {
                                _showModalSheetAppBar(
                                    context,
                                    AppLocalizations.of(context)
                                            .translate('add') +
                                        ' ' +
                                        AppConstants.clientTypeCustomer,
                                    ClientForm(
                                      clientType:
                                          AppConstants.clientTypeCustomer,
                                    ),
                                    0.7);
                              })),
                    ),
                  ),
                  buildClientContainer(Client.defaultCustomer(), clientModel),
                  buildClientContainer(widget.clients[index], clientModel)
                ],
              )
            : Wrap(
              children: [
                buildClientContainer(widget.clients[index], clientModel),
              ],
            ),
      ),
    );
  }

  Widget buildClientContainer(Client client, ClientModel clientModel) {
    return Container(
      // width: 200.0,
      margin: EdgeInsets.all(7.0),
      child: Card(
        elevation: 3.0,
        child: new Column(
          children: <Widget>[
            new Container(
              margin: EdgeInsets.only(
                  left: 12.0, top: 5.0, right: 0.0, bottom: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    client.companyName,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  _verticalDivider(),
                  new Text(
                    client.contactPerson,
                    style: TextStyle(
                        color: Colors.black45,
                        fontSize: 13.0,
                        letterSpacing: 0.5),
                  ),
                  _verticalDivider(),
                  new Text(
                    client.phoneNumber,
                    style: TextStyle(
                        color: Colors.black45,
                        fontSize: 13.0,
                        letterSpacing: 0.5),
                  ),
                  _verticalDivider(),
                  new Text(
                    client.address,
                    style: TextStyle(
                        color: Colors.black45,
                        fontSize: 13.0,
                        letterSpacing: 0.5),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        'Delivery Address',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black26,
                        ),
                      ),
                      _verticalD(),
                      new Checkbox(
                        value: clientModel.checkedClient.id == client.id,
                        onChanged: (bool value) {
                          if (value) {
                            setState(() {
                              clientModel.setCheckedclient(client);
                            });
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _verticalDivider() => Container(
        padding: EdgeInsets.all(2.0),
      );

  _verticalD() => Container(
        margin: EdgeInsets.only(left: 3.0, right: 0.0, top: 0.0, bottom: 0.0),
      );
}
