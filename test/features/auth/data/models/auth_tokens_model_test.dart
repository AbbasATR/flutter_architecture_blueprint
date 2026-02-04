import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_architecture_blueprint/features/auth/data/models/auth_tokens_model.dart';
import '../../../../helpers/json_reader.dart';

void main() {
  const tAuthTokensModel = AuthTokensModel(
    accessToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.test_access_token',
    refreshToken: 'test_refresh_token_12345',
  );

  group('AuthTokensModel', () {
    test('should be a subclass of AuthTokens entity', () {
      expect(tAuthTokensModel, isA<AuthTokensModel>());
    });

    group('fromJson', () {
      test('should return a valid model from JSON with camelCase keys', () {
        // arrange
        final jsonMap =
            json.decode(fixture('auth/verify_otp_response.json'))
                as Map<String, dynamic>;

        // act
        final result = AuthTokensModel.fromJson(jsonMap);

        // assert
        expect(result, isA<AuthTokensModel>());
        expect(result.accessToken, isNotEmpty);
        expect(result.refreshToken, isNotEmpty);
      });

      test('should return a valid model from JSON with snake_case keys', () {
        // arrange
        final jsonMap = {
          'access_token': 'test_access_token',
          'refresh_token': 'test_refresh_token',
        };

        // act
        final result = AuthTokensModel.fromJson(jsonMap);

        // assert
        expect(result, isA<AuthTokensModel>());
        expect(result.accessToken, equals('test_access_token'));
        expect(result.refreshToken, equals('test_refresh_token'));
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        // act
        final result = tAuthTokensModel.toJson();

        // assert
        final expectedMap = {
          'accessToken':
              'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.test_access_token',
          'refreshToken': 'test_refresh_token_12345',
        };
        expect(result, equals(expectedMap));
      });
    });
  });
}
