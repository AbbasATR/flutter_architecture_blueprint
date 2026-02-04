class BaseUrl {
  static const String baseUrl = 'https://baseUrl.com:10000/api';
  static const String apiVersion = '';

  static String get fullUrl => '$baseUrl/$apiVersion';
}
