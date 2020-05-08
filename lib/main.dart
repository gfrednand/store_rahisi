import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/constants/themes.dart';
import 'package:storeRahisi/locator.dart';
import 'package:storeRahisi/managers/dialog_manager.dart';
import 'package:storeRahisi/providers/app_language.dart';
import 'package:storeRahisi/providers/index.dart';
import 'package:storeRahisi/router.dart';
import 'package:storeRahisi/services/dialog_service.dart';
import 'package:storeRahisi/services/navigation_service.dart';

Future<void> main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  // final Firestore firestore = Firestore();
  //  await firestore.settings(
  //   cacheSizeBytes: 10000000,
  //   persistenceEnabled: true,
  // );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // StreamProvider<FirebaseUser>.value(value:  FirebaseAuth.instance.onAuthStateChanged),
        ChangeNotifierProvider(create: (_) => locator<AuthModel>()),
        ChangeNotifierProvider(create: (_) => locator<SettingsModel>()),
        ChangeNotifierProvider(create: (_) => locator<PurchaseModel>()),
        ChangeNotifierProvider.value(value: locator<ItemModel>()),
        ChangeNotifierProvider.value(value: locator<ClientModel>()),
        ChangeNotifierProvider.value(value: locator<SaleModel>()),
        ChangeNotifierProvider(create: (_) => locator<PaymentModel>()),
        ChangeNotifierProvider(create: (_) => locator<CartModel>()),
        ChangeNotifierProvider(create: (_) => locator<ExpenseModel>()),
      ],
      child: Consumer<SettingsModel>(
        builder: (context, settings, _)  {
          return MaterialApp(
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
          );
        },
      ),
    );
  }
}
