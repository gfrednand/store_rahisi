import 'package:flutter/material.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/pages/base_view.dart';
import 'package:storeRahisi/pages/client/client_detail_widget.dart';
import 'package:storeRahisi/providers/index.dart';

class ClientList extends StatefulWidget {
  final String clientType;

  const ClientList({Key key, this.clientType}) : super(key: key);

  @override
  _ClientListState createState() => _ClientListState();
}

class _ClientListState extends State<ClientList> {
  Client selectedValue;
  int selectedIndex;
  bool isLargeScreen = false;
  @override
  Widget build(BuildContext context) {
    return BaseView<ClientModel>(
        onModelReady: (model) => model.listenToClients(),
        builder: (context, model, child) {
          List<Client> clients = model.clients != null
              ? model.clients
                  .where((client) => client.clientType == widget.clientType)
                  .toList()
              : [];
          return OrientationBuilder(builder: (context, orientation) {
            if (MediaQuery.of(context).size.width > 600) {
              isLargeScreen = true;
            } else {
              isLargeScreen = false;
            }

            return Row(children: <Widget>[
              Expanded(
                flex: 2,
                child: !model.busy
                    ? model.clients == null
                        ? Center(
                            child: Text(AppLocalizations.of(context)
                                .translate('nothingFound')),
                          )
                        : buildScrollbar(clients, context, model)
                    : Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                              Theme.of(context).accentColor),
                        ),
                      ),
              ),
              isLargeScreen
                  ? Expanded(
                      flex: 3,
                      child: ClientDetailWidget(
                        client: selectedValue,
                        clientModel: model,
                      ))
                  : Container(),
            ]);
          });
        });
  }

  Scrollbar buildScrollbar(
      List<Client> clients, BuildContext context, ClientModel model) {
    return Scrollbar(
      child: ListView.builder(
        itemCount: clients.length,
        itemBuilder: (buildContext, index) => Card(
          elevation:
              selectedIndex != null && selectedIndex == index ? 10.0 : 2.0,
          child: Container(
            color:
                selectedIndex != null && selectedIndex == index && isLargeScreen
                    ? Colors.red[50]
                    : Colors.white,
            child: ListTile(
              leading: ExcludeSemantics(
                child: CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    clients[index].companyName.substring(0, 2).toUpperCase(),
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                ),
              ),
              title: Hero(
                tag: '${clients[index].id}__heroTag',
                child: Text(
                  '${clients[index].companyName}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(),
                ),
              ),
              subtitle: Text(
                '${clients[index].phoneNumber}',
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                if (isLargeScreen) {
                  selectedValue = model.clients[index];
                  setState(() {
                    selectedIndex = index;
                  });
                } else {
                  var arguments = {
                    'client': clients[index],
                    'clientModel': model,
                  };
                  Navigator.pushNamed(context, AppRoutes.client_detail,
                      arguments: arguments);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
