import 'package:flutter/material.dart';
import 'package:storeRahisi/constants/ui_helpers.dart';
import 'package:storeRahisi/models/item.dart';
import 'package:storeRahisi/providers/item_model.dart';
import 'package:storeRahisi/widgets/busy_button.dart';
import 'package:storeRahisi/widgets/expansion_list.dart';
import 'package:storeRahisi/widgets/input_field.dart';

import '../base_view.dart';

class ItemForm extends StatelessWidget {
  final Item item;
  final nameController = new TextEditingController();
  final descriptionController = new TextEditingController();
  final salePriceController = new TextEditingController();
  final purchasePriceController = new TextEditingController();
  final alertQtyController = new TextEditingController();
  final openingStockController = new TextEditingController();
  ItemForm({
    Key key,
    this.item,
  }) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var isEditing = item != null;

    // Build a Form widget using the _formKey created above.
    return BaseView<ItemModel>(
      onModelReady: (model) {
        // update the text in the controller
        if (isEditing) {
          nameController.text = item?.name ?? '';
          descriptionController.text = item?.description ?? '';
          salePriceController.text = item?.salePrice.toString() ?? '0';
          purchasePriceController.text = item?.purchasePrice.toString() ?? '0';
          alertQtyController.text = item?.alertQty.toString() ?? '0';
          openingStockController.text = item?.openingStock.toString() ?? '0';
          model.setEdittingItem(item);
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
                    title: isEditing ? item.category : model.selectedCategory,
                    onItemSelected: model.setSelectedCategory),
                verticalSpaceSmall,
                ExpansionList<String>(
                    isReadOnly: model.busy,
                    items: ['Kg', 'Unit', 'Lt', 'Psc'],
                    title: isEditing ? item.unit : model.selectedUnit,
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

                Center(
                  child: BusyButton(
                    title: 'Submit',
                    busy: model.busy,
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, display a Snackbar.
                        model.saveItem(
                            data: Item(
                          id: item?.id ?? '',
                          category: item?.category ?? '',
                          unit: item?.unit ?? '',
                          alertQty: int.parse(alertQtyController.text),
                          description: descriptionController.text,
                          name: nameController.text,
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
}
