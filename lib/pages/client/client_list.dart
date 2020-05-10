import 'package:flutter/material.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/constants/app_constants.dart';
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
                    ? model.clients.length == 0
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
          itemBuilder: (buildContext, index) {
            String displayName =
                clients[index].clientType == AppConstants.clientTypeSupplier
                    ? clients[index].companyName
                    : clients[index].contactPerson;

                clients[index].proviousDue = model.getDueAmountByClientId(clients[index].id);

            return Column(
              children: [
                Divider(
                  height: 5.0,
                ),
                Container(
                  color: selectedIndex != null &&
                          selectedIndex == index &&
                          isLargeScreen
                      ? Colors.red[50]
                      : Theme.of(context).colorScheme.primaryVariant,
                  child: ListTile(
                    leading: ExcludeSemantics(
                      child: CircleAvatar(
                        radius: 25.0,
                        backgroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        child: Text(
                          displayName.substring(0, 2).toUpperCase(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight:
                                selectedIndex != null && selectedIndex == index
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    title: Hero(
                      tag: '${clients[index].id}__heroTag',
                      child: Text(displayName.toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText1),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        clients[index].proviousDue == 0.0
                            ? Container()
                            : Text(
                                'Previous Due: ${clients[index].proviousDue}',
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .copyWith(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                              ),
                        Text(
                          '${clients[index].phoneNumber}',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).iconTheme.color,
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
              ],
            );
          }),
    );
  }
}
