import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/pages/purchase/payment_form.dart';
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

class _PurchaseDetailWidgetState extends State<PurchaseDetailWidget>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int currentSelection = 0;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
  }

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

  Widget buildTabContainer(BuildContext context) {
    PaymentModel paymentModel = Provider.of<PaymentModel>(context);
    List<Payment> payments = widget.purchase == null
        ? []
        : paymentModel
            .getPaymentsByReferenceNo(widget.purchase.referenceNumber);

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
    return SizedBox(
      child: Column(children: [
        TabBar(
          controller: _tabController,
          isScrollable: true,

          // indicator: CircleTabIndicator(
          //     color: Theme.of(context).accentColor, radius: 3),
          tabs: [
            for (final tab in tabs) Tab(text: tab),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
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
                      title: Text(
                        '${widget.purchase.companyName}',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      subtitle: Text(
                        'Supplier',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                    ListTile(
                      title: Text(
                        '${widget.purchase.referenceNumber}',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      subtitle: Text(
                        'Bill No',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                    Divider(
                      thickness: 10.0,
                    ),
                    ListTile(
                      title: Text(
                        '${widget.purchase.grandTotalAmount}',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      subtitle: Text(
                        'Grand Total',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                    ListTile(
                      title: Text(
                        '${widget.purchase.paidAmount}',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      subtitle: Text(
                        'Paid Amount',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                    ListTile(
                      title: Text(
                        '$dueAmount',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      subtitle: Text(
                        'Due Amount',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
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
                    return Column(
                      children: [
                        Divider(
                          height: 5.0,
                        ),
                        ListTile(
                          leading: ExcludeSemantics(
                            child: CircleAvatar(
                              radius: 25.0,
                              backgroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              child: Text(
                                item?.name?.substring(0, 2)?.toUpperCase(),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            '${item?.name}',
                            style: Theme.of(context).textTheme.headline6,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Purchase Price: ${widget.purchase.items[index].purchasePrice} @1',
                                style: Theme.of(context).textTheme.subtitle2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Sale Price: ${widget.purchase.items[index].salePrice} @1',
                                style: Theme.of(context).textTheme.subtitle2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          trailing: Text(
                              '${widget.purchase.items[index].quantity}',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          onTap: () {
                            // Navigator.pushNamed(
                            //     context, AppRoutes.purchase_detail,
                            //     arguments: items[index]);
                          },
                        ),
                      ],
                    );
                  }),
              ListView.builder(
                  itemCount: payments.length,
                  itemBuilder: (buildContext, index) {
                    ClientModel clientModel = Provider.of<ClientModel>(context);
                    Client client =
                        clientModel.getClientById(payments[index].clientId);
                    return Column(
                      children: [
                        Divider(
                          height: 5.0,
                        ),
                        ListTile(
                          leading: ExcludeSemantics(
                            child: CircleAvatar(
                              radius: 25.0,
                              backgroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              child: Text(
                                'P',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            '${payments[index]?.method} | ${payments[index]?.type}',
                            style: Theme.of(context).textTheme.headline6,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Text(
                            ' ${payments[index]?.amount} /=',
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                          onTap: () {
                            // Navigator.pushNamed(
                            //     context, AppRoutes.purchase_detail,
                            //     arguments: items[index]);
                          },
                        ),
                      ],
                    );
                  }),
              dueAmount > 0
                  ? PaymentForm(
                      dueAmount: dueAmount,
                      referenceNo: widget.purchase.referenceNumber,
                      clientId: widget.purchase.clientId,
                      tabController: _tabController,
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
    );
  }
}
