import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/constants/currency_input_formatter.dart';
import 'package:storeRahisi/constants/ui_helpers.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/providers/index.dart';
import 'package:storeRahisi/widgets/busy_button.dart';
import 'package:storeRahisi/widgets/toast.dart';

class PaymentPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PaymentPageState();
}

class PaymentPageState extends State<PaymentPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double paidAmount = 0.0;
  TextEditingController paidAmountController =
      new TextEditingController();

  int radioValue = 0;
  void handleRadioValueChanged(int value) {
    setState(() {
      radioValue = value;
    });
  }

  List<Item> itemList = [];
  String toolbarname = 'Payments';

  @override
  void initState() {
    paidAmountController.addListener(() {
      paidAmount = double.tryParse(paidAmountController.text.replaceAll(new RegExp(r','), '')) ?? 0.0;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CartModel cartModel = Provider.of<CartModel>(context);
    SaleModel saleModel = Provider.of<SaleModel>(context);
    ClientModel clientModel = Provider.of<ClientModel>(context);

    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          centerTitle: true,
          title:
              Text('Payments', style: Theme.of(context).textTheme.headline6)),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: EdgeInsets.all(10.0),
              child: Card(
                child: Container(
                    padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                    child: Text(
                        "${clientModel.checkedClient.contactPerson.toUpperCase()}",
                        maxLines: 10,
                        style:
                            TextStyle(fontSize: 13.0, color: Colors.black87))),
              )),
          Container(
              margin: EdgeInsets.all(10.0),
              child: Card(
                child: Container(
                  color: Colors.green.shade100,
                  child: Container(
                      padding:
                          const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                      child: Text(
                          "Total Amount: TShs ${currencyFormat.format(cartModel.totalPrice)}",
                          maxLines: 10,
                          style: TextStyle(
                              fontSize: 15.0, color: Colors.black87))),
                ),
              )),
          // new Container(
          //   alignment: Alignment.topLeft,
          //   margin:
          //       EdgeInsets.only(left: 12.0, top: 5.0, right: 0.0, bottom: 5.0),
          //   child: new Text(
          //     'Payment Method',
          //     style: TextStyle(
          //         color: Colors.black87,
          //         fontWeight: FontWeight.bold,
          //         fontSize: 18.0),
          //   ),
          // ),
          // _verticalDivider(),
          new Container(
            margin: EdgeInsets.all(10.0),
            child: TextField(
              controller: paidAmountController,
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
                // Fit the validating format.
                CurrencyInputFormatter()
              ],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: "Paid Amount",
                  // prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder()),
            ),
          ),
          Divider(),
          _verticalD(),
          cartModel.totalPrice > paidAmount
              ? Container(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                      "Amount Due ${currencyFormat.format(cartModel.totalPrice - paidAmount)}",
                      maxLines: 10,
                      style: TextStyle(fontSize: 15.0, color: Colors.black)),
                )
              : paidAmount > cartModel.totalPrice
                  ? Container(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                          "Change ${currencyFormat.format(cartModel.totalPrice - paidAmount)}",
                          maxLines: 10,
                          style:
                              TextStyle(fontSize: 15.0, color: Colors.black)),
                    )
                  : Container(),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.center,
              child: BusyButton(
                title: 'Pay',
                enabled: paidAmount != null,
                onPressed: () async {
                  List<Item> items = [];
                  List<Cart> c = List.from(cartModel.carts);
                  c.forEach((cart) {
                    items.add(Item(
                        name: '',
                        id: cart.itemId,
                        paidAmount: cart.paidAmount,
                        quantity: cart.quantity));
                  });
                  double tax = 0.0;
                  double discount = 0.0;

                  bool success = await saleModel.saveSale(
                      data: Sale(
                          clientId: clientModel.checkedClient.id,
                          discount: discount,
                          grandTotal: (cartModel.totalPrice + tax) - discount,
                          paymentMethod: 'Cash',
                          paidAmount: paidAmount,
                          subTotal: cartModel.totalPrice - discount,
                          tax: tax,
                          items: items));
                  if (success) {
                    Toast.show(
                        message: 'Sold Successful', context: context);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  _verticalD() => Container(
        margin: EdgeInsets.only(left: 5.0),
      );
}
