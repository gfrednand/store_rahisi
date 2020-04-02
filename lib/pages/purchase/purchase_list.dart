import 'package:flutter/material.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/pages/base_view.dart';
import 'package:storeRahisi/providers/purchase_model.dart';

class PurchaseList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<PurchaseModel>(
      onModelReady: (model) => model.listenToPurchases(),
      builder: (context, model, child) {
        return Scrollbar(
            child: !model.busy
                ? model.purchases == null
                    ? Center(
                        child: Text('Nothing Found'),
                      )
                    : ListView.builder(
                        itemCount: model.purchases.length,
                        itemBuilder: (buildContext, index) => Card(
                          child: ListTile(
                            leading: ExcludeSemantics(
                              child: CircleAvatar(
                                radius: 30.0,
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Text(
                                  'P',
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor),
                                ),
                              ),
                            ),
                            title: Text(
                              '${model.purchases[index].purchaseDate}',
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              '${model.purchases[index].grandTotalAmount}',
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing:
                                Text('${model.purchases[index].paidAmount}}'),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.purchase_detail,
                                  arguments: model.purchases[index]);
                            },
                          ),
                        ),
                      )
                : Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                          Theme.of(context).primaryColor),
                    ),
                  ));
      },
    );
  }
}
