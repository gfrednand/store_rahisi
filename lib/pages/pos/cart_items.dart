import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/pages/base_view.dart';
import 'package:storeRahisi/pages/pos/cart_item_details.dart';
import 'package:storeRahisi/providers/cart_model.dart';
import 'package:storeRahisi/providers/index.dart';
import 'package:storeRahisi/widgets/busy_overlay.dart';
import 'package:storeRahisi/widgets/pos_total_bar.dart';

class CartItems extends StatefulWidget {
  @override
  _CartItemsState createState() => _CartItemsState();
}

class _CartItemsState extends State<CartItems> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    CartModel cartModel = Provider.of<CartModel>(context);
    ItemModel itemModel = Provider.of<ItemModel>(context);
    return BaseView<SaleModel>(
      // onModelReady: (model) => model.listenToItems(),
      builder: (context, model, child) {
        return new Scaffold(
            appBar: AppBar(
              leading: BackButton(),
              centerTitle: true,
              title: Text('Cart (${cartModel.carts.length})'),
            ),
            body: BusyOverlay(
              show: model.busy,
              title: 'Committing Sale',
              child: cartModel.carts.length == 0
                  ? Center(
                      child: Text('Not Found'),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                          POSTotalBar(
                              saleModel: model,
                              context: context,
                              screenSize: screenSize,
                              total: cartModel.totalPrice,
                              subtotal: cartModel.totalPrice,
                              carts: cartModel.carts),
                          Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: cartModel.carts.length,
                                itemBuilder: (context, index) {
                                  if (index < cartModel.carts.length) {
                                    Item item = itemModel.getItemById(
                                        cartModel.carts[index].itemId);

                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      width: screenSize.width,
                                      child: Card(
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              right: 10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              ListTile(
                                                onTap: () => {},
                                                title: Text(
                                                  '${item?.name ?? ''}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6,
                                                ),
                                                subtitle: Text(
                                                  'Tshs ${cartModel.carts[index]?.paidAmount ?? ''}',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle1,
                                                ),
                                              ),
                                              Divider(
                                                height: 2.0,
                                                color: Colors.grey,
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  FlatButton.icon(
                                                      onPressed: () =>
                                                          showDialog(context: context, builder: (BuildContext context) {
                                                                return AlertDialog(
                                                                  title: Text(
                                                                      'Delete Product From Cart'),
                                                                  content: Text(
                                                                      'Are you sure'),
                                                                  actions: <Widget>[
                                                                    Row(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                                                                      children: <Widget>[
                                                                        FlatButton(
                                                                            child: Text('Cancel'),
                                                                            onPressed: () {
                                                                              Navigator.of(context).pop();
                                                                            }),
                                                                        Container(
                                                                          color:  Colors.grey,
                                                                          width: 1.0,
                                                                          height: 24.0,
                                                                        ),
                                                                        FlatButton(
                                                                            child: Text('OK'),
                                                                            onPressed: () {
                                                                              setState(() {
                                                                                cartModel.removeItem(item);
                                                                              });
                                                                              Navigator.of(context).pop();
                                                                            })
                                                                      ],
                                                                    ),
                                                                  ],
                                                                );
                                                              }),
                                                      icon: Icon(
                                                        Icons.delete,
                                                        color: Theme.of(context)
                                                            .errorColor,
                                                      ),
                                                      label: Text("Remove",
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .errorColor))),
                                                  Text(
                                                    "x" +
                                                        cartModel.carts[index]
                                                            ?.quantity
                                                            ?.toString() +
                                                        "=" +
                                                        (cartModel.carts[index]
                                                                    .quantity *
                                                                cartModel
                                                                    .carts[
                                                                        index]
                                                                    .paidAmount)
                                                            .toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6,
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Card(child: Text("data"));
                                  }
                                }),
                          )
                        ]),
            ));
      },
    );
  }
}
