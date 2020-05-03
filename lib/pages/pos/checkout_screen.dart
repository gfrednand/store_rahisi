import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/constants/app_constants.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/pages/client/client_form.dart';
// import 'package:storeRahisi/pages/pos/Payment_Screen.dart';
import 'package:storeRahisi/providers/index.dart';
import 'package:storeRahisi/widgets/custom_modal_sheet.dart';
import 'package:storeRahisi/widgets/customer_addresses.dart';
import 'package:storeRahisi/widgets/order_summary.dart';
import 'package:storeRahisi/widgets/total_bar.dart';

class CheckoutPage extends StatefulWidget {
  final List<Client> clients;

  const CheckoutPage({Key key, this.clients}) : super(key: key);
  @override
  State<StatefulWidget> createState() => CheckoutPageState();
}

class CheckoutPageState extends State<CheckoutPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSort = true;

  IconData _backIcon() {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return Icons.arrow_back;
      case TargetPlatform.iOS:
        return Icons.arrow_back_ios;
    }
    assert(false);
    return null;
  }

  String toolbarname = 'CheckOut';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    CartModel cartModel = Provider.of<CartModel>(context);
    ClientModel clientModel = Provider.of<ClientModel>(context);

    final Size size = MediaQuery.of(context).size;

    List<Client> clients = clientModel.clients != null
        ? clientModel.clients
            .where((client) =>
                client.clientType == AppConstants.clientTypeCustomer)
            .toList()
        : [];

    AppBar appBar = AppBar(
      leading: IconButton(
        icon: Icon(_backIcon()),
        alignment: Alignment.centerLeft,
        tooltip: 'Back',
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(toolbarname),
      // backgroundColor: Colors.white,
      actions: <Widget>[
        new Padding(
          padding: const EdgeInsets.all(10.0),
          child: new Container(
            height: 150.0,
            width: 30.0,
            child: new GestureDetector(
              onTap: () {
                /*Navigator.of(context).push(
                  new MaterialPageRoute(
                      builder:(BuildContext context) =>
                      new CartItemsScreen()
                  )
              );*/
              },
            ),
          ),
        )
      ],
    );

    return new Scaffold(
      key: _scaffoldKey,
      appBar: appBar,
      body: SingleChildScrollView(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children:deliveryContents(clients, cartModel, clientModel)
          
          //  <Widget>[
            // Container(
            //     margin: EdgeInsets.all(5.0),
            //     child: Card(
            //         child: Container(
            //             padding: const EdgeInsets.all(10.0),
            //             child: Row(
            //               mainAxisSize: MainAxisSize.max,
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: <Widget>[
            //                 // three line description
            //                 Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: <Widget>[
            //                     Padding(
            //                       padding: const EdgeInsets.only(bottom: 8.0),
            //                       child: Container(
            //                           alignment: Alignment.center,
            //                           child: Row(
            //                             children: <Widget>[
            //                               Text(
            //                                 'Delivery',
            //                                 style: TextStyle(
            //                                     fontSize: 18.0,
            //                                     fontWeight: FontWeight.bold,
            //                                     color: Colors.black),
            //                               ),
            //                               IconButton(
            //                                   icon: Icon(
            //                                     Icons.play_circle_outline,
            //                                     color: Colors.blue,
            //                                   ),
            //                                   onPressed: null)
            //                             ],
            //                           )),
            //                     ),
            //                     Padding(
            //                       padding: const EdgeInsets.only(bottom: 8.0),
            //                       child: Container(
            //                           alignment: Alignment.center,
            //                           child: Row(
            //                             children: <Widget>[
            //                               Text(
            //                                 'Payment',
            //                                 style: TextStyle(
            //                                     fontSize: 18.0,
            //                                     fontWeight: FontWeight.bold,
            //                                     color: Colors.black38),
            //                               ),
            //                               IconButton(
            //                                   icon: Icon(
            //                                     Icons.check_circle,
            //                                     color: Colors.black38,
            //                                   ),
            //                                   onPressed: null)
            //                             ],
            //                           )),
            //                     ),
            //                   ],
            //                 ),
            //               ],
            //             )))),
            // // width > 600
            //     ? Expanded(
            //         child: ListView(
            //         children: deliveryContents(clients, cartModel, clientModel),
            //       ))
            //     :
     
          // ],
        ),
      ),
    );
  }

  _verticalDivider() => Container(
        padding: EdgeInsets.all(2.0),
      );

  List<Widget> deliveryContents(
      List<Client> clients, CartModel cartModel, ClientModel clientModel) {
    return [
      // _verticalDivider(),
      new Container(
        alignment: Alignment.topLeft,
        margin: EdgeInsets.only(left: 12.0, top: 5.0, right: 0.0, bottom: 5.0),
        child: new Text(
          'Delivery Address',
          style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 18.0),
        ),
      ),
      CustomerAddresses(clients: clients),
      // _verticalDivider(),
      new Container(
        alignment: Alignment.topLeft,
        margin: EdgeInsets.only(left: 12.0, top: 5.0, right: 0.0, bottom: 5.0),
        child: new Text(
          'Order Summary',
          style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 18.0),
        ),
      ),
      SizedBox(
        height: 450.0,
          child: cartModel.carts.length > 0
              ? OrderSummary(cartModel: cartModel)
              : Container()),
      // const Expanded(child: SizedBox()),
      // const Divider(height: 1.0, color: Colors.grey),
      clientModel.checkedClient != null && cartModel.carts.length > 0
          ? TotalBar(
              cartModel: cartModel,
              route: AppRoutes.payment,
            )
          : Container(),
    ];
  }
}
