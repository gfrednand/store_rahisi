import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/constants/ui_helpers.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/models/item.dart';
import 'package:storeRahisi/providers/index.dart';
import 'package:storeRahisi/widgets/toast.dart';

class ItemDetailWidget extends StatefulWidget {
  final Item item;
  const ItemDetailWidget({Key key, this.item})
      : super(key: key);
  @override
  _ItemDetailWidgetState createState() => _ItemDetailWidgetState();
}

class _ItemDetailWidgetState extends State<ItemDetailWidget> {
  TextEditingController salePriceController;
  int currentSelection = 0;

  void _showToast(String message, Color backGroundColor, IconData icon) {
    Toast.show(
      message: message,
      context: context,
      icon: Icon(icon, color: Colors.white),
      backgroundColor: backGroundColor,
    );
  }



  @override
  Widget build(BuildContext context) {
    List<String> tabs = [
      AppLocalizations.of(context).translate('details'),
      AppLocalizations.of(context).translate('purchaseHistory'),
      AppLocalizations.of(context).translate('salesHistory')
    ];
    PurchaseModel purchaseModel = Provider.of<PurchaseModel>(context);
    List<Purchase> purchases = widget.item == null
        ? []
        : purchaseModel.getPurchaseHistoryByItemId(widget.item.id);
    SaleModel saleModel = Provider.of<SaleModel>(context);
    List<Sale> sales = widget.item == null
        ? []
        : saleModel.getSaleHistoryByItemId(widget.item.id);
    Color color = widget.item == null
        ? Colors.white
        : widget.item.inStock == 0
            ? Colors.red
            : widget.item.inStock!=null && widget.item.inStock > widget.item.alertQty
                ? Colors.green
                : Colors.orange;
    return widget.item == null
        ? Center(
            child: Text('Item Details'),
          )
        : DefaultTabController(
            length: tabs.length,
            child: SizedBox(
                child: Column(children: [
              TabBar(
                isScrollable: false,
                // indicator: CircleTabIndicator(
                //     color: Theme.of(context).accentColor, radius: 3),
                tabs: [
                  for (final tab in tabs) Tab(text: tab),
                ],
              ),
              verticalSpaceTiny,
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Wrap(
                            spacing: 0.0, // gap between adjacent chips
                            runSpacing: 0.0, // gap between lines
                            children: <Widget>[
                              chipDesign(
                                  AppLocalizations.of(context)
                                      .translate('edit'),
                                  Color(0xFF4db6ac)),
                              sales.length == 0 && purchases.length == 0
                                  ? chipDesign("Delete", Color(0xFFf06292))
                                  : Container(),
                            ],
                          ),
                          Divider(
                            thickness: 10.0,
                          ),
                          widget.item.barcode == null ||
                                  widget.item.barcode == ''
                              ? Container()
                              : BarCodeImage(
                                  params: CodabarBarCodeParams(
                                    widget.item.barcode ?? '',
                                  ),
                                ),
                          Text(
                            widget.item.barcode ?? '',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          // LinearProgressIndicator(
                          //     backgroundColor:
                          //         Color.fromRGBO(209, 224, 224, 0.2),
                          //     value: widget.item.inStock / widget.item.alertQty,
                          //     valueColor: AlwaysStoppedAnimation(Colors.green)),
                          ListTile(
                            title: Text(
                              '${widget.item.category}',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            subtitle: Text(
                              AppLocalizations.of(context)
                                  .translate('category'),
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                          ),
                          Divider(
                            thickness: 10.0,
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.add_to_queue,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            title: Text(
                              '${widget.item.openingStock} ${widget.item.unit}',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            subtitle: Text(
                              AppLocalizations.of(context)
                                  .translate('openingStock'),
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.add_to_queue,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            title: Text(
                              '${widget.item.totalPurchase ?? 0} ${widget.item.unit}',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            subtitle: Text(
                              AppLocalizations.of(context)
                                  .translate('totalPurchase'),
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.remove_from_queue,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            title: Text(
                              '${widget.item.totalSales ?? 0} ${widget.item.unit}',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            subtitle: Text(
                              AppLocalizations.of(context)
                                  .translate('totalSales'),
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.inbox,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            title: Text(
                              '${widget.item.inStock ?? 0}  ${widget.item.unit}',
                              style: TextStyle(
                                  color: color, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              AppLocalizations.of(context).translate('inStock'),
                              style: TextStyle(
                                  color: color, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Divider(
                            thickness: 10.0,
                          ),
                          ListTile(
                            title: Text(
                              '${widget.item.alertQty} ${widget.item.unit}',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            subtitle: Text(
                              AppLocalizations.of(context)
                                  .translate('alertQuantity'),
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                          ),
                          Divider(
                            thickness: 10.0,
                          ),
                          widget.item.description == null ||
                                  widget.item.description == ''
                              ? Container()
                              : ListTile(
                                  title: Text(
                                    '${widget.item.description}',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  subtitle: Text(
                                    AppLocalizations.of(context)
                                        .translate('description'),
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                  ),
                                ),
                        ],
                      ),
                    ),
                    purchases.length == 0
                        ? Center(
                            child: Text(AppLocalizations.of(context)
                                .translate('noPurchase')),
                          )
                        : ListView.builder(
                            itemCount: purchases.length,
                            itemBuilder: (buildContext, index) {
                              ClientModel clientModel =
                                  Provider.of<ClientModel>(context);
                              purchases[index].companyName = clientModel
                                  .getClientById(purchases[index].clientId)
                                  ?.companyName;

                              PaymentModel paymentModel =
                                  Provider.of<PaymentModel>(context);
                              List<Payment> payments =
                                  paymentModel.getPaymentsByReferenceNo(
                                      purchases[index].id);
                              purchases[index].paidAmount = 0.0;
                              payments.forEach((payment) {
                                purchases[index].paidAmount =
                                    purchases[index].paidAmount +
                                        payment.amount;
                              });
                              return Column(
                                children: [
                                  Divider(
                                    height: 5.0,
                                  ),
                                  ListTile(
                                    leading: ExcludeSemantics(
                                      child: CircleAvatar(
                                        radius: 25.0,
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        child: Text(
                                          'P',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      '${purchases[index]?.purchaseDate}',
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)
                                                  .translate('billNo') +
                                              ': ${purchases[index]?.referenceNumber}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          AppLocalizations.of(context)
                                                  .translate('supplier') +
                                              ': ${purchases[index]?.companyName}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          AppLocalizations.of(context)
                                                  .translate('paid') +
                                              ': ${currencyFormat.format(purchases[index]?.paidAmount)}/=',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    trailing: Text(
                                        '${currencyFormat.format(purchases[index]?.grandTotalAmount)}/='),
                                    onTap: () {
                                      // var arguments = {
                                      //   'purchase': purchases[index],
                                      //   'purchaseModel': purchaseModel,
                                      // };
                                      // Navigator.pushNamed(context, AppRoutes.purchase_detail,
                                      //     arguments: arguments);
                                    },
                                  ),
                                ],
                              );
                            }),
                    sales.length == 0
                        ? Center(
                            child: Text(AppLocalizations.of(context)
                                .translate('noSales')),
                          )
                        : ListView.builder(
                            itemCount: sales.length,
                            itemBuilder: (buildContext, index) {
                              return Column(
                                children: [
                                  Divider(
                                    height: 5.0,
                                  ),
                                  ListTile(
                                    leading: ExcludeSemantics(
                                      child: CircleAvatar(
                                        radius: 25.0,
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        child: Text(
                                          'S',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      '${sales[index]?.saleDate}',
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)
                                                  .translate('refNo') +
                                              ': ${sales[index]?.referenceNumber}',
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2,
                                        ),
                                        Text(
                                          AppLocalizations.of(context)
                                                  .translate('paid') +
                                              ' ${currencyFormat.format(sales[index]?.grandTotal)}/=',
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2,
                                        ),
                                      ],
                                    ),
                                    trailing:
                                        Text('${sales[index]?.paymentMethod}'),
                                    onTap: () {
                                      // var arguments = {
                                      //   'purchase': purchases[index],
                                      //   'purchaseModel': purchaseModel,
                                      // };
                                      // Navigator.pushNamed(context, AppRoutes.purchase_detail,
                                      //     arguments: arguments);
                                    },
                                  ),
                                ],
                              );
                            }),
                  ],
                ),
              ),
            ])));
  }

  Widget chipDesign(String label, Color color) {
    ItemModel itemModel = Provider.of<ItemModel>(context);
    return GestureDetector(
      onTap: () {
        label == AppLocalizations.of(context).translate('delete')
            ? itemModel.removeItem(widget.item.id)
            : label == AppLocalizations.of(context).translate('edit')
                ? Navigator.pushNamed(context, AppRoutes.item_form, arguments: {
                    'title': AppLocalizations.of(context).translate('editItem'),
                    'item': widget.item
                  })
                : _showToast(
                    label + AppLocalizations.of(context).translate('selected'),
                    color,
                    Icons.error_outline);
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
