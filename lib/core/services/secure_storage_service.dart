import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SecureStorageService {
  Future<void> saveRefreshToken(String token);
  Future<String?> getRefreshToken();
  Future<void> deleteRefreshToken();
  Future<void> deleteAllTokens();
}

class SecureStorageServiceImpl implements SecureStorageService {
  final FlutterSecureStorage secureStorage;

  static const String _refreshTokenKey = 'refresh_token';

  SecureStorageServiceImpl({required this.secureStorage});

  @override
  Future<void> saveRefreshToken(String token) async {
    await secureStorage.write(key: _refreshTokenKey, value: token);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await secureStorage.read(key: _refreshTokenKey);
  }

  @override
  Future<void> deleteRefreshToken() async {
    await secureStorage.delete(key: _refreshTokenKey);
  }

  @override
  Future<void> deleteAllTokens() async {
    await secureStorage.deleteAll();
  }
}
