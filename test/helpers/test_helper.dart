import 'package:mockito/annotations.dart';
import 'package:flutter_architecture_blueprint/core/network/dio_client.dart';
import 'package:flutter_architecture_blueprint/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_architecture_blueprint/features/home/data/datasources/home_remote_data_source.dart';
import 'package:flutter_architecture_blueprint/features/home/domain/usecases/get_home_bootstrap.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/usecases/request_otp.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/usecases/verify_otp.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/usecases/get_app_bootstrap.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/usecases/check_auth_status.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/usecases/sign_out.dart';
import 'package:flutter_architecture_blueprint/features/notifications/domain/usecases/get_notifications.dart';
import 'package:flutter_architecture_blueprint/features/notifications/domain/usecases/get_unread_count.dart';
import 'package:flutter_architecture_blueprint/features/notifications/domain/usecases/mark_as_read.dart';
import 'package:flutter_architecture_blueprint/features/notifications/domain/usecases/mark_all_as_read.dart';
import 'package:flutter_architecture_blueprint/features/address/domain/usecases/get_addresses.dart';
import 'package:flutter_architecture_blueprint/features/address/domain/usecases/get_selected_address.dart';
import 'package:flutter_architecture_blueprint/features/address/domain/usecases/select_address.dart';
import 'package:flutter_architecture_blueprint/features/profile/domain/usecases/update_user.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/usecases/get_items_by_supplier_id.dart';
import 'package:flutter_architecture_blueprint/features/search/domain/usecases/search_items.dart';
import 'package:flutter_architecture_blueprint/features/search/domain/usecases/search_suppliers.dart';
import 'package:flutter_architecture_blueprint/features/supplier/domain/usecases/get_suppliers_by_business_type.dart';
import 'package:flutter_architecture_blueprint/shared/theme/domain/repositories/theme_mode_repository.dart';
import 'package:flutter_architecture_blueprint/core/network/network_info.dart';
import 'package:flutter_architecture_blueprint/core/services/secure_storage_service.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_architecture_blueprint/features/home/domain/repositories/home_repository.dart';
import 'package:flutter_architecture_blueprint/features/notifications/domain/repositories/notification_repository.dart';
import 'package:flutter_architecture_blueprint/features/address/domain/repositories/address_repository.dart';
import 'package:flutter_architecture_blueprint/features/profile/domain/repositories/user_repository.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/repositories/cart_repository.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/repositories/item_repository.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/repositories/order_repository.dart';
import 'package:flutter_architecture_blueprint/features/search/domain/repositories/search_repository.dart';
import 'package:flutter_architecture_blueprint/features/supplier/domain/repositories/supplier_repository.dart';
import 'package:flutter_architecture_blueprint/features/notifications/data/datasources/notification_local_data_source.dart';
import 'package:flutter_architecture_blueprint/features/address/data/datasources/address_local_data_source.dart';
import 'package:flutter_architecture_blueprint/features/profile/data/datasources/user_remote_datasource.dart';
import 'package:flutter_architecture_blueprint/shared/theme/data/datasources/theme_mode_local_data_source.dart';
import 'package:flutter_architecture_blueprint/shared/localization/data/datasources/locale_local_data_source.dart';
import 'package:flutter_architecture_blueprint/shared/localization/domain/repositories/locale_repository.dart';

// This file is used to generate mock classes for testing
// Run: dart run build_runner build --delete-conflicting-outputs
// to generate the mocks

@GenerateMocks([
  // Core
  DioClient,
  NetworkInfo,
  SecureStorageService,
  // Data Sources
  AuthRemoteDataSource,
  HomeRemoteDataSource,
  NotificationLocalDataSource,
  AddressLocalDataSource,
  UserRemoteDataSource,
  ThemeModeLocalDataSource,
  LocaleLocalDataSource,
  // Repositories
  AuthRepository,
  HomeRepository,
  NotificationRepository,
  AddressRepository,
  UserRepository,
  CartRepository,
  ItemRepository,
  OrderRepository,
  SearchRepository,
  SupplierRepository,
  ThemeModeRepository,
  LocaleRepository,
  // Home Use Cases
  GetHomeBootstrapUseCase,
  // Auth Use Cases
  RequestOtp,
  VerifyOtp,
  GetAppBootstrap,
  CheckAuthStatusUseCase,
  SignOutUseCase,
  // Notification Use Cases
  GetNotifications,
  GetUnreadCount,
  MarkAsRead,
  MarkAllAsRead,
  // Address Use Cases
  GetAddresses,
  GetSelectedAddress,
  SelectAddress,
  // User Use Cases
  UpdateUser,
  // Item Use Cases
  GetItemsBySupplierId,
  // Search Use Cases
  SearchItems,
  SearchSuppliers,
  // Supplier Use Cases
  GetSuppliersByBusinessType,
])
void main() {}
