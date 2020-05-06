import 'package:flutter/material.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/models/item.dart';
import 'package:storeRahisi/pages/item/item_detail_widget.dart';
import 'package:storeRahisi/providers/index.dart';

class ItemDetail extends StatelessWidget {
  final Item item;
  final ItemModel itemModel;
  const ItemDetail({Key key, this.item, this.itemModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: item.name == null
              ? Text(AppLocalizations.of(context).translate('itemDetails'))
              : Text('${item.name.toUpperCase()}',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline6),
        ),
        body: ItemDetailWidget(
          item: item,
          itemModel: itemModel,
        ));
  }
}
