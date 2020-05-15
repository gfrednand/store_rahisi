import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/constants/ui_helpers.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/providers/item_model.dart';
import 'package:storeRahisi/widgets/busy_button.dart';
import 'package:storeRahisi/widgets/dropdown_formfield.dart';
import 'package:provider/provider.dart';
import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:storeRahisi/widgets/toast.dart';
import '../base_view.dart';

class ItemForm extends StatefulWidget {
  final Item item;
  final String title;

  ItemForm({
    Key key,
    this.item,
    this.title,
  }) : super(key: key);

  @override
  _ItemFormState createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  Category selectedCategory;

  final nameController = new TextEditingController();

  final descriptionController = new TextEditingController();

  final salePriceController = new TextEditingController();

  final purchasePriceController = new TextEditingController();

  final alertQtyController = new TextEditingController();

  final openingStockController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String barcode = "";
  String requiredValidator(String value) {
    if (value.isEmpty) {
      return 'Required';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var isEditing = widget.item != null;
    List<Category> categories =
        context.select((ItemModel itemModel) => itemModel.categories);
    // Build a Form widget using the _formKey created above.
    return BaseView<ItemModel>(
      onModelReady: (model) {
       
        // update the text in the controller
        if (isEditing) {
          nameController.text = widget.item?.name ?? '';
          descriptionController.text = widget.item?.description ?? '';
          salePriceController.text = widget.item?.salePrice.toString() ?? '0';
          purchasePriceController.text =
              widget.item?.purchasePrice.toString() ?? '0';
          alertQtyController.text = widget.item?.alertQty.toString() ?? '0';
          openingStockController.text =
              widget.item?.openingStock.toString() ?? '0';
          model.setEdittingItem(widget.item);
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
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new ListTile(
                      leading: const Icon(Icons.account_balance_wallet),
                      title: new TextFormField(
                        controller: nameController,
                        validator: requiredValidator,
                        decoration: new InputDecoration(
                          labelText: "Name",
                        ),
                      ),
                    ),
                    verticalSpaceSmall,
                    new ListTile(
                      leading: const Icon(Icons.account_balance_wallet),
                      title: new TextFormField(
                        keyboardType: TextInputType.numberWithOptions(),
                        controller: openingStockController,
                        validator: requiredValidator,
                        decoration: new InputDecoration(
                          labelText: "Opening Stock",
                        ),
                      ),
                    ),
                    verticalSpaceSmall,
                    new ListTile(
                      leading: const Icon(Icons.account_balance_wallet),
                      title: new TextFormField(
                        keyboardType: TextInputType.numberWithOptions(),
                        controller: alertQtyController,
                        validator: requiredValidator,
                        decoration: new InputDecoration(
                            // hintText: "Alert Quantity",
                            labelText: "Alert Quantity"),
                      ),
                    ),
                    verticalSpaceSmall,
                    buildDropdown(
                        model,
                        context,
                        categories.map((Category category) {
                          return {'display': category.name, 'value': category};
                        }).toList(),
                        'Category'),
                    verticalSpaceSmall,
                    new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        barcode == ''
                            ? Container()
                            : BarCodeImage(
                                params: CodabarBarCodeParams(
                                  barcode,
                                ),
                              ),
                        verticalSpaceTiny,
                        new FlatButton(
                            onPressed: scan,
                            child: new Text(
                              AppLocalizations.of(context)
                                  .translate('scanBarcode'),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  .copyWith(
                                      fontStyle: FontStyle.italic,
                                      decoration: TextDecoration.underline),
                            )),
                      ],
                    ),

                    verticalSpaceLarge,
                    Center(
                      child: BusyButton(
                        title: AppLocalizations.of(context).translate('submit'),
                        busy: model.busy,
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            // If the form is valid, display a Snackbar.
                            bool success = await model.saveItem(
                                data: Item(
                              id: widget.item?.id ?? '',
                              categoryId: selectedCategory.id ?? '',
                              unit: widget.item?.unit ?? '',
                              alertQty: int.parse(alertQtyController.text),
                              description: descriptionController.text,
                              name: nameController.text,
                              barcode: barcode,
                              updatedAt: isEditing ? DateTime.now() : null,
                              openingStock:
                                  int.parse(openingStockController.text),
                              // salePrice: double.parse(salePriceController.text),
                              // purchasePrice:
                              //     double.parse(purchasePriceController.text),
                              userId: null,
                            ));
                            _formKey.currentState.reset();
                            if (success) {
                              Navigator.pop(context);

                              Toast.show(
                                  message: 'Item successfully Added',
                                  context: context);
                            }
                          }
                        },
                      ),
                    ),

                    // Container(
                    //   padding: EdgeInsets.all(16),
                    //   child: DropDownFormField(
                    //     titleText: 'Unit',
                    //     hintText: 'Please Choose One',
                    //     value: selectedCategory,
                    //     onChanged: (Category value) {
                    //       setState(() {
                    //         selectedCategory = value;
                    //       });
                    //     },
                    //     dataSource: categories.map((Category category) {
                    //       return {'display': category.name, 'value': category};
                    //     }).toList(),
                    //     textField: 'display',
                    //     valueField: 'value',
                    //   ),
                    // ),
                  ],
                )

                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: <Widget>[
                //     InputField(
                //       smallVersion: true,
                //       isReadOnly: model.busy,
                //       placeholder: AppLocalizations.of(context).translate('itemName') +'*',
                //       controller: nameController,
                //     ),
                //     verticalSpaceSmall,
                //     ExpansionList<String>(
                //         isReadOnly: model.busy,
                //         items: [
                //           'Beer',
                //           'Cider',
                //           'Spirits',
                //           'Wine',
                //           'Bottled Water',
                //           'Soft Drinks',
                //           'Juice',
                //           'Energy Drinks',
                //           'Hot Drinks'
                //         ],
                //         title: isEditing
                //             ? widget.item.category
                //             : model.selectedCategory,
                //         onItemSelected: model.setSelectedCategory),
                //     verticalSpaceSmall,
                //     ExpansionList<String>(
                //         isReadOnly: model.busy,
                //         items: ['Kg', 'Unit', 'Lt', 'Psc'],
                //         title: isEditing ? widget.item.unit : model.selectedUnit,
                //         onItemSelected: model.setSelectedUnit),
                //     verticalSpaceSmall,
                //     // InputField(
                //     //   smallVersion: true,
                //     //   isReadOnly: model.busy,
                //     //   placeholder: 'Purchase Price',
                //     //   controller: purchasePriceController,
                //     //   textInputType: TextInputType.numberWithOptions(),
                //     // ),
                //     // verticalSpaceSmall,

                //     // InputField(
                //     //   smallVersion: true,
                //     //   isReadOnly: model.busy,
                //     //   placeholder: 'Sale Price',
                //     //   controller: salePriceController,
                //     //   textInputType: TextInputType.numberWithOptions(),
                //     // ),
                //     // verticalSpaceSmall,
                //     InputField(
                //       smallVersion: true,
                //       isReadOnly: model.busy,
                //       placeholder: AppLocalizations.of(context).translate('openingStock'),
                //       controller: openingStockController,
                //       textInputType: TextInputType.numberWithOptions(),
                //     ),
                //     verticalSpaceSmall,
                //     InputField(
                //       smallVersion: true,
                //       isReadOnly: model.busy,
                //       placeholder: AppLocalizations.of(context).translate('alertQuantity'),
                //       controller: alertQtyController,
                //       textInputType: TextInputType.numberWithOptions(),
                //     ),
                //     verticalSpaceSmall,
                //     InputField(
                //       smallVersion: true,
                //       isReadOnly: model.busy,
                //       placeholder: AppLocalizations.of(context).translate('description'),
                //       controller: descriptionController,
                //     ),
                //     verticalSpaceSmall,
                //     new Column(
                //       children: <Widget>[
                //         barcode == ''
                //             ? Container()
                //             : BarCodeImage(
                //                 params: CodabarBarCodeParams(
                //                   barcode,
                //                 ),
                //               ),
                //         new FlatButton(
                //             onPressed: scan, child: new Text(AppLocalizations.of(context).translate('scanBarcode'))),
                //       ],
                //     ),
                //     verticalSpaceSmall,

                //     Center(
                //       child: BusyButton(
                //         title: AppLocalizations.of(context).translate('submit'),
                //         busy: model.busy,
                //         onPressed: () async {
                //           if (_formKey.currentState.validate()) {
                //             // If the form is valid, display a Snackbar.
                //             model.saveItem(
                //                 data: Item(
                //               id: widget.item?.id ?? '',
                //               category: widget.item?.category ?? '',
                //               unit: widget.item?.unit ?? '',
                //               alertQty: int.parse(alertQtyController.text),
                //               description: descriptionController.text,
                //               name: nameController.text,
                //               barcode: barcode,
                //               updatedAt: isEditing?  DateTime.now(): null,
                //               openingStock: int.parse(openingStockController.text),
                //               // salePrice: double.parse(salePriceController.text),
                //               // purchasePrice:
                //               //     double.parse(purchasePriceController.text),
                //               userId: null,
                //             ));
                //             _formKey.currentState.reset();
                //           }
                //         },
                //       ),
                //     ),

                //     SizedBox(
                //       width: double.infinity,
                //       child: FlatButton(
                //           child: Text(AppLocalizations.of(context).translate('cancel'),style: TextStyle(color: Colors.grey[800]),),
                //           onPressed: () {
                //             Navigator.pop(context);
                //           }),
                //     ),
                //     // Padding(
                //     //     padding: EdgeInsets.only(
                //     //         bottom: MediaQuery.of(context).viewInsets.bottom)),
                //   ],
                // ),

                ),
          ),
        ),
      ),
    );
  }

  Row buildDropdown(ItemModel model, BuildContext context,
      List<dynamic> dataSource, String titleText) {
    return model.categories.length > 0
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 6,
                child: DropDownFormField(
                  titleText: titleText,
                  hintText: 'Please Choose One',
                  value: selectedCategory,
                  onChanged: (Category value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                  dataSource: dataSource,
                  textField: 'display',
                  valueField: 'value',
                ),
              ),
              SizedBox(
                width: 16.0,
              ),
              Expanded(
                flex: 1,
                child: Card(
                  elevation: 16.0,
                  child: IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                      onPressed: () {
                         model.filter = null;
                        setState(() {
                          selectedCategory = null;
                        });
                        var arguments = {
                          'title': 'Add Category',
                        };
                        Navigator.pushNamed(context, AppRoutes.category_form,
                            arguments: arguments);
                      }),
                ),
              )
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
                FlatButton(
                    onPressed: () {
                      setState(() {
                        selectedCategory = null;
                      });
                      var arguments = {
                        'title': 'Add Category',
                      };
                      Navigator.pushNamed(context, AppRoutes.category_form,
                          arguments: arguments);
                    },
                    child: Text(
                      'Select here to add Category',
                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontStyle: FontStyle.italic,
                          decoration: TextDecoration.underline),
                    )),
              ]);
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode =
              AppLocalizations.of(context).translate('userCameraPermisson');
        });
      } else {
        setState(() => this.barcode =
            AppLocalizations.of(context).translate('unknownError') + ': $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          AppLocalizations.of(context).translate('barcodeBackButtonException'));
    } catch (e) {
      setState(() => this.barcode =
          AppLocalizations.of(context).translate('unknownError') + ': $e');
    }
  }
}
