import 'package:flutter/material.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/models/item.dart';
import 'package:storeRahisi/models/supplier.dart';
import 'package:storeRahisi/pages/home_page.dart';
import 'package:storeRahisi/pages/item/item_detail.dart';
import 'package:storeRahisi/pages/layout_page.dart';
import 'package:storeRahisi/pages/login_page.dart';
import 'package:storeRahisi/pages/register_page.dart';
import 'package:storeRahisi/pages/splash_page.dart';
import 'package:storeRahisi/pages/supplier/supplier_detail.dart';
import 'package:storeRahisi/pages/supplier/supplier_list.dart';

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
      case AppRoutes.supplier:
        return MaterialPageRoute(builder: (_) => SupplierList());
        break;
      case AppRoutes.supplier_detail:
        var supplier = settings.arguments as Supplier;
        return MaterialPageRoute(
            builder: (_) => SupplierDetail(
                  supplier: supplier,
                ));
        break;
      case AppRoutes.item_detail:
        var item = settings.arguments as Item;
        return MaterialPageRoute(
            builder: (_) => ItemDetail(
                  item: item,
                ));
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
