import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/models/item.dart';
import 'package:storeRahisi/providers/item_model.dart';

class ItemList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemModel>(context);
    return Scrollbar(
      child: StreamBuilder(
          stream: itemProvider.fetchItemsAsStream(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              List<Item> items = snapshot.data.documents
                  .map((doc) => Item.fromMap(doc.data, doc.documentID))
                  .toList();
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (buildContext, index) => Card(
                  child: ListTile(
                    leading: ExcludeSemantics(
                      child: CircleAvatar(
                        radius: 30.0,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          items[index].name.substring(0, 2).toUpperCase(),
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
                        ),
                      ),
                    ),
                    title: Text(
                      '${items[index].name}',
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      '${items[index].purchasePrice}',
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                        '${items[index].openingStock}${items[index].unit}'),
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.item_detail,
                          arguments: items[index]);
                    },
                  ),
                ),
              );
            } else {
              return Text('fetching...');
            }
          }),
    );
  }
}
