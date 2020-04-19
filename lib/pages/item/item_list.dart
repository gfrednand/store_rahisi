import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/pages/base_view.dart';
import 'package:storeRahisi/providers/item_model.dart';
import 'package:storeRahisi/providers/purchase_model.dart';
import 'package:storeRahisi/providers/sale_model.dart';
import '../../app_localizations.dart';

class ItemList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PurchaseModel purchaseModel = Provider.of<PurchaseModel>(context);
    SaleModel saleModel = Provider.of<SaleModel>(context);
    return BaseView<ItemModel>(
      onModelReady: (model) => model.listenToItems(),
      builder: (context, model, child) {
        return Scrollbar(
            child: !model.busy
                ? model.items == null
                    ? Center(
                        child: Text(AppLocalizations.of(context).translate('nothingFound')),
                      )
                    : ListView.builder(
                        itemCount: model.items.length,
                        itemBuilder: (buildContext, index) {
                          model.items[index].totalPurchase = purchaseModel
                              .getTotalPurchaseByItemId(model.items[index].id);
                          model.items[index].totalSales = saleModel
                              .getTotalSaleByItemId(model.items[index].id);
                          model.items[index].inStock =
                              (model.items[index].totalPurchase +
                                      model.items[index].openingStock) -
                                  model.items[index].totalSales;
                          Color color = model.items[index].inStock == 0
                              ? Colors.red
                              : model.items[index].inStock >
                                      model.items[index].alertQty
                                  ? Colors.green
                                  : Colors.orange;
                          return Card(
                            child: ListTile(
                              leading: ExcludeSemantics(
                                child: CircleAvatar(
                                  radius: 25.0,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child: Text(
                                    model.items[index].name
                                        .substring(0, 2)
                                        .toUpperCase(),
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor),
                                  ),
                                ),
                              ),
                              title: Text(
                                '${model.items[index].name.toUpperCase()}',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: color, fontWeight: FontWeight.bold),
                              ),
                              // subtitle: Text(
                              //   '${model.items[index].alertQty ?? 0}',
                              //   overflow: TextOverflow.ellipsis,
                              // ),
                              trailing: Text(
                                '${model.items[index].inStock} ${model.items[index].unit}',
                                style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: () {
                                var arguments = {
                                  'item': model.items[index],
                                  'itemModel': model,
                                };

                                Navigator.pushNamed(
                                    context, AppRoutes.item_detail,
                                    arguments: arguments);
                              },
                            ),
                          );
                        },
                      )
                : Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation(Theme.of(context).accentColor),
                    ),
                  ));
      },
    );
  }
}
