import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/pages/base_view.dart';
import 'package:storeRahisi/pages/pos/product_item.dart';
import 'package:storeRahisi/providers/item_model.dart';
import 'package:storeRahisi/providers/purchase_model.dart';
import 'package:storeRahisi/providers/sale_model.dart';

class PosItemList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _buildFilterWidgets(screenSize, context),
        _buildProductsListWidget(context)
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
              _buildFilterButton("SORT"),
              Container(
                color: Theme.of(context).primaryColor,
                width: 2.0,
                height: 24.0,
              ),
              _buildFilterButton("REFINE"),
            ],
          ),
        ),
      ),
    );
  }

  _buildFilterButton(String title) {
    return InkWell(
      onTap: () {
        print(title);
      },
      child: Row(
        children: <Widget>[
          Icon(
            Icons.arrow_drop_down,
            color: Colors.black,
          ),
          SizedBox(
            width: 2.0,
          ),
          Text(title),
        ],
      ),
    );
  }

  _buildProductsListWidget(BuildContext context) {
    return BaseView<ItemModel>(
        onModelReady: (model) => model.listenToItems(),
        builder: (context, model, child) {
          return Expanded(
              child: Container(
                  color: Colors.grey[100],
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: model.items.length,
                      itemBuilder: (context, index) {
                        PurchaseModel purchaseModel =
                            Provider.of<PurchaseModel>(context);
                        SaleModel saleModel = Provider.of<SaleModel>(context);
                        List<Purchase> purchases = purchaseModel
                            .getPurchaseHistoryByItemId(model.items[index].id);
                        model.items[index].totalSales = saleModel
                            .getTotalSaleByItemId(model.items[index].id);
                        model.items[index].totalPurchase = purchaseModel
                            .getTotalPurchaseByItemId(model.items[index].id);
                        purchases.sort(
                            (a, b) => a.purchaseDate.compareTo(b.purchaseDate));
                        double cur = purchases?.last?.items?.first?.salePrice;
                        double org = purchases?.first?.items?.first?.salePrice;
                        double profit =
                            cur - purchases?.first?.items?.first?.purchasePrice;
                        int quantity = (model?.items[index]?.totalPurchase ??
                                    0 + model?.items[index]?.openingStock ??
                                    0) -
                                model?.items[index]?.totalSales ??
                            0;
                        double disco = org - cur;
                        disco = disco * 100;
                        return new PosItem(
                            profit: profit,
                            quantity: quantity,
                            item: model.items[index],
                            // purchase: purchase,
                            currentPrice: cur,
                            originalPrice: org,
                            discount: disco / org,
                            imageUrl: "");
                      })));
        });
  }
}
