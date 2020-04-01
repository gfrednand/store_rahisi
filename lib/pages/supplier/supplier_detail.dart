import 'package:flutter/material.dart';
import 'package:storeRahisi/models/supplier.dart';

class SupplierDetail extends StatelessWidget {
  final Supplier supplier;

  const SupplierDetail({Key key, this.supplier}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: supplier.name == null
            ? Text('Supplier Details')
            : Text('${supplier.name.toUpperCase()}',  overflow: TextOverflow.ellipsis,),
      ),
    );
  }
}
