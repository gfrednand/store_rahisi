import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:storeRahisi/pages/base_view.dart';
import 'package:storeRahisi/pages/pos/cart_item_details.dart';
import 'package:storeRahisi/providers/cart_model.dart';
import 'package:storeRahisi/widgets/pos_total_bar.dart';

class CartItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;


    return  BaseView<CartModel>(
        // onModelReady: (model) => model.listenToItems(),
        builder: (context, model, child) {
          return  new Scaffold(
          appBar: AppBar(
            leading: BackButton(),
            centerTitle: true,
            title: Text('Cart (${model.carts.length})'),
          ),
          body: model.busy
              ? Center(child: CircularProgressIndicator())
              : model.carts.length == 0
                  ? Center(child: Text('Not Found'),)
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                          POSTotalBar(
                              context: context,
                              screenSize: screenSize,
                              total: model.totalPrice,
                              subtotal: model.totalPrice,
                              carts:model.carts),
                          Expanded(
                            child: ListView.builder(
                        
                                shrinkWrap: true,
                                itemCount:model.carts.length,
                                itemBuilder: (context, index) {
                                  if (index < model.carts.length) {
                                    return new CartItemDetails(
                                      cart:model.carts[index],
                                    );
                                  } else {
                                    return Card(child: Text("data"));
                                  }
                                }),
                          )
                        ]),
        );
      },
    );
  }
}

