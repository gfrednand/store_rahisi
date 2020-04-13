import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/models/index.dart';

import 'package:storeRahisi/models/purchase.dart';
import 'package:storeRahisi/pages/purchase/purchase_form.dart';
import 'package:storeRahisi/pages/purchase/purchase_payment_form.dart';
import 'package:storeRahisi/providers/index.dart';

import 'package:storeRahisi/widgets/custom_modal_sheet.dart';
import 'package:storeRahisi/widgets/toast.dart';

class PurchaseDetail extends StatefulWidget {
  final Purchase purchase;
  final PurchaseModel purchaseModel;
  const PurchaseDetail({Key key, this.purchase, this.purchaseModel})
      : super(key: key);
  @override
  _PurchaseDetailState createState() => _PurchaseDetailState();
}

class _PurchaseDetailState extends State<PurchaseDetail> {
  TextEditingController salePriceController;
  void _showToast(String message, Color backGroundColor, IconData icon) {
    Toast.show(
      message: message,
      context: context,
      icon: Icon(icon, color: Colors.white),
      backgroundColor: backGroundColor,
    );
  }

  _showModalSheetAppBar(
      BuildContext context, String title, Widget body, double heightFactor) {
    CustomModalSheet.show(
      title: title,
      context: context,
      body: body,
      heightFactor: heightFactor,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> tabs = ['Details', 'Items', 'Payment History', 'Make Payment'];
    PaymentModel paymentModel = Provider.of<PaymentModel>(context);
    List<Payment> payments =
        paymentModel.getPaymentsByPurchaseId(widget.purchase.id);

    double dueAmount = widget.purchase.grandTotalAmount - widget.purchase.paidAmount;
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: widget.purchase.purchaseDate == null
              ? Text('Purchase Detail')
              : Text(
                  '${widget.purchase.purchaseDate.toUpperCase()}',
                  overflow: TextOverflow.ellipsis,
                ),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              for (final tab in tabs) Tab(text: tab),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Wrap(
                    spacing: 0.0, // gap between adjacent chips
                    runSpacing: 0.0, // gap between lines
                    children: <Widget>[
                      chipDesign("Edit", Color(0xFF4db6ac)),
                      chipDesign("Delete", Color(0xFFf06292)),
                    ],
                  ),
                  Divider(
                    thickness: 10.0,
                  ),
                  ListTile(
                    title: Text('${widget.purchase.companyName}'),
                    subtitle: Text('Client'),
                  ),
                  ListTile(
                    title: Text('${widget.purchase.referenceNumber}'),
                    subtitle: Text('Bill No'),
                  ),
                  Divider(
                    thickness: 10.0,
                  ),
                  ListTile(
                    title: Text('${widget.purchase.grandTotalAmount}'),
                    subtitle: Text('Grand Total'),
                  ),
                  ListTile(
                    title: Text('${widget.purchase.paidAmount}'),
                    subtitle: Text('Paid Amount'),
                  ),
                  ListTile(
                    title: Text('$dueAmount'),
                    subtitle: Text('Due Amount'),
                  ),
                  Divider(
                    thickness: 10.0,
                  ),
                ],
              ),
            ),
            ListView.builder(
                itemCount: widget.purchase.items.length,
                itemBuilder: (buildContext, index) {
                  ItemModel itemModel = Provider.of<ItemModel>(context);
                  Item item =
                      itemModel.getItemById(widget.purchase.items[index].id);
                  return Card(
                    child: ListTile(
                      leading: ExcludeSemantics(
                        child: CircleAvatar(
                          radius: 30.0,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            item?.name?.substring(0, 2)?.toUpperCase(),
                            style:
                                TextStyle(color: Theme.of(context).accentColor),
                          ),
                        ),
                      ),
                      title: Text(
                        '${item?.name}',
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Purchase Price: ${widget.purchase.items[index].purchasePrice} @1',
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Sale Price: ${widget.purchase.items[index].salePrice} @1',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      trailing:
                          Text('${widget.purchase.items[index].quantity}'),
                      onTap: () {
                        // Navigator.pushNamed(
                        //     context, AppRoutes.purchase_detail,
                        //     arguments: items[index]);
                      },
                    ),
                  );
                }),
            ListView.builder(
                itemCount: payments.length,
                itemBuilder: (buildContext, index) {
                  ClientModel clientModel =
                      Provider.of<ClientModel>(context);
                  Client client =
                      clientModel.getClientById(payments[index].clientId);
                  return Card(
                    child: ListTile(
                      leading: ExcludeSemantics(
                        child: CircleAvatar(
                          radius: 30.0,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            'P',
                            style:
                                TextStyle(color: Theme.of(context).accentColor),
                          ),
                        ),
                      ),
                      title: Text(
                        '${client?.companyName}',
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '${payments[index]?.method} | ${payments[index]?.type}',
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(' ${payments[index]?.amount} /='),
                      onTap: () {
                        // Navigator.pushNamed(
                        //     context, AppRoutes.purchase_detail,
                        //     arguments: items[index]);
                      },
                    ),
                  );
                }),
            dueAmount > 0
                ? PurchasePaymentForm(
                        dueAmount: dueAmount,
                        purchase: widget.purchase,
                  )
                : Container(
                    child: Center(
                      child: Text('No Due'),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget chipDesign(String label, Color color) {
    return GestureDetector(
      onTap: () {
        label == 'Delete'
            ? widget.purchaseModel.removePurchase(widget.purchase.id)
            : label == 'Edit'
                ? _showModalSheetAppBar(
                    context,
                    'Edit Purchase',
                    PurchaseForm(
                      purchase: widget.purchase,
                    ),
                    0.81)
                : _showToast(label + ' Selected', color, Icons.error_outline);
      },
      child: Container(
        child: Chip(
          label: Text(
            label,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: color,
          elevation: 4,
          shadowColor: Colors.grey[50],
          padding: EdgeInsets.all(4),
        ),
        margin: EdgeInsets.only(left: 12, right: 12, top: 2, bottom: 2),
      ),
    );
  }
}
