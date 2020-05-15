import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/constants/ui_helpers.dart';
import 'package:storeRahisi/models/index.dart';
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
    PurchaseModel purchaseModel = context.watch<PurchaseModel>();
    SaleModel saleModel = Provider.of<SaleModel>(context, listen: true);
    ItemModel itemModel = context.watch<ItemModel>();
    List<Item> items =
        context.select((ItemModel itemModel) => itemModel.filteredItems);

    return OrientationBuilder(builder: (context, orientation) {
      if (MediaQuery.of(context).size.width > 600) {
        isLargeScreen = true;
      } else {
        isLargeScreen = false;
      }

      return Row(children: <Widget>[
        Expanded(
          flex: 2,
          child: buildScrollbar(
              items, context, purchaseModel, saleModel, itemModel),
        ),
        isLargeScreen
            ? Expanded(
                flex: 3,
                child: ItemDetailWidget(
                  item: selectedValue,
                ))
            : Container(),
      ]);
    });
  }

  Widget _buildFilter(ItemModel model, List<Category> filters) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, right: 8.0, top: 8.0),
      child: Align(
        alignment: Alignment.bottomRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text('Filter by:'),
            const SizedBox(width: 8.0),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.0, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Category>(
                  isDense: true,
                  value: model.filter == null ? null : model.filter,
                  items: filters
                      .map((category) => DropdownMenuItem<Category>(
                            child: Text(category.name),
                            value: category,
                          ))
                      .toList(),
                  onChanged: (filter) {
                    model.filter = filter;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column buildScrollbar(List<Item> items, BuildContext context,
      PurchaseModel purchaseModel, SaleModel saleModel, ItemModel model) {
    List<Category> categories =
        context.select((ItemModel itemModel) => itemModel.categories);
    bool busy = context.select((ItemModel itemModel) => itemModel.busy);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildFilter(model, categories),
        verticalSpaceTiny,
        !busy
            ? items.length == 0
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context)
                          .translate('nothingFound')),
                    ],
                  )
                : Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (buildContext, index) {
                        items[index].totalPurchase = purchaseModel
                            .getTotalPurchaseByItemId(items[index].id);
                        items[index].totalSales =
                            saleModel.getTotalSaleByItemId(items[index].id);
                        items[index].inStock = (items[index].totalPurchase +
                                items[index].openingStock) -
                            items[index].totalSales;
                        Color color = items[index].inStock == 0
                            ? Colors.red
                            : items[index].inStock > items[index].alertQty
                                ? Colors.green
                                : Colors.orange;
                        items[index].category = model
                            .getCategoryById(items[index].categoryId)
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
                                    backgroundColor:
                                        Theme.of(context).colorScheme.onPrimary,
                                    child: Text(
                                      items[index]
                                          .name
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
                                      '${items[index].name.toUpperCase()}',
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                    SizedBox(
                                      width: 16.0,
                                    ),
                                    Text(
                                      '${items[index].inStock} ${items[index].unit}',
                                      style: TextStyle(
                                        color: color,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                  '${items[index].category}',
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                                onTap: () {
                                  if (isLargeScreen) {
                                    selectedValue = items[index];
                                    setState(() {
                                      selectedIndex = index;
                                    });
                                  } else {
                                    Navigator.pushNamed(
                                        context, AppRoutes.item_detail,
                                        arguments: items[index].id);
                                  }
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )
            : Center(
                child: CircularProgressIndicator(
                    // valueColor:
                    //     AlwaysStoppedAnimation(Theme.of(context).accentColor),
                    ),
              ),
      ],
    );
  }
}
