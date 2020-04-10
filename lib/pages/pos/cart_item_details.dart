import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/providers/cart_model.dart';
import 'package:storeRahisi/providers/item_model.dart';

class CartItemDetails extends StatelessWidget {
  final Cart cart;

  CartItemDetails({
    Key key,
    @required this.cart,
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
                  'Tshs ${cart?.price?? ''}',
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
                            CartModel cartModel = Provider.of<CartModel>(context);
                            return AlertDialog(
                              title: Text('Delete Product From Cart'),
                              content: Text('Are you sure'),
                              actions: <Widget>[
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    FlatButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        }),
                                    Container(
                                      color: Colors.grey,
                                      width: 1.0,
                                      height: 24.0,
                                    ),
                                    FlatButton(
                                        child: Text('OK'), onPressed: () {
                                          cartModel.removeItem(item);
                                        })
                                  ],
                                ),
                              ],
                            );
                          }),
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).primaryColor,
                      ),
                      label: Text("Remove",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor))),
                  // Text(
                  //   "x" +
                  //       cart?.quantity?.toString() ,
                  //       // +
                  //       // "=" +
                  //       // (cart.quantity * price.amount).toString(),
                  //   style: Theme.of(context).textTheme.headline6,
                  // )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
