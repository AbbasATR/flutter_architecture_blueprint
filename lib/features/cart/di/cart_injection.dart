import 'package:get_it/get_it.dart';
import 'package:flutter_architecture_blueprint/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:flutter_architecture_blueprint/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/repositories/cart_repository.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/usecases/add_cart_item.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/usecases/clear_cart.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/usecases/delete_cart_item.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/usecases/get_cart_item_by_id.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/usecases/get_cart_items.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/usecases/update_cart_item.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initCartDependencies(GetIt sl) async {
  sl.registerLazySingleton(
    () => CartBloc(
      getCartItems: sl(),
      addCartItem: sl(),
      updateCartItem: sl(),
      deleteCartItem: sl(),
      clearCart: sl(),
      getCartItemById: sl(),
    ),
  );

  sl.registerFactory(() => GetCartItems(sl()));
  sl.registerFactory(() => AddCartItem(sl()));
  sl.registerFactory(() => UpdateCartItem(sl()));
  sl.registerFactory(() => DeleteCartItem(sl()));
  sl.registerFactory(() => ClearCart(sl()));
  sl.registerFactory(() => GetCartItemById(sl()));

  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(localDataSource: sl()),
  );

  sl.registerLazySingleton<CartLocalDataSource>(
    () => CartLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
  );
}
