import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/constants/ui_helpers.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/providers/index.dart';
import 'package:storeRahisi/widgets/busy_button.dart';
import 'package:storeRahisi/widgets/input_field.dart';
import '../base_view.dart';

class ExpenseForm extends StatefulWidget {
  final Expense expense;
  final String title;

  ExpenseForm({
    Key key,
    this.expense,
    this.title,
  }) : super(key: key);

  @override
  _ExpenseFormState createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final responsiblePersonController = new TextEditingController();

  final descriptionController = new TextEditingController();

  final amountPriceController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var isEditing = widget.expense != null;

    // Build a Form widget using the _formKey created above.
    return BaseView<ExpenseModel>(
      onModelReady: (model) {
        // update the text in the controller
        if (isEditing) {
          responsiblePersonController.text =
              widget.expense?.responsiblePerson ?? '';
          descriptionController.text = widget.expense?.description ?? '';
          amountPriceController.text = widget.expense?.amount.toString() ?? '0';
          model.setEdittingExpense(widget.expense);
        }
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title:
              Text(widget.title, style: Theme.of(context).textTheme.headline6),
          // actions: <Widget>[
          //   new IconButton(icon: const Icon(Icons.save), onPressed: () {})
          // ],
        ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InputField(
                    smallVersion: true,
                    isReadOnly: model.busy,
                    placeholder: AppLocalizations.of(context)
                            .translate('responsiblePerson') +
                        '*',
                    controller: responsiblePersonController,
                  ),
                  verticalSpaceSmall,

                  InputField(
                    smallVersion: true,
                    isReadOnly: model.busy,
                    placeholder:
                        AppLocalizations.of(context).translate('amount'),
                    controller: amountPriceController,
                    textInputType: TextInputType.numberWithOptions(),
                  ),
                  verticalSpaceSmall,

                  InputField(
                    smallVersion: true,
                    isReadOnly: model.busy,
                    placeholder:
                        AppLocalizations.of(context).translate('description'),
                    controller: descriptionController,
                  ),
                  verticalSpaceSmall,

                  Center(
                    child: BusyButton(
                      title: AppLocalizations.of(context).translate('submit'),
                      busy: model.busy,
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          // If the form is valid, display a Snackbar.
                          model.saveExpense(
                              data: Expense(
                            id: widget.expense?.id ?? '',
                            description: descriptionController.text,
                            responsiblePerson: responsiblePersonController.text,
                            amount: double.parse(amountPriceController.text),
                            userId: null,
                          ));
                          _formKey.currentState.reset();
                        }
                      },
                    ),
                  ),

                  SizedBox(
                    width: double.infinity,
                    child: FlatButton(
                        child: Text(
                          AppLocalizations.of(context).translate('cancel'),
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ),
                  // Padding(
                  //     padding: EdgeInsets.only(
                  //         bottom: MediaQuery.of(context).viewInsets.bottom)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
