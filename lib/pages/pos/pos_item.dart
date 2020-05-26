import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/constants/ui_helpers.dart';
import 'package:storeRahisi/models/item.dart';
import 'package:storeRahisi/providers/cart_model.dart';
import 'package:storeRahisi/providers/index.dart';

class PosItem extends StatefulWidget {
  final Item item;
  final int quantity;
  final int initialCount;
  final double currentPrice;
  final double originalPrice;
  final double profit;
  final double discount;
  final String imageUrl;

  const PosItem(
      {Key key,
      this.quantity,
      this.initialCount,
      this.profit,
      this.item,
      this.currentPrice,
      this.originalPrice,
      this.discount,
      this.imageUrl})
      : super(key: key);

  @override
  _PosItemState createState() => _PosItemState();
}

class _PosItemState extends State<PosItem> {
  int _itemCount = 0;
  TextEditingController quantityController = new TextEditingController();
  @override
  void initState() {
   if(widget.initialCount!=null){
     _itemCount =widget.initialCount;
   }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    CartModel cartModel = Provider.of<CartModel>(context);
    SaleModel saleModel = Provider.of<SaleModel>(context);
    PurchaseModel purchaseModel = Provider.of<PurchaseModel>(context);
    int totalSales = saleModel.getTotalSaleByItemId(widget.item.id) ?? 0;
    int totalPurchases =
        purchaseModel.getTotalPurchaseByItemId(widget.item.id) ?? 0;
    int inStock = (totalPurchases + widget.item.openingStock) - totalSales;

    return Column(
      children: [
        Divider(height: 5.0,),
        new Container(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          width: screenSize.width,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      '${widget.item.name?.toUpperCase()} x$_itemCount =${widget.currentPrice * _itemCount}  ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'In Stock $inStock ',
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                       Text(
                          "\Tsh ${currencyFormat.format(widget.item.salePrice??0)}",
                          style:
                              TextStyle(fontSize: 15.0, color: Colors.green[900]),
                        ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: <Widget>[
                    //     Text(
                    //       "\Tsh ${currencyFormat.format(widget.currentPrice)}",
                    //       style:
                    //           TextStyle(fontSize: 15.0, color: Colors.green[900]),
                    //     ),
                    //     SizedBox(
                    //       width: 8.0,
                    //     ),
                    //     widget.originalPrice > 0
                    //         ? Text(
                    //             "\Tsh ${currencyFormat.format(widget.originalPrice)}",
                    //             style: TextStyle(
                    //               fontSize: 12.0,
                    //               color: Colors.red,
                    //               decoration: TextDecoration.lineThrough,
                    //             ),
                    //           )
                    //         : Text(""),
                    //     SizedBox(
                    //       width: 8.0,
                    //     ),
                    //     widget.discount > 0
                    //         ? Text(
                    //             "${widget.discount.toStringAsFixed(1)}\% " +
                    //                 AppLocalizations.of(context).translate('off'),
                    //             style:
                    //                 TextStyle(fontSize: 12.0, color: Colors.grey),
                    //           )
                    //         : Text("")
                    //   ],
                    // ),
                   
                    // SizedBox(
                    //   height: 8.0,
                    // ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new IconButton(
                      icon: new Icon(Icons.remove_circle,
                          color: Theme.of(context).accentColor),
                      onPressed: () {
                        setState(() {
                          if (_itemCount != 0) {
                            _itemCount--;

                            quantityController = new TextEditingController(
                                text: _itemCount.toString());
                          }
                        });
                        widget.item.salePrice = widget.currentPrice;
                        widget.item.quantity = _itemCount;
                        cartModel.setItem(widget.item);
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                              title: Text('Quantity: Max= $inStock'),
                              content: Container(
                                width: 40.0,
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    hintText: '0',
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 40.0),
                                  ),
                                  keyboardType: TextInputType.number,
                                  controller: quantityController,
                                ),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.pop(
                                          context, quantityController.text);
                                    }),
                              ]),
                        ).then<void>((value) {
                          // The value passed to Navigator.pop() or null.
                          if (value != null) {
                            // print(value);
                            if (int.parse(value) < inStock ||
                                int.parse(value) == inStock) {
                              _itemCount = int.parse(value);
                              setCartItem(cartModel);
                            } else {
                              quantityController = TextEditingController(
                                  text: _itemCount.toString());
                            }
                          }
                        });
                      },
                      child: Container(
                        width: 40.0,
                        child: Text(_itemCount.toString(),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline6),
                      ),
                    ),
                    new IconButton(
                        icon: new Icon(Icons.add_circle,
                            color: Theme.of(context).accentColor),
                        onPressed: () {
                          setState(() {
                            if (_itemCount < inStock) {
                              _itemCount++;
                              quantityController = new TextEditingController(
                                  text: _itemCount.toString());
                            }
                          });
                          widget.item.salePrice = widget.currentPrice;
                          widget.item.quantity = _itemCount;
                          cartModel.setItem(widget.item);
                        }),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  void setCartItem(CartModel cartModel) {
    widget.item.salePrice = widget.currentPrice;
    widget.item.quantity = _itemCount;
    cartModel.setItem(widget.item);
  }
}
