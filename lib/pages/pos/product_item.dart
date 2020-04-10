import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:storeRahisi/models/item.dart';
import 'package:storeRahisi/providers/cart_model.dart';

class PosItem extends StatefulWidget {
  final Item item;
  final int quantity;
  final double currentPrice;
  final double originalPrice;
  final double profit;
  final double discount;
  final String imageUrl;

  const PosItem(
      {Key key,
      this.quantity,
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
  TextEditingController quantityController =
      new TextEditingController(text: '0');

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    CartModel cartModel = Provider.of<CartModel>(context);

    return new Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      width: screenSize.width,
      child: new Card(
        elevation: 2.0,
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
                  Text(widget.item.name + " * " + widget.quantity.toString(),
                      style: Theme.of(context).textTheme.headline6),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "\Tsh ${widget.currentPrice}",
                        style:
                            TextStyle(fontSize: 16.0, color: Colors.green[900]),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      widget.originalPrice > 0
                          ? Text(
                              "\Tsh ${widget.originalPrice}",
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.red,
                                decoration: TextDecoration.lineThrough,
                              ),
                            )
                          : Text(""),
                      SizedBox(
                        width: 8.0,
                      ),
                      widget.discount > 0
                          ? Text(
                              "${widget.discount.toStringAsFixed(1)}\% off",
                              style:
                                  TextStyle(fontSize: 12.0, color: Colors.grey),
                            )
                          : Text("")
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  new IconButton(
                    icon: new Icon(Icons.remove_circle,
                        color: Theme.of(context).accentColor),
                    onPressed: () {
                      setState(() {
                        if (_itemCount != 0) {
                          _itemCount--;
                        }

                        quantityController = new TextEditingController(
                            text: _itemCount.toString());
                      });
                      widget.item.salePrice = widget.currentPrice;
                      widget.item.quantity = _itemCount;
                      cartModel.setItem(widget.item);
                    },
                  ),
                  // new Text(
                  //   _itemCount.toString(),
                  //   style: Theme.of(context).textTheme.headline4,
                  // ),
                  Container(
                    width: 40.0,
                    child: TextFormField(
                      onChanged: (val) {
                        _itemCount = int.parse(val);
                        setCartItem(cartModel);
                      },
                      decoration: const InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 40.0),
                      ),
                      keyboardType: TextInputType.number,
                      controller: quantityController,
                    ),
                  ),

                  new IconButton(
                      icon: new Icon(Icons.add_circle,
                          color: Theme.of(context).accentColor),
                      onPressed: () {
                        setState(() {
                          if (_itemCount < widget.quantity) {
                            _itemCount++;
                          }

                          quantityController = new TextEditingController(
                              text: _itemCount.toString());
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
    );
  }

  void setCartItem(CartModel cartModel) {
    widget.item.salePrice = widget.currentPrice;
    widget.item.quantity = _itemCount;
    cartModel.setItem(widget.item);
  }
}
