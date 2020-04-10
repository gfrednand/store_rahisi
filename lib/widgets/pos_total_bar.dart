
import 'package:flutter/material.dart';

import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/pages/pos/pos_item_list.dart';

typedef onSellCallback = Function(
    String productId, double profit, int quantity, double amount);

class POSTotalBar extends StatelessWidget {
  final BuildContext context;
  final Size screenSize;
  final double total;
  final double subtotal;

  final List<Cart> carts;
  POSTotalBar({
    @required this.context,
    @required this.carts,

    @required this.screenSize,
    @required this.total,
    @required this.subtotal,
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
                          onPressed: () {
                          
                             List<Cart> c = List.from(carts);

                            Navigator.of(context).pop();

                            // await new Future.delayed(
                            //     const Duration(seconds: 1));

                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => PosItemList()),
                            // );
                   
                        
                          },
//                          splashColor: Colors.redAccent,
                        )
             
            ],
          ),
        ),
      ),
    );
  }


}
