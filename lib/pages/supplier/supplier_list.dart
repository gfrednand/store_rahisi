import 'package:flutter/material.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/providers/supplier_model.dart';
import 'package:storeRahisi/pages/base_view.dart';

class SupplierList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        child: BaseView<SupplierModel>(
            onModelReady: (model) => model.listenToSuppliers(),
            builder: (context, model, child) {
              return !model.busy
                  ? model.suppliers == null
                      ? Center(
                          child: Text('Nothing Found'),
                        )
                      : ListView.builder(
                          itemCount: model.suppliers.length,
                          itemBuilder: (buildContext, index) => Card(
                            child: ListTile(
                              leading: ExcludeSemantics(
                                child: CircleAvatar(
                                  radius: 30.0,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child: Text(
                                    model.suppliers[index].name
                                        .substring(0, 2)
                                        .toUpperCase(),
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor),
                                  ),
                                ),
                              ),
                              title: Hero(
                                tag: '${model.suppliers[index].id}__heroTag',
                                child: Text(
                                  '${model.suppliers[index].name}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              subtitle: Text(
                                '${model.suppliers[index].phoneNumber}',
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () {
                                var arguments = {
                                  'supplier': model.suppliers[index],
                                  'supplierModel': model,
                                };
                                Navigator.pushNamed(
                                    context, AppRoutes.supplier_detail,
                                    arguments: arguments);
                              },
                            ),
                          ),
                        )
                  : Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                            Theme.of(context).accentColor),
                      ),
                    );
            }));
  }
}
