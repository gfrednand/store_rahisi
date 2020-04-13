import 'package:flutter/material.dart';
import 'package:storeRahisi/constants/routes.dart';

import 'package:storeRahisi/pages/home_page.dart';
import 'package:storeRahisi/pages/item/item_detail.dart';
import 'package:storeRahisi/pages/layout_page.dart';
import 'package:storeRahisi/pages/login_page.dart';
import 'package:storeRahisi/pages/pos/cart_items.dart';
import 'package:storeRahisi/pages/purchase/purchase_detail.dart';
import 'package:storeRahisi/pages/purchase/purchase_add.dart';
import 'package:storeRahisi/pages/register_page.dart';
import 'package:storeRahisi/pages/sale/sale_detail.dart';
import 'package:storeRahisi/pages/splash_page.dart';
import 'package:storeRahisi/pages/client/client_detail.dart';
import 'package:storeRahisi/pages/client/client_list.dart';


class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.layout:
        return MaterialPageRoute(
          builder: (_) => LayoutPage(),
        );
        break;
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => HomePage(),
          settings: settings,
        );
        break;
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => SplashPage());
        break;
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => LoginPage());
        break;
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => RegisterPage());
        break;
      case AppRoutes.client:
        return MaterialPageRoute(builder: (_) => ClientList());
        break;
      case AppRoutes.client_detail:
        var args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => ClientDetail(
                  client: args['client'],
                  clientModel: args['clientModel'],
                ));
        break;
      case AppRoutes.item_detail:
        var args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => ItemDetail(
                  itemModel: args['itemModel'],
                  item: args['item'],
                ));
        break;
      case AppRoutes.sale_detail:
        var args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => SaleDetail(
                  saleModel: args['saleModel'],
                  sale: args['sale'],
                ));
        break;
      case AppRoutes.purchase_detail:
        var args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => PurchaseDetail(
                  purchaseModel: args['purchaseModel'],
                  purchase: args['purchase'],
                ));
        break;
      case AppRoutes.purchase_add:
        var title = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => PurchaseAdd(
                  title: title,
                ));
        break;
      case AppRoutes.cart_items:
        // var title = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => CartItems());
        break;
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  appBar: AppBar(
                    leading: BackButton(),
                  ),
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
