import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/pages/purchase/purchase_payment_form.dart';
import 'package:storeRahisi/providers/index.dart';
import 'package:storeRahisi/widgets/circle_tab_indicator.dart';

class PurchaseDetailWidget extends StatefulWidget {
  final Purchase purchase;
  final PurchaseModel purchaseModel;

  const PurchaseDetailWidget({Key key, this.purchase, this.purchaseModel})
      : super(key: key);

  @override
  _PurchaseDetailWidgetState createState() => _PurchaseDetailWidgetState();
}

class _PurchaseDetailWidgetState extends State<PurchaseDetailWidget> {
  int currentSelection = 0;
  @override
  Widget build(BuildContext context) {
    return widget.purchase == null
        ? Center(
            child: Text('Purchase Details'),
          )
        : buildTabContainer(context);
  }

  Widget chipDesign(String label, Color color) {
    return GestureDetector(
      onTap: () {
        if (label == 'Delete') {
          widget.purchaseModel.removePurchase(widget.purchase.id);
        }

        if (label == 'Edit') {
          widget.purchaseModel.setEdittingPurchase(widget.purchase);
          Navigator.pushNamed(context, AppRoutes.purchase_add, arguments: {
            'title': AppLocalizations.of(context).translate('editPurchase'),
            'purchase': widget.purchase,
          });
        }
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

  DefaultTabController buildTabContainer(BuildContext context) {
    PaymentModel paymentModel = Provider.of<PaymentModel>(context);
    List<Payment> payments = widget.purchase == null
        ? []
        : paymentModel.getPaymentsByPurchaseId(widget.purchase.id);

    double dueAmount = widget.purchase == null
        ? 0
        : widget.purchase.grandTotalAmount - widget.purchase.paidAmount;

    // var purchaseDate = widget.purchase == null
    //     ? null
    //     : new DateFormat('MMM dd, yyyy').format(widget.purchase.purchaseDate);
    List<String> tabs = [
      AppLocalizations.of(context).translate('details'),
      AppLocalizations.of(context).translate('items'),
      AppLocalizations.of(context).translate('paymentHistory'),
      AppLocalizations.of(context).translate('makePayment')
    ];
    return DefaultTabController(
      length: tabs.length,
      child: SizedBox(
        child: Column(children: [
          TabBar(
            isScrollable: true,
            indicator: CircleTabIndicator(
                color: Theme.of(context).accentColor, radius: 3),
            tabs: [
              for (final tab in tabs) Tab(text: tab),
            ],
          ),
          Divider(
            thickness: 2.0,
          ),
          Expanded(
            child: TabBarView(
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
                        subtitle: Text('Supplier'),
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
                      Item item = itemModel
                          .getItemById(widget.purchase.items[index].id);
                      return Card(
                        child: ListTile(
                          leading: ExcludeSemantics(
                            child: CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Text(
                                item?.name?.substring(0, 2)?.toUpperCase(),
                                style: TextStyle(
                                    color: Theme.of(context).accentColor),
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
                                style: TextStyle(
                                    color: Theme.of(context).accentColor),
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
        ]),
      ),
    );
  }
}
