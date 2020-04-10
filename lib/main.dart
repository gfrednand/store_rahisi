import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/constants/themes.dart';
import 'package:storeRahisi/locator.dart';
import 'package:storeRahisi/managers/dialog_manager.dart';
import 'package:storeRahisi/providers/index.dart';
import 'package:storeRahisi/router.dart';
import 'package:storeRahisi/services/dialog_service.dart';
import 'package:storeRahisi/services/navigation_service.dart';

Future<void> main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  final Firestore firestore = Firestore();
   await firestore.settings(
    cacheSizeBytes: 10000000,
    persistenceEnabled: true,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //         // In this sample app, CatalogModel never changes, so a simple Provider
        // // is sufficient.
        // Provider(create: (context) => CatalogModel()),
        // // CartModel is implemented as a ChangeNotifier, which calls for the use
        // // of ChangeNotifierProvider. Moreover, CartModel depends
        // // on CatalogModel, so a ProxyProvider is needed.
        // ChangeNotifierProxyProvider<CatalogModel, CartModel>(
        //   create: (context) => CartModel(),
        //   update: (context, catalog, cart) {
        //     cart.catalog = catalog;
        //     return cart;
        //   },
        // ),
        // StreamProvider<FirebaseUser>.value(value:  FirebaseAuth.instance.onAuthStateChanged),
        ChangeNotifierProvider(create: (_) => locator<AuthModel>()),
        ChangeNotifierProvider(create: (_) => locator<SupplierModel>()),
        ChangeNotifierProvider(create: (_) => locator<ItemModel>()),
        ChangeNotifierProvider(create: (_) => locator<PurchaseModel>()),
        ChangeNotifierProvider(create: (_) => locator<PaymentModel>()),
        ChangeNotifierProvider(create: (_) => locator<SaleModel>()),
        ChangeNotifierProvider(create: (_) => locator<CartModel>()),

        // ChangeNotifierProxyProvider<ItemModel, CartModel>(
        //   create: (context) => locator<CartModel>(),
        //   update: (context, itemModel, cartModel) {
        //     cartModel.item = itemModel.item;
        //     return cartModel;
        //   },
        // ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Store Rahisi',
        builder: (context, child) => Navigator(
          key: locator<DialogService>().dialogNavigationKey,
          onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => DialogManager(child: child)),
        ),
        theme: lightAppTheme,
        navigatorKey: locator<NavigationService>().navigatorKey,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: Router.generateRoute,
      ),
    );
  }
}
