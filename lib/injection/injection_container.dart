import 'package:get_it/get_it.dart';
import 'package:flutter_architecture_blueprint/core/constants/app_assets.dart';
import 'package:flutter_architecture_blueprint/core/network/dio_client.dart';
import 'package:flutter_architecture_blueprint/core/network/network_info.dart';
import 'package:flutter_architecture_blueprint/features/address/di/address_injection.dart';
import 'package:flutter_architecture_blueprint/features/auth/di/auth_injection.dart';
import 'package:flutter_architecture_blueprint/features/cart/di/cart_injection.dart';
import 'package:flutter_architecture_blueprint/features/home/di/home_injection.dart';
import 'package:flutter_architecture_blueprint/features/item/di/item_injection.dart';
import 'package:flutter_architecture_blueprint/features/notifications/di/notification_injection.dart';
import 'package:flutter_architecture_blueprint/features/orders/di/order_injection.dart';
import 'package:flutter_architecture_blueprint/features/search/di/search_injection.dart';
import 'package:flutter_architecture_blueprint/features/supplier/di/supplier_injection.dart';
import 'package:flutter_architecture_blueprint/shared/layout/shell/state/bottom_nav_cubit.dart';
import 'package:flutter_architecture_blueprint/shared/localization/localization_injection.dart';
import 'package:flutter_architecture_blueprint/shared/services/file_uploader.dart';
import 'package:flutter_architecture_blueprint/shared/services/navigation_service.dart';
import 'package:flutter_architecture_blueprint/shared/theme/theme_injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final dioClient = await DioClient.create();

  sl.registerLazySingleton<DioClient>(() => dioClient);
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton(() => NavigationService());
  sl.registerLazySingleton(() => FileUploader(sl()));
  sl.registerLazySingleton(() => AppAssets());
  sl.registerFactory<BottomNavCubit>(() => BottomNavCubit());

  await initAuthFeature(sl);
  await initTheme(sl);
  await initLocalization(sl);
  await initAddressFeature(sl);
  await initHomeFeature(sl);
  await initNotificationsFeature(sl);
  await initSearchDependencies();
  await initSupplierDependencies(sl);
  await initItemDependencies(sl);
  await initCartDependencies(sl);
  await initOrderInjection(sl);
}
