import 'package:flutter/material.dart';
import 'package:storeRahisi/constants/ui_helpers.dart';
import 'package:storeRahisi/models/index.dart';

class PurchasePaymentForm extends StatefulWidget {
  final List<Item> items;

  const PurchasePaymentForm({Key key, this.items}) : super(key: key);
  @override
  _PurchasePaymentFormState createState() => _PurchasePaymentFormState();
}

class _PurchasePaymentFormState extends State<PurchasePaymentForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController paidAmountController;
  Item _item;
  @override
  void initState() {
    paidAmountController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                      labelText: 'Select Item',
                    ),
                    isEmpty: widget.items == null,
                    child: new DropdownButtonHideUnderline(
                      child: new DropdownButton(
                        value: _item,
                        isDense: true,
                        onChanged: (Item newValue) {
                          setState(() {
                            _item = newValue;
                            state.didChange(newValue);
                          });
                        },
                        items: widget.items.map((Item value) {
                          return new DropdownMenuItem(
                            value: value,
                            child: new Text(value.name),
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
                  hintText: '0',
                  labelText: 'Paid Price',
                ),
              ),
              verticalSpaceSmall,
              Center(
                child: RaisedButton(
                  onPressed: () {
                    _item.paidAmount = double.parse(paidAmountController.text);
                    _item.id = _item.id ?? '';
                    Navigator.pop(context);
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
