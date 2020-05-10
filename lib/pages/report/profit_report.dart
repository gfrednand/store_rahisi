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

class ProfitReport extends StatefulWidget {
  ProfitReport({Key key}) : super(key: key);

  @override
  _ProfitReportState createState() => _ProfitReportState();
}

class _ProfitReportState extends State<ProfitReport> {
  DateTime selectedFromDate = DateTime.now();
  DateTime selectedToDate = DateTime.now();
  List<Item> items = [];
  Map<String, dynamic> data;
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

    // ClientModel clientModel = Provider.of<ClientModel>(context);
    // PaymentModel paymentModel = Provider.of<PaymentModel>(context);

    ItemModel itemModel = Provider.of<ItemModel>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context).translate('profitReport'),
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
                      data = saleModel.getTotalSales(
                          selectedFromDate, selectedToDate);
                    });
                  })),
          data != null
              ? Divider(thickness: 0.2, color: Colors.black)
              : Container(),
          data != null
              ? Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                          child: Table(
                        defaultColumnWidth: FixedColumnWidth(
                            MediaQuery.of(context).size.width / 2.2),
                        border: TableBorder.all(width: 1),
                        children: [
                          TableRow(children: [
                            TableCell(
                                child: Text('Total Sales',
                                    textAlign: TextAlign.center)),
                            TableCell(
                              child: Center(
                                  child: Text(data['totalSales']?.toString()?.replaceAllMapped(reg, mathFunc))),
                            ),
                          ]),
                          TableRow(children: [
                            TableCell(
                                child: Text('Cost of Sales',
                                    textAlign: TextAlign.center)),
                            TableCell(
                              child: Center(
                                  child: Text(data['costOfSales']?.toString()?.replaceAllMapped(reg, mathFunc))),
                            ),
                          ]),
                          TableRow(children: [
                            TableCell(
                                child: Text('Gross Profit/Loss',
                                    textAlign: TextAlign.center)),
                            TableCell(
                              child: Center(
                                  child: Text(data['grossProfit']?.toString()?.replaceAllMapped(reg, mathFunc))),
                            ),
                          ]),
                          TableRow(children: [
                            TableCell(
                                child: Text('Total Expense',
                                    textAlign: TextAlign.center)),
                            TableCell(
                              child: Center(
                                  child: Text(
                                      '(-)${data['totalExpenses']?.toString()?.replaceAllMapped(reg, mathFunc)}')),
                            ),
                          ]),
                          TableRow(children: [
                            TableCell(
                                child: Text('Net Profit/Loss Before Tax',
                                    textAlign: TextAlign.center)),
                            TableCell(
                              child: Center(child: Text('0')),
                            ),
                          ]),
                          TableRow(children: [
                            TableCell(
                                child: Text('Total Tax',
                                    textAlign: TextAlign.center)),
                            TableCell(
                              child: Center(child: Text('(-)0')),
                            ),
                          ]),
                          TableRow(children: [
                            TableCell(
                              child: Text(
                                'Net Profit/ Loss After Tax',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            TableCell(
                              child: Center(
                                child: Text(
                                  '0',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ]),
                        ],
                      ))
                    ],
                  ),
                )
              : Container(),
          data != null
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
    filePath = '$path/profitReport.csv';
    return File('$path/profitReport.csv').create();
  }

  sendMailAndAttachment() async {
    final Email email = Email(
      body:
          'Profit Report From ${DateFormat('MMM dd, yyyy').format(selectedFromDate.toLocal())} To ${DateFormat('MMM dd, yyyy').format(selectedToDate.toLocal())}. <br> A CSV file is attached to this <b>mail</b> <hr><br> Compiled at ${DateTime.now()} <br>  <br> <hr>Store Rahisi',
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
      "From " + DateFormat('MMM dd, yyyy').format(selectedFromDate.toLocal()),
      "To " + DateFormat('MMM dd, yyyy').format(selectedToDate.toLocal()),
    ]);
    rows.add([
      "Total Sales",
      0,
    ]);
    rows.add([
      "Cost of Sales",
      0,
    ]);
    rows.add([
      "Gross Of Profit/ Loss",
      0,
    ]);
    rows.add([
      "Total Expense",
      -0,
    ]);
    rows.add([
      "Net Profit/Loss Before Tax",
      0,
    ]);
    rows.add([
      "Total Tax",
      -0,
    ]);
    rows.add([
      "Net Profit/Loss After Tax",
      0,
    ]);

// convert rows to String and write as csv file
    File f = await _localFile;
    String csv = const ListToCsvConverter().convert(rows);
    f.writeAsString(csv);
    // filePath = f.uri.path;
  }
}
