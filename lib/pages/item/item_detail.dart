import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/models/item.dart';
import 'package:storeRahisi/pages/item/item_detail_widget.dart';
import 'package:storeRahisi/providers/index.dart';

class ItemDetail extends StatelessWidget {
  final String id;
  const ItemDetail({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text(AppLocalizations.of(context).translate('itemDetails'),
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline6)),
        body: Selector<ItemModel, Item>(
            selector: (context, model) => model.getItemById(id),
            shouldRebuild: (prev, next) => next != null,
            builder: (context, item, _) => ItemDetailWidget(
                  item: item,
                )));
  }
}
