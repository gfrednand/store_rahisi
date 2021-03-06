import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/constants/ui_helpers.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/providers/index.dart';
import 'package:storeRahisi/widgets/toast.dart';

class ExpenseDetail extends StatefulWidget {
  final Expense expense;
  final ExpenseModel expenseModel;
  const ExpenseDetail({Key key, this.expense, this.expenseModel})
      : super(key: key);
  @override
  _ExpenseDetailState createState() => _ExpenseDetailState();
}

class _ExpenseDetailState extends State<ExpenseDetail> {
  TextEditingController salePriceController;

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
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: widget.expense.responsiblePerson == null
              ? Text(AppLocalizations.of(context).translate('expenseDetails'),
                  style: Theme.of(context).textTheme.headline6)
              : Text('${widget.expense.responsiblePerson?.toUpperCase()}',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline6),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Wrap(
                spacing: 0.0, // gap between adjacent chips
                runSpacing: 0.0, // gap between lines
                children: <Widget>[
                  chipDesign(AppLocalizations.of(context).translate('edit'),
                      Color(0xFF4db6ac)),
                  chipDesign("Delete", Color(0xFFf06292))
                ],
              ),
              Divider(
                thickness: 10.0,
              ),
              ListTile(
                title: Text(
                  '${currencyFormat.format(widget.expense.amount)}',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                subtitle: Text(
                  AppLocalizations.of(context).translate('amount'),
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
              Divider(
                thickness: 10.0,
              ),
              ListTile(
                leading: Icon(Icons.art_track),
                title: Text(
                  '${widget.expense.description}',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                subtitle: Text(
                  AppLocalizations.of(context).translate('description'),
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
              ListTile(
                leading: Icon(Icons.date_range),
                title: Text(
                  '${DateFormat('MMM dd, yyyy').format(widget.expense.date)}',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                subtitle: Text(
                  AppLocalizations.of(context).translate('date'),
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
              Divider(
                thickness: 10.0,
              ),
            ],
          ),
        ));
  }

  Widget chipDesign(String label, Color color) {
    return GestureDetector(
      onTap: () {
        label == AppLocalizations.of(context).translate('delete')
            ? widget.expenseModel.removeExpense(widget.expense.id)
            : label == AppLocalizations.of(context).translate('edit')
                ? Navigator.pushNamed(
                    context, AppRoutes.expense_form, arguments: {
                    'title':
                        AppLocalizations.of(context).translate('addExpense'),
                    'expense': widget.expense,
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
