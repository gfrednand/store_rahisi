import 'package:flutter/material.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/pages/base_view.dart';
import 'package:storeRahisi/providers/item_model.dart';

class ItemList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<ItemModel>(
      onModelReady: (model) => model.listenToItems(),
      builder: (context, model, child) {
        return Scrollbar(
            child: !model.busy
                ? model.items == null
                    ? Center(
                        child: Text('Nothing Found'),
                      )
                    : ListView.builder(
                        itemCount: model.items.length,
                        itemBuilder: (buildContext, index) => Card(
                          child: ListTile(
                            leading: ExcludeSemantics(
                              child: CircleAvatar(
                                radius: 30.0,
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Text(
                                  model.items[index].name
                                      .substring(0, 2)
                                      .toUpperCase(),
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor),
                                ),
                              ),
                            ),
                            title: Text(
                              '${model.items[index].name}',
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              '${model.items[index].purchasePrice}',
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Text(
                                '${model.items[index].openingStock}${model.items[index].unit}'),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.item_detail,
                                  arguments: model.items[index]);
                            },
                          ),
                        ),
                      )
                : Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                          Theme.of(context).primaryColor),
                    ),
                  ));
      },
    );
  }
}
