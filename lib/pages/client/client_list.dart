import 'package:flutter/material.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/pages/base_view.dart';
import 'package:storeRahisi/providers/index.dart';

class ClientList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<ClientModel>(
        onModelReady: (model) => model.listenToClients(),
        builder: (context, model, child) {
          return !model.busy
              ? model.clients == null
                  ? Center(
                      child: Text('Nothing Found'),
                    )
                  : Scrollbar(
                      child: ListView.builder(
                        itemCount: model.clients.length,
                        itemBuilder: (buildContext, index) => Card(
                          child: ListTile(
                            leading: ExcludeSemantics(
                              child: CircleAvatar(
                                radius: 30.0,
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Text(
                                  model.clients[index].companyName
                                      .substring(0, 2)
                                      .toUpperCase(),
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor),
                                ),
                              ),
                            ),
                            title: Hero(
                              tag: '${model.clients[index].id}__heroTag',
                              child: Text(
                                '${model.clients[index].companyName}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            subtitle: Text(
                              '${model.clients[index].phoneNumber}',
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              var arguments = {
                                'client': model.clients[index],
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
