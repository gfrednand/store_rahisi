import 'dart:async';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/constants/ui_helpers.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/providers/index.dart';
import 'package:storeRahisi/widgets/busy_button.dart';
import 'package:path_provider/path_provider.dart';

class ItemReport extends StatefulWidget {
  ItemReport({Key key}) : super(key: key);

  @override
  _ItemReportState createState() => _ItemReportState();
}

class _ItemReportState extends State<ItemReport> {
  DateTime selectedFromDate = DateTime.now();
  DateTime selectedToDate = DateTime.now();
  List<Item> items = [];
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

    // PaymentModel paymentModel = Provider.of<PaymentModel>(context);

    ItemModel itemModel = Provider.of<ItemModel>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context).translate('itemReport'),
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
                      items = itemModel.generateReport(
                          selectedFromDate, selectedToDate);
                    });
                  })),
          items.length > 0
              ? Divider(thickness: 0.2, color: Colors.black)
              : Container(),
          items.length > 0
              ? Text(
                  'Total Profit: ${currencyFormat.format(itemModel.totalProfit)}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: itemModel.totalProfit > 0
                          ? Colors.green
                          : Colors.redAccent),
                )
              : Container(),
          items.length > 0
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
                                // columnSpacing: 160.0,
                                sortColumnIndex: 4,
                                sortAscending: isSort,
                                columns: [
                                  DataColumn(
                                    label: Text('Product'),
                                    numeric: false,
                                  ),
                                  DataColumn(
                                    label: Text('Purchase'),
                                    numeric: false,
                                  ),
                                  DataColumn(
                                    label: Text('Sales'),
                                    numeric: false,
                                  ),
                                  DataColumn(
                                      label: Text('Stock'),
                                      // numeric: true,
                                      onSort: (i, b) {
                                        setState(() {
                                          if (isSort) {
                                            items.sort((a, b) =>
                                                b.inStock.compareTo(a.inStock));

                                            isSort = false;
                                          } else {
                                            items.sort((a, b) =>
                                                a.inStock.compareTo(b.inStock));

                                            isSort = true;
                                          }
                                        });
                                      }),
                                  DataColumn(
                                      label: Text('Profit'),
                                      numeric: false,
                                      onSort: (i, b) {
                                        setState(() {
                                          if (isSort) {
                                            items.sort((a, b) =>
                                                b.inStock.compareTo(a.inStock));

                                            isSort = false;
                                          } else {
                                            items.sort((a, b) =>
                                                a.inStock.compareTo(b.inStock));

                                            isSort = true;
                                          }
                                        });
                                      }),
                                ],
                                rows: items.map(
                                  (item) {
                                    return DataRow(
                                        // selected: sales.contains(sale),
                                        cells: [
                                          DataCell(
                                            Text(item.name),
                                            onTap: () {
                                              // write your code..
                                            },
                                          ),
                                          DataCell(
                                            Text('${item.purchaseQuantity}'),
                                          ),
                                          DataCell(
                                            Text('${item.saleQuantity}'),
                                          ),
                                          DataCell(
                                            Text('${item.inStock}'),
                                          ),
                                          DataCell(
                                            Text('${currencyFormat.format(item.profit)}'),
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
          items.length > 0
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
    filePath = '$path/itemReport.csv';
    return File('$path/itemReport.csv').create();
  }

  sendMailAndAttachment() async {
    final Email email = Email(
      body:
          'Item Report From ${DateFormat('MMM dd, yyyy').format(selectedFromDate.toLocal())} To ${DateFormat('MMM dd, yyyy').format(selectedToDate.toLocal())}. <br> A CSV file is attached to this <b>mail</b> <hr><br> Compiled at ${DateTime.now()} <br>  <br> <hr>Store Rahisi',
      subject: 'Item Report for ${DateTime.now().toString()}',
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
      "Product",
      "Purchase",
      "Sales",
      "Stock",
      "Profit",
    ]);
    for (int index = 0; index < items.length; index++) {
//row refer to each column of a row in csv file and rows refer to each row in a file
      List<dynamic> row = List();
      row.add(items[index].name);
      row.add(items[index].purchaseQuantity);
      row.add(items[index].saleQuantity);
      row.add(items[index].inStock);
      row.add(currencyFormat.format(items[index].profit));

      rows.add(row);
    }

// convert rows to String and write as csv file
    File f = await _localFile;
    String csv = const ListToCsvConverter().convert(rows);
    f.writeAsString(csv);
    // filePath = f.uri.path;
  }
}
