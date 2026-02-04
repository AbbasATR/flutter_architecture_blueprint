import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_architecture_blueprint/core/services/secure_storage_service.dart';
import 'package:flutter_architecture_blueprint/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_architecture_blueprint/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/usecases/check_auth_status.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/usecases/get_app_bootstrap.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/usecases/refresh_token.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/usecases/request_otp.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/usecases/sign_out.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/usecases/verify_otp.dart';
import 'package:flutter_architecture_blueprint/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:flutter_architecture_blueprint/features/auth/presentation/bloc/login_bloc/login_bloc.dart';
import 'package:flutter_architecture_blueprint/features/auth/presentation/bloc/logout_bloc/logout_bloc.dart';
import 'package:get_it/get_it.dart';

Future<void> initAuthFeature(GetIt sl) async {
  // Blocs
  sl.registerFactory(() => AuthBloc(sl()));
  sl.registerFactory(
    () => LoginBloc(
      requestOtpUseCase: sl(),
      verifyOtpUseCase: sl(),
      getAppBootstrapUseCase: sl(),
    ),
  );
  sl.registerFactory(() => LogoutBloc(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
      secureStorage: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteImplWithDio(sl()),
  );

  // Secure Storage
  sl.registerLazySingleton<SecureStorageService>(
    () => SecureStorageServiceImpl(secureStorage: sl()),
  );

  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // Use Cases
  sl.registerFactory(() => CheckAuthStatusUseCase(sl()));
  sl.registerFactory(() => GetAppBootstrap(sl()));
  sl.registerFactory(() => RequestOtp(sl()));
  sl.registerFactory(() => VerifyOtp(sl()));
  sl.registerFactory(() => RefreshToken(sl()));
  sl.registerFactory(() => SignOutUseCase(sl()));
}
