import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/pages/base_view.dart';
import 'package:storeRahisi/pages/pos/pos_item.dart';
import 'package:storeRahisi/pages/sale/sale_list.dart';
import 'package:storeRahisi/providers/index.dart';
import 'package:storeRahisi/widgets/total_bar.dart';

class PosItemList extends StatefulWidget {
  @override
  _PosItemListState createState() => _PosItemListState();
}

class _PosItemListState extends State<PosItemList> {
  bool itemSelected = true;
  int selectedIndex = 0;
  bool isSearch = false;
  final editingController = TextEditingController();
  var allItems = List<Item>();
  String filter = '';
  @override
  void initState() {
    editingController.addListener(() {
      filter = editingController.text.toLowerCase();
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Size screenSize = MediaQuery.of(context).size;

    return _buildProductsListWidget(context);
  }

  _buildFilterWidgets() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: editingController,
        decoration: InputDecoration(
            labelText: AppLocalizations.of(context).translate('search'),
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder()),
      ),
    );
  }

  _buildProductsListWidget(BuildContext context) {
    CartModel cartModel = Provider.of<CartModel>(context);
    List<Item> items = context.select((ItemModel model) => model.items);

    allItems = allItems.length > 0 ? allItems : items;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildFilterWidgets(),
        Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                PurchaseModel purchaseModel =
                    Provider.of<PurchaseModel>(context);
                SaleModel saleModel = Provider.of<SaleModel>(context);
                List<Purchase> purchases =
                    purchaseModel.getPurchaseHistoryByItemId(items[index].id);
                items[index].totalSales =
                    saleModel.getTotalSaleByItemId(items[index].id);
                items[index].totalPurchase =
                    purchaseModel.getTotalPurchaseByItemId(items[index].id);
                purchases
                    .sort((a, b) => a.purchaseDate.compareTo(b.purchaseDate));
                double cur = purchases != null && purchases.length > 0
                    ? purchases.last?.items?.first?.salePrice
                    : 0;
                double org = purchases != null && purchases.length > 0
                    ? purchases?.first?.items?.first?.salePrice
                    : 0;
                var t = purchases != null && purchases.length > 0
                    ? purchases?.first?.items?.first?.purchasePrice
                    : 0;
                double profit = cur - t;
                int quantity = (items[index]?.totalPurchase ??
                            0 + items[index]?.openingStock ??
                            0) -
                        items[index]?.totalSales ??
                    0;
                double disco = org - cur;
                disco = disco * 100;
                Cart cart = cartModel.getCartItemById(items[index].id);

                // print(cart.toString());
                return filter == null || filter == ''
                    ? new PosItem(
                        profit: profit,
                        quantity: quantity,
                        item: items[index],
                        initialCount: cart?.quantity,
                        currentPrice: cur,
                        originalPrice: org,
                        discount: disco / org,
                        imageUrl: "")
                    : items[index]
                            .name
                            .toLowerCase()
                            .contains(filter.toLowerCase())
                        ? new PosItem(
                            profit: profit,
                            quantity: quantity,
                            item: items[index],
                            // purchase: purchase,
                            initialCount: cart?.quantity,
                            currentPrice: cur,
                            originalPrice: org,
                            discount: disco / org,
                            imageUrl: "")
                        : new Container();
              }),
        ),
        //  Expanded(child: SizedBox()),
        // // const Divider(height: 1.0, color: Colors.grey),
        cartModel.carts.length > 0
            ? TotalBar(
                cartModel: cartModel,
                route: AppRoutes.checkout,
                subtitle: 'Proceeds to Checkout',
              )
            : Container(),
      ],
    );
  }
}
