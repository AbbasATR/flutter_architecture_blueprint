import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/features/auth/data/models/auth_tokens_model.dart';
import 'package:flutter_architecture_blueprint/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/entities/auth_session.dart';
import 'package:flutter_architecture_blueprint/features/home/domain/entities/home_bootstrap.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late MockSecureStorageService mockSecureStorage;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    mockSecureStorage = MockSecureStorageService();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
      secureStorage: mockSecureStorage,
    );
  });

  const tPhoneNumber = '1234567890';
  const tPinCode = '123456';
  const tAccessToken = 'test_access_token';
  const tRefreshToken = 'test_refresh_token';
  const tTokens = AuthTokensModel(
    accessToken: tAccessToken,
    refreshToken: tRefreshToken,
  );
  const tHomeBootstrap = HomeBootstrap(
    categories: [],
    brands: [],
    savedItems: [],
    newListings: [],
  );
  const tAuthSession = AuthSession(
    appBootstrap: tHomeBootstrap,
    accessToken: tAccessToken,
  );

  group('requestOtp', () {
    test(
      'should return Right(unit) when network is connected and call succeeds',
      () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          mockRemoteDataSource.requestOtp(any),
        ).thenAnswer((_) async => const Right(unit));

        // Act
        final result = await repository.requestOtp(tPhoneNumber);

        // Assert
        expect(result, equals(const Right(unit)));
        verify(mockNetworkInfo.isConnected);
        verify(mockRemoteDataSource.requestOtp(tPhoneNumber));
      },
    );

    test('should return NetworkFailure when no internet connection', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.requestOtp(tPhoneNumber);

      // Assert
      expect(result, equals(Left(NetworkFailure())));
      verify(mockNetworkInfo.isConnected);
      verifyNever(mockRemoteDataSource.requestOtp(any));
    });

    test('should return ServerFailure when remote data source fails', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockRemoteDataSource.requestOtp(any),
      ).thenAnswer((_) async => Left(ServerFailure('Server error')));

      // Act
      final result = await repository.requestOtp(tPhoneNumber);

      // Assert
      expect(result, equals(Left(ServerFailure('Server error'))));
      verify(mockRemoteDataSource.requestOtp(tPhoneNumber));
    });
  });

  group('verifyOtp', () {
    test(
      'should return AuthTokens and save refresh token when network is connected and verification succeeds',
      () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          mockRemoteDataSource.verifyOtp(any, any),
        ).thenAnswer((_) async => const Right(tTokens));
        when(
          mockSecureStorage.saveRefreshToken(any),
        ).thenAnswer((_) async => Future.value());

        // Act
        final result = await repository.verifyOtp(tPhoneNumber, tPinCode);

        // Assert
        expect(result, equals(const Right(tTokens)));
        verify(mockNetworkInfo.isConnected);
        verify(mockRemoteDataSource.verifyOtp(tPhoneNumber, tPinCode));
        verify(mockSecureStorage.saveRefreshToken(tRefreshToken));
      },
    );

    test('should return NetworkFailure when no internet connection', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.verifyOtp(tPhoneNumber, tPinCode);

      // Assert
      expect(result, equals(Left(NetworkFailure())));
      verify(mockNetworkInfo.isConnected);
      verifyNever(mockRemoteDataSource.verifyOtp(any, any));
      verifyNever(mockSecureStorage.saveRefreshToken(any));
    });

    test(
      'should return ServerFailure when remote verification fails',
      () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          mockRemoteDataSource.verifyOtp(any, any),
        ).thenAnswer((_) async => Left(ServerFailure('Invalid OTP')));

        // Act
        final result = await repository.verifyOtp(tPhoneNumber, tPinCode);

        // Assert
        expect(result, equals(Left(ServerFailure('Invalid OTP'))));
        verify(mockRemoteDataSource.verifyOtp(tPhoneNumber, tPinCode));
        verifyNever(mockSecureStorage.saveRefreshToken(any));
      },
    );
  });

  group('refreshToken', () {
    test(
      'should return new tokens and update refresh token when network is connected and refresh succeeds',
      () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          mockSecureStorage.getRefreshToken(),
        ).thenAnswer((_) async => tRefreshToken);
        when(
          mockRemoteDataSource.refreshToken(any),
        ).thenAnswer((_) async => const Right(tTokens));
        when(
          mockSecureStorage.saveRefreshToken(any),
        ).thenAnswer((_) async => Future.value());

        // Act
        final result = await repository.refreshToken();

        // Assert
        expect(result, equals(const Right(tTokens)));
        verify(mockNetworkInfo.isConnected);
        verify(mockSecureStorage.getRefreshToken());
        verify(mockRemoteDataSource.refreshToken(tRefreshToken));
        verify(mockSecureStorage.saveRefreshToken(tRefreshToken));
      },
    );

    test(
      'should return UnauthorizedFailure when no refresh token found',
      () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockSecureStorage.getRefreshToken()).thenAnswer((_) async => null);

        // Act
        final result = await repository.refreshToken();

        // Assert
        expect(
          result,
          equals(Left(UnauthorizedFailure('No refresh token found'))),
        );
        verify(mockSecureStorage.getRefreshToken());
        verifyNever(mockRemoteDataSource.refreshToken(any));
      },
    );

    test('should return NetworkFailure when no internet connection', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.refreshToken();

      // Assert
      expect(result, equals(Left(NetworkFailure())));
      verify(mockNetworkInfo.isConnected);
      verifyNever(mockSecureStorage.getRefreshToken());
    });

    test('should return ServerFailure when token refresh fails', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockSecureStorage.getRefreshToken(),
      ).thenAnswer((_) async => tRefreshToken);
      when(
        mockRemoteDataSource.refreshToken(any),
      ).thenAnswer((_) async => Left(ServerFailure('Token expired')));

      // Act
      final result = await repository.refreshToken();

      // Assert
      expect(result, equals(Left(ServerFailure('Token expired'))));
      verify(mockRemoteDataSource.refreshToken(tRefreshToken));
    });
  });

  group('checkAuthStatus', () {
    test(
      'should return AuthSession when network is connected and auth check succeeds',
      () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          mockSecureStorage.getRefreshToken(),
        ).thenAnswer((_) async => tRefreshToken);
        when(
          mockRemoteDataSource.refreshToken(any),
        ).thenAnswer((_) async => const Right(tTokens));
        when(
          mockSecureStorage.saveRefreshToken(any),
        ).thenAnswer((_) async => Future.value());
        when(
          mockRemoteDataSource.appStart(any),
        ).thenAnswer((_) async => const Right(tHomeBootstrap));

        // Act
        final result = await repository.checkAuthStatus();

        // Assert
        expect(result, equals(const Right(tAuthSession)));
        verify(mockNetworkInfo.isConnected);
        verify(mockSecureStorage.getRefreshToken());
        verify(mockRemoteDataSource.refreshToken(tRefreshToken));
        verify(mockSecureStorage.saveRefreshToken(tRefreshToken));
        verify(mockRemoteDataSource.appStart(tAccessToken));
      },
    );

    test(
      'should return UnauthorizedFailure when no refresh token found',
      () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockSecureStorage.getRefreshToken()).thenAnswer((_) async => null);

        // Act
        final result = await repository.checkAuthStatus();

        // Assert
        expect(
          result,
          equals(Left(UnauthorizedFailure('No refresh token found'))),
        );
        verify(mockSecureStorage.getRefreshToken());
        verifyNever(mockRemoteDataSource.refreshToken(any));
        verifyNever(mockRemoteDataSource.appStart(any));
      },
    );

    test('should return NetworkFailure when no internet connection', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.checkAuthStatus();

      // Assert
      expect(result, equals(Left(NetworkFailure())));
      verify(mockNetworkInfo.isConnected);
      verifyNever(mockSecureStorage.getRefreshToken());
    });

    test('should return failure when token refresh fails', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockSecureStorage.getRefreshToken(),
      ).thenAnswer((_) async => tRefreshToken);
      when(
        mockRemoteDataSource.refreshToken(any),
      ).thenAnswer((_) async => Left(ServerFailure('Token invalid')));

      // Act
      final result = await repository.checkAuthStatus();

      // Assert
      expect(result, equals(Left(ServerFailure('Token invalid'))));
      verify(mockRemoteDataSource.refreshToken(tRefreshToken));
      verifyNever(mockRemoteDataSource.appStart(any));
    });

    test('should return failure when appStart fails', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockSecureStorage.getRefreshToken(),
      ).thenAnswer((_) async => tRefreshToken);
      when(
        mockRemoteDataSource.refreshToken(any),
      ).thenAnswer((_) async => const Right(tTokens));
      when(
        mockSecureStorage.saveRefreshToken(any),
      ).thenAnswer((_) async => Future.value());
      when(
        mockRemoteDataSource.appStart(any),
      ).thenAnswer((_) async => Left(ServerFailure('Bootstrap failed')));

      // Act
      final result = await repository.checkAuthStatus();

      // Assert
      expect(result, equals(Left(ServerFailure('Bootstrap failed'))));
      verify(mockRemoteDataSource.appStart(tAccessToken));
    });
  });

  group('getAppBootstrap', () {
    test(
      'should return HomeBootstrap when network is connected and call succeeds',
      () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          mockRemoteDataSource.appStart(any),
        ).thenAnswer((_) async => const Right(tHomeBootstrap));

        // Act
        final result = await repository.getAppBootstrap(tAccessToken);

        // Assert
        expect(result, equals(const Right(tHomeBootstrap)));
        verify(mockNetworkInfo.isConnected);
        verify(mockRemoteDataSource.appStart(tAccessToken));
      },
    );

    test('should return NetworkFailure when no internet connection', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.getAppBootstrap(tAccessToken);

      // Assert
      expect(result, equals(Left(NetworkFailure())));
      verify(mockNetworkInfo.isConnected);
      verifyNever(mockRemoteDataSource.appStart(any));
    });

    test('should return ServerFailure when remote call fails', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockRemoteDataSource.appStart(any),
      ).thenAnswer((_) async => Left(ServerFailure('Failed to load')));

      // Act
      final result = await repository.getAppBootstrap(tAccessToken);

      // Assert
      expect(result, equals(Left(ServerFailure('Failed to load'))));
      verify(mockRemoteDataSource.appStart(tAccessToken));
    });
  });

  group('signOut', () {
    test(
      'should return Right(unit) and clear tokens when network is connected and sign out succeeds',
      () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          mockRemoteDataSource.signOut(),
        ).thenAnswer((_) async => const Right(unit));
        when(
          mockSecureStorage.deleteAllTokens(),
        ).thenAnswer((_) async => Future.value());

        // Act
        final result = await repository.signOut();

        // Assert
        expect(result, equals(const Right(unit)));
        verify(mockNetworkInfo.isConnected);
        verify(mockRemoteDataSource.signOut());
        verify(mockSecureStorage.deleteAllTokens());
      },
    );

    test(
      'should clear local tokens and return NetworkFailure when offline',
      () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(
          mockSecureStorage.deleteAllTokens(),
        ).thenAnswer((_) async => Future.value());

        // Act
        final result = await repository.signOut();

        // Assert
        expect(result, equals(Left(NetworkFailure())));
        verify(mockNetworkInfo.isConnected);
        verify(mockSecureStorage.deleteAllTokens());
        verifyNever(mockRemoteDataSource.signOut());
      },
    );

    test(
      'should still clear local tokens when remote sign out fails',
      () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          mockRemoteDataSource.signOut(),
        ).thenAnswer((_) async => Left(ServerFailure('Sign out failed')));
        when(
          mockSecureStorage.deleteAllTokens(),
        ).thenAnswer((_) async => Future.value());

        // Act
        final result = await repository.signOut();

        // Assert
        expect(result, equals(Left(ServerFailure('Sign out failed'))));
        verify(mockRemoteDataSource.signOut());
        verifyNever(
          mockSecureStorage.deleteAllTokens(),
        ); // Only called on success
      },
    );
  });
}
