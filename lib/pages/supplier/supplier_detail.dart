import 'package:flutter/material.dart';
import 'package:storeRahisi/models/supplier.dart';
import 'package:storeRahisi/providers/supplier_model.dart';

class SupplierDetail extends StatelessWidget {
  final Supplier supplier;
  final SupplierModel supplierModel;

  const SupplierDetail({Key key, this.supplier, this.supplierModel})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: supplier.name == null
            ? Text('Supplier Details')
            : Text(
                '${supplier.name.toUpperCase()}',
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
                chipDesign("Delete", Color(0xFFf06292)),
              ],
            ),
            Divider(
              thickness: 10.0,
            ),
            ListTile(
              title: Text('${supplier.name}'),
              subtitle: Text(' Supplier Name'),
            ),
            ListTile(
              title: Text('${supplier.contactPerson}'),
              subtitle: Text('Contact Person'),
            ),
            Divider(
              thickness: 10.0,
            ),
            ListTile(
              title: Text('${supplier.phoneNumber}'),
              subtitle: Text('Phone Number'),
            ),
            ListTile(
              title: Text('${supplier.email}'),
              subtitle: Text('Email'),
            ),
            ListTile(
              title: Text('${supplier.address}'),
              subtitle: Text('Address'),
            ),
            ListTile(
              title: Text('${supplier.description}'),
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
        // label == 'Delete'
        //     ? supplierModel.removePurchase(supplier.id)
        //     : label == 'Edit'
        //         ? _showModalSheetAppBar(
        //             context,
        //             'Edit Product',
        //             PurchaseForm(
        //               purchase: widget.purchase,
        //             ),
        //             0.81)
        //         : _showToast(label + ' Selected', color, Icons.error_outline);
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
