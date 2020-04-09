import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/pages/base_view.dart';
import 'package:storeRahisi/pages/purchase/add_item_form.dart';
import 'package:storeRahisi/providers/item_model.dart';
import 'package:storeRahisi/providers/purchase_model.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/widgets/custom_modal_sheet.dart';

class PurchaseAdd extends StatefulWidget {
  final String title;

  const PurchaseAdd({Key key, this.title}) : super(key: key);

  @override
  _PurchaseAddState createState() => _PurchaseAddState();
}

class _PurchaseAddState extends State<PurchaseAdd> {
  Supplier _supplier;

  @override
  Widget build(BuildContext context) {
    ItemModel itemModel = Provider.of<ItemModel>(context);
    return BaseView<PurchaseModel>(
        onModelReady: (model) => model.getSuppliers(),
        builder: (context, model, child) {
          return Scaffold(
            appBar: buildAppBar(model, context),
            body: buildBody(model, context),
            floatingActionButton: _supplier == null || model.busy
                ? Container()
                : FloatingActionButton.extended(
                    onPressed: () {
                      _showModalSheetAppBar(
                          context,
                          'Add Product',
                          AddItemForm(
                            purchaseModel: model,
                            items: itemModel.items ?? [],
                          ),
                          0.70);
                    },
                    foregroundColor: Colors.white,
                    label: Text('Add Item'),
                    icon: Icon(Icons.add),
                    backgroundColor: Theme.of(context).accentColor,
                  ),
          );
        });
  }

  _showModalSheetAppBar(
      BuildContext context, String title, Widget body, double heightFactor) {
    CustomModalSheet.show(
      title: title,
      context: context,
      body: body,
      heightFactor: heightFactor,
    );
  }

  Column buildBody(PurchaseModel model, BuildContext context) {
    var items = model.selectedItems;
    return Column(
      children: <Widget>[
        Center(
          child: Container(
            padding: EdgeInsets.all(8.0),
            width: double.infinity,
            child: DropdownButtonHideUnderline(
              child: new DropdownButton<Supplier>(
                hint: Text('Select Supplier'),
                value: _supplier,
                items: model.suppliers.map((Supplier value) {
                  return new DropdownMenuItem<Supplier>(
                    value: value,
                    child: new Text(value.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _supplier = value;
                  });
                },
                // style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ),
        ),
        Divider(
          thickness: 5.0,
        ),
        items == null || items.length == 0
            ? Container()
            : Flexible(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (buildContext, index) => Card(
                    child: ListTile(
                      leading: ExcludeSemantics(
                        child: CircleAvatar(
                          radius: 30.0,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            items[index].name.substring(0, 2).toUpperCase(),
                            style:
                                TextStyle(color: Theme.of(context).accentColor),
                          ),
                        ),
                      ),
                      title: Text(
                        '${items[index].name}',
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Purchase Price: ${items[index].purchasePrice} @1',
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Sale Price: ${items[index].salePrice} @1',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      trailing: Text('${items[index].quantity}'),
                      onTap: () {
                        // Navigator.pushNamed(
                        //     context, AppRoutes.purchase_detail,
                        //     arguments: items[index]);
                      },
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  AppBar buildAppBar(PurchaseModel model, BuildContext context) {
    return AppBar(
      title: Text(widget.title),
      actions: <Widget>[
        model.busy
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 5.0,
                      valueColor:
                          AlwaysStoppedAnimation(Theme.of(context).accentColor),
                    ),
                  ),
                ),
              )
            : model.selectedItems.length > 0
                ? FlatButton.icon(
                    icon: Icon(Icons.save),
                    color: Theme.of(context).accentColor,
                    textColor: Colors.white,
                    onPressed: () {
                      var grandTotalAmount = 0.0;
                      var paidAmount = 0.0;
                      model.selectedItems.forEach((element) {
                        grandTotalAmount =
                            grandTotalAmount + element.purchasePrice;
                        paidAmount = paidAmount + element.paidAmount;
                      });
                      model.savePurchase(
                          data: Purchase(
                              supplierId: _supplier.id,
                              supplier: _supplier.name,
                              items: model.selectedItems,
                              grandTotalAmount: grandTotalAmount,
                              paidAmount: paidAmount,
                              dueAmount: grandTotalAmount - paidAmount,
                              userId: ''));
                    },
                    label: Text('Save'),

                    // shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
                  )
                : Container(),
      ],
    );
  }
}
