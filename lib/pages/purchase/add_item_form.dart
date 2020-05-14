import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/constants/currency_input_formatter.dart';
import 'package:storeRahisi/constants/ui_helpers.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/providers/purchase_model.dart';

class ItemPurchaseForm extends StatefulWidget {
  final List<Item> items;
  final PurchaseModel purchaseModel;
  final String title;

  ItemPurchaseForm({Key key, this.items, this.purchaseModel, this.title})
      : super(key: key);

  @override
  _ItemPurchaseFormState createState() => _ItemPurchaseFormState();
}

class _ItemPurchaseFormState extends State<ItemPurchaseForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController salePriceController;
  TextEditingController purchasePriceController;
  TextEditingController paidAmountController;
  TextEditingController quantityController;

  Item _item;
  @override
  void initState() {
    salePriceController = new TextEditingController();
    purchasePriceController = new TextEditingController();
    paidAmountController = new TextEditingController();
    quantityController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title, style: Theme.of(context).textTheme.headline6),
      ),
      body: Container(
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
                        labelText: AppLocalizations.of(context)
                            .translate('selectedItem'),
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

                // Container(
                //   padding: EdgeInsets.all(8.0),
                //   width: double.infinity,
                //   child: DropdownButtonHideUnderline(
                //     child: new DropdownButton<Item>(
                //       hint: Text('Select Item'),
                //       value: _item,
                //       items: widget.items.map((Item value) {
                //         return new DropdownMenuItem<Item>(
                //           value: value,
                //           child: new Text(value.name),
                //         );
                //       }).toList(),
                //       onChanged: (value) {
                //         setState(() {
                //           _item = value;
                //         });
                //       },
                //       // style: Theme.of(context).textTheme.headline6,
                //     ),
                //   ),
                // ),
                verticalSpaceSmall,
                _item == null
                    ? Container()
                    : new TextFormField(
                        // textInputAction: TextInputAction.continueAction,
                        keyboardType: TextInputType.numberWithOptions(),
                        controller: purchasePriceController,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          // Fit the validating format.
                          CurrencyInputFormatter()
                        ],
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.attach_money),
                          hintText: '0',
                          labelText: 'Price @1',
                        ),
                      ),
                verticalSpaceSmall,
                _item == null
                    ? Container()
                    : new TextFormField(
                        // textInputAction: TextInputAction.continueAction,
                        // initialValue: purchasePriceController.text??'',
                        keyboardType: TextInputType.numberWithOptions(),
                        controller: paidAmountController,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          // Fit the validating format.
                          CurrencyInputFormatter()
                        ],
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.attach_money),
                          hintText: '0',
                          labelText: 'Paid Price @1',
                        ),
                      ),
                verticalSpaceSmall,
                _item == null
                    ? Container()
                    : new TextFormField(
                        keyboardType: TextInputType.numberWithOptions(),
                        // textInputAction: TextInputAction.continueAction,
                        controller: salePriceController,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          // Fit the validating format.
                          CurrencyInputFormatter()
                        ],
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.attach_money),
                          hintText: '0',
                          labelText: 'Sale Price',
                        ),
                      ),

                verticalSpaceSmall,
                _item == null
                    ? Container()
                    : new TextFormField(
                        // textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.numberWithOptions(),
                        controller: quantityController,
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.confirmation_number),
                          hintText: '',
                          labelText: 'Quantity',
                        ),
                      ),
                verticalSpaceMedium,

                _item == null
                    ? Container()
                    : Center(
                        child: RaisedButton(
                          onPressed: () {
                            _item.purchasePrice = double.tryParse(
                                purchasePriceController.text
                                    .replaceAll(new RegExp(r','), ''));
                            _item.paidAmount = double.tryParse(
                                paidAmountController.text
                                    .replaceAll(new RegExp(r','), ''));
                            _item.salePrice = double.tryParse(
                                salePriceController.text
                                    .replaceAll(new RegExp(r','), ''));
                            _item.quantity = int.tryParse(quantityController
                                .text
                                .replaceAll(new RegExp(r','), ''));
                            _item.userId =
                                widget.purchaseModel.currentUser.id ?? '';
                            widget.purchaseModel.setSelectedItem(_item);
                            Navigator.pop(context);
                          },
                          child: Text(
                              AppLocalizations.of(context).translate('add')),
                        ),
                      ),

                // SizedBox(
                //   width: double.infinity,
                //   child: FlatButton(
                //       child: Text(
                //           AppLocalizations.of(context).translate('cancel')),
                //       onPressed: () {
                //         Navigator.pop(context);
                //       }),
                // ),
                // Padding(
                //     padding: EdgeInsets.only(
                //         bottom: MediaQuery.of(context).viewInsets.bottom)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
