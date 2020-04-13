import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/pages/base_view.dart';
import 'package:storeRahisi/pages/pos/pos_item.dart';
import 'package:storeRahisi/pages/sale/sale_list.dart';
import 'package:storeRahisi/providers/item_model.dart';
import 'package:storeRahisi/providers/purchase_model.dart';
import 'package:storeRahisi/providers/sale_model.dart';

class PosItemList extends StatefulWidget {
  @override
  _PosItemListState createState() => _PosItemListState();
}

class _PosItemListState extends State<PosItemList> {
  bool itemSelected = true;
  TextEditingController editingController = TextEditingController();
  var allItems = List<Item>();
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _buildFilterWidgets(screenSize, context),
        itemSelected ? _buildProductsListWidget(context) : SaleList()
      ],
    );
  }

  _buildFilterWidgets(Size screenSize, BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      width: screenSize.width,
      child: Card(
        elevation: 15.0,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildItemButton(),
              Container(
                color: Theme.of(context).primaryColor,
                width: 2.0,
                height: 24.0,
              ),
              _buildSaleButton(),
            ],
          ),
        ),
      ),
    );
  }

  _buildSaleButton() {
    return InkWell(
      onTap: () {
        setState(() {
          itemSelected = false;
        });
      },
      child: Row(
        children: <Widget>[
          Icon(
            Icons.list,
            color:
                itemSelected ? Colors.black38 : Theme.of(context).accentColor,
          ),
          SizedBox(
            width: 2.0,
          ),
          Text(
            'Sales',
            style: TextStyle(
              color:
                  itemSelected ? Colors.black38 : Theme.of(context).accentColor,
              fontWeight: itemSelected ? FontWeight.normal : FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  _buildItemButton() {
    return InkWell(
      onTap: () {
        setState(() {
          itemSelected = true;
        });
      },
      child: Row(
        children: <Widget>[
          Icon(
            Icons.web,
            color:
                !itemSelected ? Colors.black38 : Theme.of(context).accentColor,
          ),
          SizedBox(
            width: 2.0,
          ),
          Text(
            'Items',
            style: TextStyle(
              color: !itemSelected
                  ? Colors.black38
                  : Theme.of(context).accentColor,
              fontWeight: !itemSelected ? FontWeight.normal : FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  filterSearchResults(String query, List<Item> items) {
    List<Item> dummySearchList = List<Item>();
    if (items.length > 0) {
      dummySearchList = items;
    }
    print('^^^^^^^^^^^${dummySearchList.toString()}');

    if (query.isNotEmpty) {
      List<Item> dummyListData = List<Item>();
      dummySearchList.forEach((item) {
        if (item.name.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        allItems.clear();
        allItems.addAll(dummyListData);
      });
      return;
    } else {
      print('*******${items.toString()}');
      setState(() {
        allItems.clear();
        allItems = items;
      });
    }
  }

  _buildProductsListWidget(BuildContext context) {
    return BaseView<ItemModel>(
        onModelReady: (model) => model.listenToItems(),
        builder: (context, model, child) {
          allItems = model.items;
          return Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      filterSearchResults(value, model.items);
                    },
                    controller: editingController,
                    decoration: InputDecoration(
                        labelText: "Search",
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder()),
                  ),
                ),
                Expanded(
                    child: Container(
                        color: Colors.grey[100],
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: allItems.length,
                            itemBuilder: (context, index) {
                              PurchaseModel purchaseModel =
                                  Provider.of<PurchaseModel>(context);
                              SaleModel saleModel =
                                  Provider.of<SaleModel>(context);
                              List<Purchase> purchases =
                                  purchaseModel.getPurchaseHistoryByItemId(
                                      allItems[index].id);
                              allItems[index].totalSales = saleModel
                                  .getTotalSaleByItemId(allItems[index].id);
                              allItems[index].totalPurchase = purchaseModel
                                  .getTotalPurchaseByItemId(allItems[index].id);
                              purchases.sort((a, b) =>
                                  a.purchaseDate.compareTo(b.purchaseDate));
                              double cur =
                                  purchases?.last?.items?.first?.salePrice;
                              double org =
                                  purchases?.first?.items?.first?.salePrice;
                              double profit = cur -
                                  purchases?.first?.items?.first?.purchasePrice;
                              int quantity =
                                  (model?.items[index]?.totalPurchase ??
                                              0 +
                                                  model?.items[index]
                                                      ?.openingStock ??
                                              0) -
                                          model?.items[index]?.totalSales ??
                                      0;
                              double disco = org - cur;
                              disco = disco * 100;
                              return new PosItem(
                                  profit: profit,
                                  quantity: quantity,
                                  item: allItems[index],
                                  // purchase: purchase,
                                  currentPrice: cur,
                                  originalPrice: org,
                                  discount: disco / org,
                                  imageUrl: "");
                            })))
              ],
            ),
          );
        });
  }
}
