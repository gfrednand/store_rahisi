import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/models/item.dart';
import 'package:storeRahisi/pages/item/item_form.dart';
import 'package:storeRahisi/providers/index.dart';
import 'package:storeRahisi/widgets/custom_modal_sheet.dart';
import 'package:storeRahisi/widgets/toast.dart';

class ItemDetail extends StatefulWidget {
  final Item item;
  final ItemModel itemModel;
  const ItemDetail({Key key, this.item, this.itemModel}) : super(key: key);
  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
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
    List<String> tabs = ['Details', 'Purchase History', 'Sales History'];
    PurchaseModel purchaseModel = Provider.of<PurchaseModel>(context);
    List<Purchase> purchases =
        purchaseModel.getPurchaseHistoryByItemId(widget.item.id);
    SaleModel saleModel = Provider.of<SaleModel>(context);
    List<Sale> sales = saleModel.getSaleHistoryByItemId(widget.item.id);
    Color color = widget.item.inStock == 0
        ? Colors.red
        : widget.item.inStock > widget.item.alertQty
            ? Colors.green
            : Colors.orange;
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: widget.item.name == null
              ? Text('Item Detail')
              : Text(
                  '${widget.item.name.toUpperCase()}',
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
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Wrap(
                    spacing: 0.0, // gap between adjacent chips
                    runSpacing: 0.0, // gap between lines
                    children: <Widget>[
                      chipDesign("Print Barcode", Color(0xFF9575cd)),
                      chipDesign("Edit", Color(0xFF4db6ac)),
                      sales.length == 0 && purchases.length == 0
                          ? chipDesign("Delete", Color(0xFFf06292))
                          : Container(),
                    ],
                  ),
                  Divider(
                    thickness: 10.0,
                  ),
                  widget.item.barcode == null
                      ? Container()
                      : BarCodeImage(
                          params: CodabarBarCodeParams(
                            widget.item.barcode ?? '',
                          ),
                        ),
                  Text(widget.item.barcode ?? ''),
                  ListTile(
                    title: Text('${widget.item.category}'),
                    subtitle: Text('Category'),
                  ),
                  Divider(
                    thickness: 10.0,
                  ),
                  ListTile(
                    leading: Icon(Icons.add_to_queue),
                    title:
                        Text('${widget.item.openingStock} ${widget.item.unit}'),
                    subtitle: Text('Opening Stock'),
                  ),
                  ListTile(
                    leading: Icon(Icons.add_to_queue),
                    title: Text(
                        '${widget.item.totalPurchase ?? 0} ${widget.item.unit}'),
                    subtitle: Text('Total Purchase'),
                  ),
                  ListTile(
                    leading: Icon(Icons.remove_from_queue),
                    title: Text(
                        '${widget.item.totalSales ?? 0} ${widget.item.unit}'),
                    subtitle: Text('Total Sales'),
                  ),
                  ListTile(
                    leading: Icon(Icons.inbox),
                    title: Text(
                      '${widget.item.inStock ?? 0}  ${widget.item.unit}',
                      style:
                          TextStyle(color: color, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('In Stock',
                        style: TextStyle(
                            color: color, fontWeight: FontWeight.bold)),
                  ),
                  Divider(
                    thickness: 10.0,
                  ),
                  ListTile(
                    title: Text('${widget.item.alertQty} ${widget.item.unit}'),
                    subtitle: Text('Alert Quantity'),
                  ),
                  Divider(
                    thickness: 10.0,
                  ),
                  ListTile(
                    title: Text('${widget.item.description}'),
                    subtitle: Text('Description'),
                  ),
                  Divider(
                    thickness: 10.0,
                  ),
                ],
              ),
            ),
            purchases.length == 0
                ? Center(
                    child: Text('No Purchases'),
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
                      List<Payment> payments = paymentModel
                          .getPaymentsByPurchaseId(purchases[index].id);
                      purchases[index].paidAmount = 0.0;
                      payments.forEach((payment) {
                        purchases[index].paidAmount =
                            purchases[index].paidAmount + payment.amount;
                      });
                      return Card(
                        child: ListTile(
                          leading: ExcludeSemantics(
                            child: CircleAvatar(
                              radius: 25.0,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Text(
                                'P',
                                style: TextStyle(
                                    color: Theme.of(context).accentColor),
                              ),
                            ),
                          ),
                          title: Text(
                            '${purchases[index]?.purchaseDate}',
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bill No: ${purchases[index]?.referenceNumber}',
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Client: ${purchases[index]?.companyName}',
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Paid: ${purchases[index]?.paidAmount}/=',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          trailing:
                              Text('${purchases[index]?.grandTotalAmount}/='),
                          onTap: () {
                            // var arguments = {
                            //   'purchase': purchases[index],
                            //   'purchaseModel': purchaseModel,
                            // };
                            // Navigator.pushNamed(context, AppRoutes.purchase_detail,
                            //     arguments: arguments);
                          },
                        ),
                      );
                    }),
            sales.length == 0
                ? Center(
                    child: Text('No Sales'),
                  )
                : ListView.builder(
                    itemCount: sales.length,
                    itemBuilder: (buildContext, index) {
                      return Card(
                        child: ListTile(
                          leading: ExcludeSemantics(
                            child: CircleAvatar(
                              radius: 25.0,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Text(
                                'S',
                                style: TextStyle(
                                    color: Theme.of(context).accentColor),
                              ),
                            ),
                          ),
                          title: Text(
                            '${sales[index]?.saleDate}',
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ref No: ${sales[index]?.referenceNumber}',
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Paid ${sales[index]?.grandTotal}/=',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          trailing: Text('${sales[index]?.paymentMethod}'),
                          onTap: () {
                            // var arguments = {
                            //   'purchase': purchases[index],
                            //   'purchaseModel': purchaseModel,
                            // };
                            // Navigator.pushNamed(context, AppRoutes.purchase_detail,
                            //     arguments: arguments);
                          },
                        ),
                      );
                    }),
          ],
        ),
      ),
    );
  }

  Widget chipDesign(String label, Color color) {
    return GestureDetector(
      onTap: () {
        label == 'Delete'
            ? widget.itemModel.removeItem(widget.item.id)
            : label == 'Edit'
                ? _showModalSheetAppBar(
                    context,
                    'Edit Product',
                    ItemForm(
                      item: widget.item,
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
