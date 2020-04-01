import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/models/item.dart';
import 'package:storeRahisi/pages/item/item_form.dart';
import 'package:storeRahisi/providers/item_model.dart';
import 'package:storeRahisi/widgets/custom_modal_sheet.dart';
import 'package:storeRahisi/widgets/toast.dart';

class ItemDetail extends StatefulWidget {
  final Item item;
  const ItemDetail({Key key, this.item}) : super(key: key);
  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  TextEditingController salePriceController;
  ItemModel _itemModel;
  void _showToast(String message, Color backGroundColor, IconData icon) {
    Toast.show(
      message: message,
      context: context,
      icon: Icon(icon, color: Colors.white),
      backgroundColor: backGroundColor,
    );
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

  @override
  Widget build(BuildContext context) {
    _itemModel = Provider.of<ItemModel>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: widget.item.name == null
            ? Text('Item Detail')
            : Text(
                '${widget.item.name.toUpperCase()}',
                overflow: TextOverflow.ellipsis,
              ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Wrap(
              spacing: 0.0, // gap between adjacent chips
              runSpacing: 0.0, // gap between lines
              children: <Widget>[
                chipDesign("Purchase History", Color(0xFF4fc3f7)),
                chipDesign("Sale History", Color(0xFFffb74d)),
                chipDesign("Update Price", Color(0xFFff8a65)),
                chipDesign("Print Barcode", Color(0xFF9575cd)),
                chipDesign("Edit", Color(0xFF4db6ac)),
                chipDesign("Delete", Color(0xFFf06292)),
              ],
            ),
            Divider(
              thickness: 10.0,
            ),
            ListTile(
              title: Text('${widget.item.category}'),
              subtitle: Text('Category'),
            ),
            Divider(
              thickness: 10.0,
            ),
            ListTile(
              title: Text('${widget.item.purchasePrice}'),
              subtitle: Text('Purchase Price'),
            ),
            ListTile(
              title: Text('${widget.item.salePrice}'),
              subtitle: Text('Sale Price'),
            ),
            Divider(
              thickness: 10.0,
            ),
            ListTile(
              title: Text('${widget.item.openingStock} ${widget.item.unit}'),
              subtitle: Text('Opening Stock'),
            ),
            ListTile(
              title: Text('${widget.item.alertQty} ${widget.item.unit}'),
              subtitle: Text('Alert Quantity'),
            ),
            Divider(
              thickness: 10.0,
            ),
            ListTile(
              title: Text('${widget.item.description}'),
              subtitle: Text('Description'),
            ),
            Divider(
              thickness: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget chipDesign(String label, Color color) => GestureDetector(
        onTap: () {
          label == 'Update Price'
              ? updatePrice()
              : label == 'Delete'
                  ? deleteItem()
                  : label == 'Edit'
                      ? _showModalSheetAppBar(
                          context,
                          'Edit Product',
                          ItemForm(
                            item: widget.item,
                          ),
                          0.81)
                      : _showToast(
                          label + ' Selected', color, Icons.error_outline);
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

  deleteItem() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete ${widget.item.name}'),
            content: Text('Are You Sure?'),
            actions: <Widget>[
              _itemModel.busy
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FlatButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        Container(
                          color: Colors.grey,
                          width: 1.0,
                          height: 24.0,
                        ),
                        FlatButton(
                            child: Text('Okay'),
                            onPressed: () async {
                              await _itemModel.removeItem(widget.item.id);
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            })
                      ],
                    ),
            ],
          );
        });
  }

  updatePrice() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Update Price'),
            content: TextFormField(
              decoration:
                  InputDecoration(labelText: 'New Price', hintText: ""),
              controller: salePriceController,
              keyboardType: TextInputType.numberWithOptions(),
              validator: (value) {
                return null;
              },
            ),
            actions: <Widget>[
              _itemModel.busy
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FlatButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        Container(
                          color: Colors.grey,
                          width: 1.0,
                          height: 24.0,
                        ),
                        FlatButton(
                            child: Text('Okay'),
                            onPressed: () async {
                              await _itemModel.removeItem(widget.item.id);
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            })
                      ],
                    ),
            ],
          );
        });
  }
}
