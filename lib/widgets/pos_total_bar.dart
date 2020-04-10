import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/pages/pos/pos_item_list.dart';
import 'package:storeRahisi/providers/sale_model.dart';

typedef onSellCallback = Function(
    String productId, double profit, int quantity, double amount);

class POSTotalBar extends StatelessWidget {
  final BuildContext context;
  final Size screenSize;
  final double total;
  final double subtotal;
  final SaleModel saleModel;

  final List<Cart> carts;
  POSTotalBar({
    @required this.context,
    @required this.carts,
    @required this.screenSize,
    @required this.total,
    @required this.subtotal, this.saleModel,
  });
  @override
  Widget build(context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      width: screenSize.width,
      child: Card(
        elevation: 10.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "SubTotal",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(
                    "Tsh $subtotal",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
              Container(
                color: Theme.of(context).primaryColor,
                width: screenSize.width,
                height: 1.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Text(
                    "Tsh $total",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
              //  SizedBox(height: 12.0),
              total <= 0
                  ? new Container()
                  : MaterialButton(
                      color: Theme.of(context).accentColor,
//                          textColor: Colors.white,
                      child: new Text("Sell"),
                      onPressed: () async {
                        List<Item> items = [];
                        List<Cart> c = List.from(carts);
                        c.forEach((cart) {
                          items.add(Item(
                              name: '',
                              id: cart.itemId,
                              paidAmount: cart.paidAmount,
                              quantity: cart.quantity));
                        });
                        double tax = 0.0;
                        double discount = 0.0;

                        await saleModel.saveSale(
                            data: Sale(
                                discount: discount,
                                grandTotal: (total + tax) - discount,
                                paymentMethod: 'Cash',
                                subTotal: total - discount,
                                tax: tax,
                                items: items));
                      },
                         splashColor: Colors.redAccent,
                    )
            ],
          ),
        ),
      ),
    );
  }
}
