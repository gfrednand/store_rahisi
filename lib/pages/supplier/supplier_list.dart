import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/models/supplier.dart';
import 'package:storeRahisi/providers/supplier_model.dart';

class SupplierList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final supplierProvider = Provider.of<SupplierModel>(context);
    return Scrollbar(
      child: StreamBuilder(
          stream: supplierProvider.fetchSuppliersAsStream(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              List<Supplier> suppliers = snapshot.data.documents
                  .map((doc) => Supplier.fromMap(doc.data, doc.documentID))
                  .toList();
              return ListView.builder(
                itemCount: suppliers.length,
                itemBuilder: (buildContext, index) => Card(
                  child: ListTile(
                    leading: ExcludeSemantics(
                      child: CircleAvatar(
                        radius: 30.0,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          suppliers[index].name.substring(0, 2).toUpperCase(),
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
                        ),
                      ),
                    ),
                    title: Hero(
                      tag: '${suppliers[index].id}__heroTag',
                      child: Text(
                        '${suppliers[index].name}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    subtitle: Text(
                      '${suppliers[index].phoneNumber}',
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                          context, AppRoutes.supplier_detail,
                          arguments: suppliers[index]);
                    },
                  ),
                ),
              );
            } else {
              return Text('fetching...');
            }
          }),
    );
  }
}
