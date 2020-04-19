import 'package:flutter/material.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/pages/base_view.dart';
import 'package:storeRahisi/providers/index.dart';

class ClientList extends StatelessWidget {
  final String clientType;

  const ClientList({Key key, this.clientType}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BaseView<ClientModel>(
        onModelReady: (model) => model.listenToClients(),
        builder: (context, model, child) {
          List<Client> clients = model.clients != null
              ? model.clients.where((client) => client.clientType == clientType).toList()
              : [];
          return !model.busy
              ? model.clients == null
                  ? Center(
                      child: Text(AppLocalizations.of(context).translate('nothingFound')),
                    )
                  : Scrollbar(
                      child: ListView.builder(
                        itemCount: clients.length,
                        itemBuilder: (buildContext, index) => Card(
                          child: ListTile(
                            leading: ExcludeSemantics(
                              child: CircleAvatar(
                                radius: 30.0,
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Text(
                                  clients[index]
                                      .companyName
                                      .substring(0, 2)
                                      .toUpperCase(),
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor),
                                ),
                              ),
                            ),
                            title: Hero(
                              tag: '${clients[index].id}__heroTag',
                              child: Text(
                                '${clients[index].companyName}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            subtitle: Text(
                              '${clients[index].phoneNumber}',
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              var arguments = {
                                'client': clients[index],
                                'clientModel': model,
                              };
                              Navigator.pushNamed(
                                  context, AppRoutes.client_detail,
                                  arguments: arguments);
                            },
                          ),
                        ),
                      ),
                    )
              : Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation(Theme.of(context).accentColor),
                  ),
                );
        });
  }
}
