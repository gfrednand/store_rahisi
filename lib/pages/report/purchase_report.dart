import 'dart:async';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/constants/ui_helpers.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/providers/index.dart';
import 'package:storeRahisi/widgets/busy_button.dart';

class PurchaseReport extends StatefulWidget {
  PurchaseReport({Key key}) : super(key: key);

  @override
  _PurchaseReportState createState() => _PurchaseReportState();
}

class _PurchaseReportState extends State<PurchaseReport> {
  DateTime selectedFromDate = DateTime.now();
  DateTime selectedToDate = DateTime.now();
  List<Purchase> purchases = [];
  String filePath;
  bool isSort = true;
  Future<Null> _selectFromDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedFromDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2501));
    if (picked != null && picked != selectedFromDate)
      setState(() {
        selectedFromDate = picked;
      });
  }

  Future<Null> _selectToDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedToDate,
        firstDate: selectedFromDate,
        lastDate: DateTime(2501));
    if (picked != null && picked != selectedToDate)
      setState(() {
        selectedToDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    PurchaseModel purchaseModel = Provider.of<PurchaseModel>(context);

    ClientModel clientModel = Provider.of<ClientModel>(context);
    // PaymentModel paymentModel = Provider.of<PaymentModel>(context);

    ItemModel itemModel = Provider.of<ItemModel>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context).translate('purchaseReport'),
            style: Theme.of(context).textTheme.headline6),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10.0),
            width: screenSize.width,
            child: Card(
              elevation: 15.0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton.icon(
                      icon: Icon(
                        Icons.date_range,
                        size: 18.0,
                         color: Theme.of(context).iconTheme.color,
                      ),
                      onPressed: () => _selectFromDate(context),
                      label: Text(
                          'From : ' +
                              '${DateFormat('MMM dd, yyyy').format(selectedFromDate.toLocal())}',
                          style:
                              TextStyle( color: Theme.of(context).iconTheme.color)),
                    ),
                    Container(
                      color: Theme.of(context).primaryColor,
                      width: 2.0,
                      height: 24.0,
                    ),
                    FlatButton.icon(
                      icon: Icon(
                        Icons.date_range,
                        size: 18.0,
                         color: Theme.of(context).iconTheme.color,
                      ),
                      onPressed: () => _selectToDate(context),
                      label: Text(
                          'To : ' +
                              '${DateFormat('MMM dd, yyyy').format(selectedToDate.toLocal())}',
                          style:
                              TextStyle( color: Theme.of(context).iconTheme.color)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
              width: screenSize.width,
              child: BusyButton(
                  title: 'Generate',
                  onPressed: () {
                    setState(() {
                      purchases = purchaseModel.generateReport(
                          selectedFromDate, selectedToDate);
                    });
                  })),
          purchases.length > 0
              ? Divider(thickness: 0.2, color: Colors.black)
              : Container(),
          purchases.length > 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Amount: ${currencyFormat.format(purchaseModel.totalPurchaseAmount)}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Total Quantity: ${purchaseModel.totalQuantity}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                )
              : Container(),
          purchases.length > 0
              ? Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              DataTable(
                                sortColumnIndex: 4,
                                sortAscending: isSort,
                                columns: [
                                  DataColumn(
                                    label: Text('Reference No'),
                                    numeric: false,
                                  ),
                                  DataColumn(
                                    label: Text('Supplier'),
                                    numeric: false,
                                  ),
                                  DataColumn(
                                    label: Text('Products'),
                                    numeric: false,
                                  ),
                                  DataColumn(
                                      label: Text('Total'),
                                      numeric: true,
                                      onSort: (i, b) {
                                        setState(() {
                                          if (isSort) {
                                            purchases.sort((a, b) => b
                                                .paidAmount
                                                .compareTo(a.paidAmount));

                                            isSort = false;
                                          } else {
                                            purchases.sort((a, b) => a
                                                .paidAmount
                                                .compareTo(b.paidAmount));

                                            isSort = true;
                                          }
                                        });
                                      }),
                                  DataColumn(
                                      label: Text('Date'),
                                      numeric: false,
                                      onSort: (i, b) {
                                        setState(() {
                                          if (isSort) {
                                            purchases.sort((a, b) => b
                                                .purchaseDate
                                                .compareTo(a.purchaseDate));

                                            isSort = false;
                                          } else {
                                            purchases.sort((a, b) => a
                                                .purchaseDate
                                                .compareTo(b.purchaseDate));

                                            isSort = true;
                                          }
                                        });
                                      }),
                                ],
                                rows: purchases.map(
                                  (purchase) {
                                    Client client = clientModel
                                        .getClientById(purchase.clientId);
                                    purchase.companyName = client?.companyName;
                                    var purchaseDate =
                                        new DateFormat('MMM dd, yyyy')
                                            .format(purchase.purchaseDate);
                                    List<Widget> itemNames = [];
                                    purchase.paidAmount = 0;
                                    // int quantity = 0;
                                    int count = 1;
                                    purchase.items.forEach((item) {
                                      var i = itemModel.getItemById(item.id);
                                      purchase.paidAmount =
                                          item.paidAmount + purchase.paidAmount;
                                      // quantity = item.quantity + quantity;
                                      itemNames.add(Expanded(
                                        child: Text(
                                            '$count.${i.name} (${item.quantity} ${i.unit})'),
                                      ));
                                      count++;
                                    });

                                    return DataRow(
                                        // selected: purchases.contains(purchase),
                                        cells: [
                                          DataCell(
                                            Text(purchase.referenceNumber),
                                            onTap: () {
                                              // write your code..
                                            },
                                          ),
                                          DataCell(
                                            Text('${purchase.companyName}'),
                                          ),
                                          DataCell(Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: itemNames,
                                          )),
                                          DataCell(
                                            Text('${currencyFormat.format(purchase.paidAmount)}'),
                                          ),
                                          DataCell(
                                            Text('$purchaseDate'),
                                          ),
                                        ]);
                                  },
                                ).toList(),
                              ),
                            ]),
                      )
                    ],
                  ),
                )
              : Container(),
          purchases.length > 0
              ? RaisedButton(
                  child: Text('Send'),
                  onPressed: () async {
                    String platformResponse;

                    try {
                      await getCsv(itemModel).then((v) {
                        sendMailAndAttachment().whenComplete(() {
                          // setState(() {
                          //   isProcessing = false;
                          // });
                        });
                      });

                      platformResponse = 'success';
                    } catch (error) {
                      platformResponse = error.toString();
                    }
                    print(platformResponse);
                  })
              : Container()
        ],
      ),
    );
  }

  Future<String> get _localPath async {
    final directory = await getApplicationSupportDirectory();

    return directory.absolute.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    filePath = '$path/saleReport.csv';
    return File('$path/saleReport.csv').create();
  }

  sendMailAndAttachment() async {
    final Email email = Email(
      body:
          'Purchase Report From ${DateFormat('MMM dd, yyyy').format(selectedFromDate.toLocal())} To ${DateFormat('MMM dd, yyyy').format(selectedToDate.toLocal())}. <br> A CSV file is attached to this <b>mail</b> <hr><br> Compiled at ${DateTime.now()} <br>  <br> <hr> Store Rahisi',
      subject: 'Purchase Report for ${DateTime.now().toString()}',
      recipients: ['gfrednand@gmail.com'],
      isHTML: true,
      attachmentPaths: [filePath],
    );

    await FlutterEmailSender.send(email);
  }

  getCsv(ItemModel itemModel) async {
    //create an element rows of type list of list. All the above data set are stored in associate list
//Let associate be a model class with attributes name,gender and age and associateList be a list of associate model class.

    List<List<dynamic>> rows = List<List<dynamic>>();
    rows.add([
      "From",
      DateFormat('MMM dd, yyyy').format(selectedFromDate.toLocal()),
      "To",
      DateFormat('MMM dd, yyyy').format(selectedToDate.toLocal()),
      "",
    ]);
    rows.add([
      "Reference Number",
      "Supplier",
      "Products",
      "Total",
      "Date",
    ]);
    for (int index = 0; index < purchases.length; index++) {
      int count = 1;
      List<String> iNames = [];

      purchases[index].items.forEach((item) {
        var i = itemModel.getItemById(item.id);
        purchases[index].paidAmount =
            item.paidAmount + purchases[index].paidAmount;
        // quantity = item.quantity + quantity;
        iNames.add('$count.${i.name} (${item.quantity} ${i.unit})');
        count++;
      });
//row refer to each column of a row in csv file and rows refer to each row in a file
      List<dynamic> row = List();
      row.add(purchases[index].referenceNumber);
      row.add(purchases[index].companyName);
      row.add(iNames.join(','));
      row.add(currencyFormat.format(purchases[index].paidAmount));
      row.add(purchases[index].purchaseDate);

      rows.add(row);
    }

// convert rows to String and write as csv file
    File f = await _localFile;
    String csv = const ListToCsvConverter().convert(rows);
    f.writeAsString(csv);
    // filePath = f.uri.path;
  }
}
