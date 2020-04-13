import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:storeRahisi/constants/ui_helpers.dart';
import 'package:storeRahisi/models/item.dart';
import 'package:storeRahisi/providers/item_model.dart';
import 'package:storeRahisi/widgets/busy_button.dart';
import 'package:storeRahisi/widgets/expansion_list.dart';
import 'package:storeRahisi/widgets/input_field.dart';
import 'package:barcode_flutter/barcode_flutter.dart';
import '../base_view.dart';

class ItemForm extends StatefulWidget {
  final Item item;

  ItemForm({
    Key key,
    this.item,
  }) : super(key: key);

  @override
  _ItemFormState createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  final nameController = new TextEditingController();

  final descriptionController = new TextEditingController();

  final salePriceController = new TextEditingController();

  final purchasePriceController = new TextEditingController();

  final alertQtyController = new TextEditingController();

  final openingStockController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String barcode = "";

  @override
  Widget build(BuildContext context) {
    var isEditing = widget.item != null;

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
      builder: (context, model, child) => Container(
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
                  placeholder: 'Item Name*',
                  controller: nameController,
                ),
                verticalSpaceSmall,
                ExpansionList<String>(
                    isReadOnly: model.busy,
                    items: [
                      'Beer',
                      'Cider',
                      'Spirits',
                      'Wine',
                      'Bottled Water',
                      'Soft Drinks',
                      'Juice',
                      'Energy Drinks',
                      'Hot Drinks'
                    ],
                    title: isEditing
                        ? widget.item.category
                        : model.selectedCategory,
                    onItemSelected: model.setSelectedCategory),
                verticalSpaceSmall,
                ExpansionList<String>(
                    isReadOnly: model.busy,
                    items: ['Kg', 'Unit', 'Lt', 'Psc'],
                    title: isEditing ? widget.item.unit : model.selectedUnit,
                    onItemSelected: model.setSelectedUnit),
                verticalSpaceSmall,
                // InputField(
                //   smallVersion: true,
                //   isReadOnly: model.busy,
                //   placeholder: 'Purchase Price',
                //   controller: purchasePriceController,
                //   textInputType: TextInputType.numberWithOptions(),
                // ),
                // verticalSpaceSmall,

                // InputField(
                //   smallVersion: true,
                //   isReadOnly: model.busy,
                //   placeholder: 'Sale Price',
                //   controller: salePriceController,
                //   textInputType: TextInputType.numberWithOptions(),
                // ),
                // verticalSpaceSmall,
                InputField(
                  smallVersion: true,
                  isReadOnly: model.busy,
                  placeholder: 'Opening Stock',
                  controller: openingStockController,
                  textInputType: TextInputType.numberWithOptions(),
                ),
                verticalSpaceSmall,
                InputField(
                  smallVersion: true,
                  isReadOnly: model.busy,
                  placeholder: 'Alert Quantity',
                  controller: alertQtyController,
                  textInputType: TextInputType.numberWithOptions(),
                ),
                verticalSpaceSmall,
                InputField(
                  smallVersion: true,
                  isReadOnly: model.busy,
                  placeholder: 'Description',
                  controller: descriptionController,
                ),
                verticalSpaceSmall,
                new Column(
                  children: <Widget>[
                    barcode == ''
                        ? Container()
                        : BarCodeImage(
                            params: CodabarBarCodeParams(
                              barcode,
                            ),
                          ),
                    new FlatButton(
                        onPressed: scan, child: new Text("Scan Barcode")),
                  ],
                ),
                verticalSpaceSmall,

                Center(
                  child: BusyButton(
                    title: 'Submit',
                    busy: model.busy,
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, display a Snackbar.
                        model.saveItem(
                            data: Item(
                          id: widget.item?.id ?? '',
                          category: widget.item?.category ?? '',
                          unit: widget.item?.unit ?? '',
                          alertQty: int.parse(alertQtyController.text),
                          description: descriptionController.text,
                          name: nameController.text,
                          barcode: barcode,
                          openingStock: int.parse(openingStockController.text),
                          // salePrice: double.parse(salePriceController.text),
                          // purchasePrice:
                          //     double.parse(purchasePriceController.text),
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
                      child: Text('Cancel'),
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
    );
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}
