import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/constants/ui_helpers.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/providers/item_model.dart';
import 'package:storeRahisi/providers/payment_model.dart';
import 'package:storeRahisi/widgets/busy_button.dart';

class PurchasePaymentForm extends StatefulWidget {
  final double dueAmount;
  final Purchase purchase;

  const PurchasePaymentForm({Key key, this.dueAmount, this.purchase})
      : super(key: key);
  @override
  _PurchasePaymentFormState createState() => _PurchasePaymentFormState();
}

class _PurchasePaymentFormState extends State<PurchasePaymentForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController paidAmountController;
  TextEditingController descriptionController;
  String _paymentMethod;
  @override
  void initState() {
    paidAmountController =
        new TextEditingController(text: widget.dueAmount.toString());
    descriptionController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PaymentModel paymentModel = Provider.of<PaymentModel>(context);
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FormField(
                builder: (FormFieldState state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      icon: const Icon(Icons.texture),
                      labelText: AppLocalizations.of(context).translate('paymentMethod'),
                    ),
                    child: new DropdownButtonHideUnderline(
                      child: new DropdownButton(
                        value: _paymentMethod,
                        isDense: true,
                        onChanged: (String newValue) {
                          setState(() {
                            _paymentMethod = newValue;
                            state.didChange(newValue);
                          });
                        },
                        items: [AppLocalizations.of(context).translate('cash'), AppLocalizations.of(context).translate('cheque'), AppLocalizations.of(context).translate('others')].map((String value) {
                          return new DropdownMenuItem(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
              verticalSpaceSmall,
              new TextFormField(
                keyboardType: TextInputType.numberWithOptions(),
                controller: paidAmountController,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.attach_money),
                  labelText: 'Paid Price',
                ),
              ),
              verticalSpaceSmall,
              new TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.event_note),
                  labelText: 'Notes',
                ),
              ),
              verticalSpaceSmall,
              Center(
                child: BusyButton(
                  title: AppLocalizations.of(context).translate('submit'),
                  busy: paymentModel.busy,
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      // If the form is valid, display a Snackbar.
                      paymentModel.savePayment(
                          data: Payment(
                        amount: double.parse(paidAmountController.text),
                        method: _paymentMethod,
                        type: 'Debit',
                        note: descriptionController.text,
                        referenceNo: widget.purchase.id,
                        clientId: widget.purchase.id,
                        userId: null,
                      ));
                      _formKey.currentState.reset();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
