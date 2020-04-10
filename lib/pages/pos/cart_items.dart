import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/pages/base_view.dart';
import 'package:storeRahisi/pages/pos/cart_item_details.dart';
import 'package:storeRahisi/providers/cart_model.dart';
import 'package:storeRahisi/providers/index.dart';
import 'package:storeRahisi/widgets/busy_overlay.dart';
import 'package:storeRahisi/widgets/pos_total_bar.dart';

class CartItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    CartModel cartModel = Provider.of<CartModel>(context);
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
                                    return new CartItemDetails(
                                      cart: cartModel.carts[index],
                                      cartModel: cartModel,
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
