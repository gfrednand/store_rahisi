import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/constants/app_constants.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/pages/base_view.dart';
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

  @override
  Widget build(BuildContext context) {
    CartModel cartModel = Provider.of<CartModel>(context);


    return new BaseView<ClientModel>(
        onModelReady: (model) => model.listenToClients(),
        builder: (context, model, child) {
          List<Client> clients = model.clients != null
              ? model.clients
                  .where((client) =>
                      client.clientType == AppConstants.clientTypeCustomer)
                  .toList()
              : [];

          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text('Check Out'),
            ),
            bottomNavigationBar:
                model.checkedClient != null && cartModel.carts.length > 0
                    ? TotalBar(
                        cartModel: cartModel,
                        route: AppRoutes.payment,
                      )
                    : Container(),
            body: cartModel.carts.length > 0
                ? CustomScrollView(shrinkWrap: true, slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(
                            left: 12.0, top: 5.0, right: 0.0, bottom: 5.0),
                        child: new Text(
                          'Delivery Address',
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: CustomerAddresses(clients: clients),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(
                            left: 12.0, top: 5.0, right: 0.0, bottom: 5.0),
                        child: new Text(
                          'Order Summary',
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: cartModel.carts.length > 0
                          ? OrderSummary(cartModel: cartModel)
                          : Container(),
                    ),

                    // SliverList(
                    //     delegate: new SliverChildListDelegate(
                    //        _buildList(50))),
                  ])
                : RaisedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('No Items'),
                ),
          );
        });
  }
}
