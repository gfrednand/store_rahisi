import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/providers/cart_model.dart';
import 'package:storeRahisi/providers/item_model.dart';

import '../../app_localizations.dart';

class CartItemDetails extends StatelessWidget {
  final Cart cart;
  final CartModel cartModel;

  CartItemDetails({
    Key key,
    @required this.cart,
    this.cartModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    ItemModel itemModel = Provider.of<ItemModel>(context);
    Item item = itemModel.getItemById(cart.itemId);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      width: screenSize.width,
      child: Card(
        child: Container(
          margin: const EdgeInsets.only(right: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                onTap: () => {},
                title: Text(
                  '${item?.name ?? ''}',
                  style: Theme.of(context).textTheme.headline6,
                ),
                subtitle: Text(
                  'Tshs ${cart?.paidAmount ?? ''}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              Divider(
                height: 2.0,
                color: Colors.grey,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton.icon(
                      onPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(AppLocalizations.of(context).translate('deleteFromCart')),
                              content: Text(AppLocalizations.of(context).translate('areYouSure')),
                              actions: <Widget>[
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    FlatButton(
                                        child: Text(AppLocalizations.of(context).translate('cancel')),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        }),
                                    Container(
                                      color: Colors.grey,
                                      width: 1.0,
                                      height: 24.0,
                                    ),
                                    FlatButton(
                                        child: Text(AppLocalizations.of(context).translate('ok')),
                                        onPressed: () {
                                          cartModel.removeItem(item);
                                             Navigator.of(context).pop();
                                             
                                        })
                                  ],
                                ),
                              ],
                            );
                          }),
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).errorColor,
                      ),
                      label: Text(AppLocalizations.of(context).translate('remove'),
                          style: TextStyle(
                              color: Theme.of(context).errorColor))),
                  Text(
                    "x" +
                        cart?.quantity?.toString() +
                        "=" +
                        (cart.quantity * cart.paidAmount).toString(),
                    style: Theme.of(context).textTheme.headline6,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
