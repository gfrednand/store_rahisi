import 'dart:async';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/providers/index.dart';
import 'package:storeRahisi/widgets/busy_button.dart';
import 'package:path_provider/path_provider.dart';

class TransactionReport extends StatefulWidget {
  TransactionReport({Key key}) : super(key: key);

  @override
  _TransactionReportState createState() => _TransactionReportState();
}

class _TransactionReportState extends State<TransactionReport> {
  DateTime selectedFromDate = DateTime.now();
  DateTime selectedToDate = DateTime.now();
  List<Sale> sales = [];
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
    SaleModel saleModel = Provider.of<SaleModel>(context);

    ClientModel clientModel = Provider.of<ClientModel>(context);
    // PaymentModel paymentModel = Provider.of<PaymentModel>(context);

    ItemModel itemModel = Provider.of<ItemModel>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context).translate('transactions'),
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
                      sales = saleModel.generateReport(
                          selectedFromDate, selectedToDate);
                    });
                  })),
          sales.length > 0
              ? Divider(thickness: 0.2, color: Colors.black)
              : Container(),
          sales.length > 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Amount: ${saleModel.totalSaleAmount}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Total Cost Price: ${saleModel.totalPurchaseAmount}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Profit: ${saleModel.totalSaleAmount - saleModel.totalPurchaseAmount}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: (saleModel.totalSaleAmount -
                                      saleModel.totalPurchaseAmount) >
                                  0
                              ? Colors.green
                              : Colors.redAccent),
                    ),
                    Text(
                      'Total Quantity: ${saleModel.totalQuantity}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                )
              : Container(),
          sales.length > 0
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
                                columnSpacing: 160.0,
                                sortColumnIndex: 4,
                                sortAscending: isSort,
                                columns: [
                                  DataColumn(
                                    label: Text('Reference No'),
                                    numeric: false,
                                  ),
                                  DataColumn(
                                    label: Text('Customer'),
                                    numeric: false,
                                  ),
                                  DataColumn(
                                    label: Text('Products'),
                                    numeric: false,
                                  ),
                                  DataColumn(
                                      label: Text('Total'),
                                      // numeric: true,
                                      onSort: (i, b) {
                                        setState(() {
                                          if (isSort) {
                                            sales.sort((a, b) => b.paidAmount
                                                .compareTo(a.paidAmount));

                                            isSort = false;
                                          } else {
                                            sales.sort((a, b) => a.paidAmount
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
                                            sales.sort((a, b) => b.saleDate
                                                .compareTo(a.saleDate));

                                            isSort = false;
                                          } else {
                                            sales.sort((a, b) => a.saleDate
                                                .compareTo(b.saleDate));

                                            isSort = true;
                                          }
                                        });
                                      }),
                                ],
                                rows: sales.map(
                                  (sale) {
                                    Client client = clientModel
                                        .getClientById(sale.clientId);
                                    sale.companyName = client?.companyName;
                                    var saleDate =
                                        new DateFormat('MMM dd, yyyy')
                                            .format(sale.saleDate);
                                    List<Text> itemNames = [];

                                    sale.paidAmount = 0;
                                    // int quantity = 0;
                                    int count = 1;
                                    sale.items.forEach((item) {
                                      var i = itemModel.getItemById(item.id);
                                      sale.paidAmount =
                                          item.paidAmount + sale.paidAmount;
                                      // quantity = item.quantity + quantity;
                                      itemNames.add(Text(
                                          '$count.${i.name} (${item.quantity} ${i.unit})'));
                                      count++;
                                    });

                                    return DataRow(
                                        // selected: sales.contains(sale),
                                        cells: [
                                          DataCell(
                                            Text(sale.referenceNumber),
                                            onTap: () {
                                              // write your code..
                                            },
                                          ),
                                          DataCell(
                                            Text('${sale.companyName}'),
                                          ),
                                          DataCell(Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: itemNames,
                                          )),
                                          DataCell(
                                            Text('${sale.paidAmount}'),
                                          ),
                                          DataCell(
                                            Text('$saleDate'),
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
          sales.length > 0
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
    filePath = '$path/TransactionReport.csv';
    return File('$path/TransactionReport.csv').create();
  }

  sendMailAndAttachment() async {
    final Email email = Email(
      body:
          'Sale Report From ${DateFormat('MMM dd, yyyy').format(selectedFromDate.toLocal())} To ${DateFormat('MMM dd, yyyy').format(selectedToDate.toLocal())}. <br> A CSV file is attached to this <b>mail</b> <hr><br> Compiled at ${DateTime.now()} <br>  <br><hr>  Store Rahisi',
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
    for (int index = 0; index < sales.length; index++) {
      int count = 1;
      List<String> iNames = [];

      sales[index].items.forEach((item) {
        var i = itemModel.getItemById(item.id);
        sales[index].paidAmount = item.paidAmount + sales[index].paidAmount;
        // quantity = item.quantity + quantity;
        iNames.add('$count.${i.name} (${item.quantity} ${i.unit})');
        count++;
      });
//row refer to each column of a row in csv file and rows refer to each row in a file
      List<dynamic> row = List();
      row.add(sales[index].referenceNumber);
      row.add(sales[index].companyName);
      row.add(iNames.join(','));
      row.add(sales[index].paidAmount);
      row.add(sales[index].saleDate);

      rows.add(row);
    }

// convert rows to String and write as csv file
    File f = await _localFile;
    String csv = const ListToCsvConverter().convert(rows);
    f.writeAsString(csv);
    // filePath = f.uri.path;
  }
}
