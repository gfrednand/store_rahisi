import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/models/supplier.dart';
import 'package:storeRahisi/pages/supplier/supplier_form.dart';
import 'package:storeRahisi/providers/purchase_model.dart';
import 'package:storeRahisi/providers/supplier_model.dart';
import 'package:storeRahisi/widgets/custom_modal_sheet.dart';

class SupplierDetail extends StatefulWidget {
  final Supplier supplier;
  final SupplierModel supplierModel;

  const SupplierDetail({Key key, this.supplier, this.supplierModel})
      : super(key: key);

  @override
  _SupplierDetailState createState() => _SupplierDetailState();
}

class _SupplierDetailState extends State<SupplierDetail> {
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
    PurchaseModel purchaseModel = Provider.of<PurchaseModel>(context);
    List<Purchase> purchases =
        purchaseModel.getPurchaseHistoryBySupplierId(widget.supplier.id);
    return Scaffold(
      appBar: AppBar(
        title: widget.supplier.name == null
            ? Text('Supplier Details')
            : Text(
                '${widget.supplier.name.toUpperCase()}',
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
                chipDesign("Edit", Color(0xFF4db6ac)),
                purchases.length == 0
                    ? chipDesign("Delete", Color(0xFFf06292))
                    : Container(),
              ],
            ),
            Divider(
              thickness: 10.0,
            ),
            ListTile(
              title: Text('${widget.supplier.name}'),
              subtitle: Text(' Supplier Name'),
            ),
            ListTile(
              title: Text('${widget.supplier.contactPerson}'),
              subtitle: Text('Contact Person'),
            ),
            Divider(
              thickness: 10.0,
            ),
            ListTile(
              title: Text('${widget.supplier.phoneNumber}'),
              subtitle: Text('Phone Number'),
            ),
            ListTile(
              title: Text('${widget.supplier.email}'),
              subtitle: Text('Email'),
            ),
            ListTile(
              title: Text('${widget.supplier.address}'),
              subtitle: Text('Address'),
            ),
            ListTile(
              title: Text('${widget.supplier.description}'),
              subtitle: Text('Note'),
            ),
            Divider(
              thickness: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget chipDesign(String label, Color color) {
    return GestureDetector(
      onTap: () {
        label == 'Delete'
            ? widget.supplierModel.removeSupplier(widget.supplier.id)
            : label == 'Edit'
                ? _showModalSheetAppBar(
                    context,
                    'Edit Product',
                    SupplierForm(
                      supplier: widget.supplier,
                    ),
                    0.81)
                : Container();
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
