import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/constants/ui_helpers.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/pages/base_view.dart';
import 'package:storeRahisi/pages/item/item_detail.dart';
import 'package:storeRahisi/pages/item/item_detail_widget.dart';
import 'package:storeRahisi/providers/item_model.dart';
import 'package:storeRahisi/providers/purchase_model.dart';
import 'package:storeRahisi/providers/sale_model.dart';
import '../../app_localizations.dart';

class ItemList extends StatefulWidget {
  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  Item selectedValue;
  int selectedIndex;
  bool isLargeScreen = false;

  @override
  Widget build(BuildContext context) {
    PurchaseModel purchaseModel = Provider.of<PurchaseModel>(context);
    SaleModel saleModel = Provider.of<SaleModel>(context);
    return BaseView<ItemModel>(
      onModelReady: (model) => model.listenToItems(),
      builder: (context, model, child) {
        return OrientationBuilder(builder: (context, orientation) {
          if (MediaQuery.of(context).size.width > 600) {
            isLargeScreen = true;
          } else {
            isLargeScreen = false;
          }

          return Row(children: <Widget>[
            Expanded(
              flex: 2,
              child: buildScrollbar(model, context, purchaseModel, saleModel),
            ),
            isLargeScreen
                ? Expanded(
                    flex: 3,
                    child: ItemDetailWidget(
                      item: selectedValue,
                      itemModel: model,
                    ))
                : Container(),
          ]);
        });
      },
    );
  }

  Column buildScrollbar(ItemModel model, BuildContext context,
      PurchaseModel purchaseModel, SaleModel saleModel) {
    return Column(
      children: [
        Wrap(
          spacing: 0.0, // gap between adjacent chips
          runSpacing: 0.0, // gap between lines
          children: <Widget>[
            chipDesign('All', Color(0xFF4db6ac)),
            ...model.categories
                .map((element) => chipDesign(element.name, Colors.grey))
                .toList()
          ],
        ),
      verticalSpaceTiny,
        Scrollbar(
            child: !model.busy
                ? model.items.length == 0
                    ? Center(
                        child: Text(AppLocalizations.of(context)
                            .translate('nothingFound')),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
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
                          model.items[index].category = model
                              .getCategoryById(model.items[index].categoryId)
                              ?.name;
                          return Column(
                            children: [
                              Divider(
                                height: 5.0,
                              ),
                              Container(
                                // padding: const EdgeInsets.only(top: 16.0),
                                color: selectedIndex != null &&
                                        selectedIndex == index &&
                                        isLargeScreen
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context)
                                        .colorScheme
                                        .primaryVariant,
                                child: ListTile(
                                  leading: ExcludeSemantics(
                                    child: CircleAvatar(
                                      radius: 25.0,
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      child: Text(
                                        model.items[index].name
                                            .substring(0, 2)
                                            .toUpperCase(),
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: selectedIndex != null &&
                                                  selectedIndex == index
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: Row(
                                    children: <Widget>[
                                      Text(
                                        '${model.items[index].name.toUpperCase()}',
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                      SizedBox(
                                        width: 16.0,
                                      ),
                                      Text(
                                        '${model.items[index].inStock} ${model.items[index].unit}',
                                        style: TextStyle(
                                          color: color,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Text(
                                    '${model.items[index].category}',
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                  ),
                                  trailing: Icon(
                                     Icons.arrow_forward_ios,
                      color: Theme.of(context).iconTheme.color,
                                  ),
                                  onTap: () {
                                    if (isLargeScreen) {
                                      selectedValue = model.items[index];
                                      setState(() {
                                        selectedIndex = index;
                                      });
                                    } else {
                                      var arguments = {
                                        'item': model.items[index],
                                        'itemModel': model,
                                      };

                                      Navigator.pushNamed(
                                          context, AppRoutes.item_detail,
                                          arguments: arguments);
                                    }
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      )
                : Center(
                    child: CircularProgressIndicator(
                        // valueColor:
                        //     AlwaysStoppedAnimation(Theme.of(context).accentColor),
                        ),
                  )),
      ],
    );
  }

  Widget chipDesign(String label, Color color) {
    return GestureDetector(
      onTap: () {},
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
