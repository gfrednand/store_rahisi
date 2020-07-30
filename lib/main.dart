import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/constants/themes.dart';
import 'package:storeRahisi/locator.dart';
import 'package:storeRahisi/managers/dialog_manager.dart';
import 'package:storeRahisi/providers/index.dart';
import 'package:storeRahisi/router.dart';

Future<void> main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => locator<AuthModel>()),
        ChangeNotifierProvider(
            create: (_) => locator<SaleModel>()..listenToSales()),
        ChangeNotifierProvider(
            create: (_) => locator<SettingsModel>()..fetchLocale()),
        ChangeNotifierProvider(
            create: (_) => locator<ItemModel>()
              ..listenToItems()
              ..listenToCategories()),
        ChangeNotifierProvider(
            create: (_) => locator<ClientModel>()..listenToClients()),
        ChangeNotifierProvider(
            create: (_) => locator<PaymentModel>()..listenToPayments()),
        ChangeNotifierProvider(create: (_) => locator<CartModel>()),
        ChangeNotifierProvider(create: (_) => locator<ExpenseModel>()),
        ChangeNotifierProxyProvider<ItemModel, PurchaseModel>(
          create: (_) => locator<PurchaseModel>(),
          update: (_, itemModel, purchaseModel) => purchaseModel
            ..listenToPurchases()
            ..updateItemModel(itemModel),
        ),
      ],
      builder: (ctx, settings) {
        final settings = ctx.watch<SettingsModel>();
        return GestureDetector(
          onTap: () {
            // WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();

            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              currentFocus.focusedChild.unfocus();
            }
          },
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: settings.appLocal,
            supportedLocales: [
              Locale('en', 'US'),
              Locale('sw', 'TZ'),
            ],
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            // title: AppLocalizations.of(context).translate('appTitle'),
            builder: (context, child) => Navigator(
              key: settings.dialogNavigationKey,
              onGenerateRoute: (settings) => MaterialPageRoute(
                  builder: (context) => DialogManager(child: child)),
            ),
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settings.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
            navigatorKey: settings.navigatorKey,
            initialRoute: AppRoutes.splash,
            onGenerateRoute: Router.generateRoute,
          ),
        );
      },
    );
  }
}
