import 'package:flutter/material.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/pages/client/client_form.dart';
import 'package:storeRahisi/pages/expense/expense_detail.dart';
import 'package:storeRahisi/pages/expense/expense_list.dart';

import 'package:storeRahisi/pages/home_page.dart';
import 'package:storeRahisi/pages/item/category_form.dart';
import 'package:storeRahisi/pages/item/item_detail.dart';
import 'package:storeRahisi/pages/item/item_form.dart';
import 'package:storeRahisi/pages/layout_page.dart';
import 'package:storeRahisi/pages/login_page.dart';
import 'package:storeRahisi/pages/pos/Payment_Screen.dart';
import 'package:storeRahisi/pages/pos/cart_page.dart';
import 'package:storeRahisi/pages/pos/cart_items.dart';
import 'package:storeRahisi/pages/pos/checkout_screen.dart';
import 'package:storeRahisi/pages/pos/item_screen.dart';
import 'package:storeRahisi/pages/purchase/add_item_form.dart';
import 'package:storeRahisi/pages/purchase/purchase_detail.dart';
import 'package:storeRahisi/pages/purchase/purchase_add.dart';
import 'package:storeRahisi/pages/register_page.dart';
import 'package:storeRahisi/pages/report/index.dart';
import 'package:storeRahisi/pages/sale/sale_detail.dart';
import 'package:storeRahisi/pages/settings/help_screen.dart';
import 'package:storeRahisi/pages/settings/settings_page.dart';
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
      case AppRoutes.client_form:
        var args = settings.arguments as Map<String, dynamic>;
        return slideUpTransitionpageRouteBuilder(ClientForm(
          client: args['client'],
          title: args['title'],
          clientType: args['clientType'],
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
      case AppRoutes.item_form:
        var args = settings.arguments as Map<String, dynamic>;
        return slideUpTransitionpageRouteBuilder(ItemForm(
          title: args['title'],
          item: args['item'],
        ));

        break;
      case AppRoutes.item_purchase_form:
        var args = settings.arguments as Map<String, dynamic>;
        return slideUpTransitionpageRouteBuilder(ItemPurchaseForm(
          title: args['title'],
          purchaseModel: args['purchaseModel'],
          items: args['items'],
        ));
        break;
      case AppRoutes.category_form:
        var args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => CategoryForm(
                  title: args['title'],
                  category: args['category'],
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
      case AppRoutes.expense_detail:
        var args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => ExpenseDetail(
                  expenseModel: args['expenseModel'],
                  expense: args['expense'],
                ));
        break;
      case AppRoutes.purchase_add:
        var args = settings.arguments as Map<String, dynamic>;
        return slideUpTransitionpageRouteBuilder(PurchaseAdd(
          title: args['title'],
          purchase: args['purchase'],
        ));
        break;
      case AppRoutes.cart_items:
        // var title = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => CartItems());
        break;
      case AppRoutes.item_report:
        return MaterialPageRoute(builder: (_) => ItemReport());
        break;
      case AppRoutes.purchase_report:
        return MaterialPageRoute(builder: (_) => PurchaseReport());
        break;
      case AppRoutes.sale_report:
        return MaterialPageRoute(builder: (_) => SaleReport());
        break;
      case AppRoutes.profit_report:
        return MaterialPageRoute(builder: (_) => ProfitReport());
        break;
      case AppRoutes.transaction_report:
        return MaterialPageRoute(builder: (_) => TransactionReport());
        break;
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => SettingsPage());
        break;
      case AppRoutes.checkout:
        var clients = settings.arguments as List<Client>;
        return MaterialPageRoute(
            builder: (_) => CheckoutPage(
                  clients: clients,
                ));
        break;
      case AppRoutes.payment:
        // var clients = settings.arguments as List<Client>;
        return MaterialPageRoute(builder: (_) => PaymentPage());
        break;
      case AppRoutes.help:
        return MaterialPageRoute(builder: (_) => SettingsPage());
        break;
      case AppRoutes.expense:
        return MaterialPageRoute(builder: (_) => ExpenseList());
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

  static PageRouteBuilder slideUpTransitionpageRouteBuilder(Widget page) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.fastOutSlowIn;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
  }
}
