import 'package:get_it/get_it.dart';
import 'package:storeRahisi/providers/auth_model.dart';
import 'package:storeRahisi/providers/fab_model.dart';
import 'package:storeRahisi/providers/item_model.dart';
import 'package:storeRahisi/providers/purchase_model.dart';
import 'package:storeRahisi/providers/supplier_model.dart';
import 'package:storeRahisi/services/api.dart';
import 'package:storeRahisi/services/auth_service.dart';
import 'package:storeRahisi/services/dialog_service.dart';
import 'package:storeRahisi/services/firestore_service.dart';
import 'package:storeRahisi/services/navigation_service.dart';
import 'package:storeRahisi/services/shared_pref_util.dart';

GetIt locator = GetIt.I;

void setupLocator() {
  // Services

  // [registerSingleton] registers an instance of an object with the type or a derived-type
  // of the one you pass as a generic Parameter

  //  [registerLazySingleton] gets passed a factory function that returns the type or a derived-type
  // of the one you pass as a generic Parameter
  // locator.get<AuthModel>.get() will call the registered factory function on the first call and store
  // the returned instance. On any subsequent calls, the stored instance is returned
  locator.registerLazySingleton(() => Api());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => FirestoreService());
  locator.registerLazySingleton(() => AuthModel());
  locator.registerLazySingleton<SharedPrefsUtil>(() => SharedPrefsUtil());
  // locator.registerLazySingleton<BillDbProvider>(() => BillDbProvider());
  // locator.registerLazySingleton<SharedPrefsUtil>(() => SharedPrefsUtil());

  locator.registerLazySingleton(() => SupplierModel());
  locator.registerLazySingleton(() => ItemModel());
  locator.registerLazySingleton(() => PurchaseModel());
  locator.registerLazySingleton(() => FabModel());
}
