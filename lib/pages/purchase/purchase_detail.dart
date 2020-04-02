import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/models/purchase.dart';
import 'package:storeRahisi/pages/purchase/purchase_form.dart';
import 'package:storeRahisi/providers/purchase_model.dart';
import 'package:storeRahisi/widgets/custom_modal_sheet.dart';
import 'package:storeRahisi/widgets/toast.dart';

class PurchaseDetail extends StatefulWidget {
  final Purchase purchase;
  const PurchaseDetail({Key key, this.purchase}) : super(key: key);
  @override
  _PurchaseDetailState createState() => _PurchaseDetailState();
}

class _PurchaseDetailState extends State<PurchaseDetail> {
  TextEditingController salePriceController;
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
    return Scaffold(
      appBar: AppBar(
        title: widget.purchase.purchaseDate == null
            ? Text('Purchase Detail')
            : Text(
                '${widget.purchase.purchaseDate.toUpperCase()}',
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
                chipDesign("Purchase Items", Color(0xFF4fc3f7)),
                chipDesign("Payment History", Color(0xFFffb74d)),
                chipDesign("Make Payement", Color(0xFF9575cd)),
                chipDesign("Edit", Color(0xFF4db6ac)),
                chipDesign("Delete", Color(0xFFf06292)),
              ],
            ),
            Divider(
              thickness: 10.0,
            ),
            ListTile(
              title: Text('${widget.purchase.grandTotalAmount}'),
              subtitle: Text('Grand Total'),
            ),
            Divider(
              thickness: 10.0,
            ),
            ListTile(
              title: Text('${widget.purchase.paidAmount}'),
              subtitle: Text('Paid Amount'),
            ),
            ListTile(
              title: Text('${widget.purchase.dueAmount}'),
              subtitle: Text('Due Amount'),
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
    PurchaseModel model = Provider.of<PurchaseModel>(context, listen: false);
    return GestureDetector(
      onTap: () {
        label == 'Delete'
            ? model.removePurchase(widget.purchase.id)
            : label == 'Edit'
                ? _showModalSheetAppBar(
                    context,
                    'Edit Product',
                    PurchaseForm(
                      purchase: widget.purchase,
                    ),
                    0.81)
                : _showToast(label + ' Selected', color, Icons.error_outline);
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
