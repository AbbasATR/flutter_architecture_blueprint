class ApiEndpoints {
  // Authentication Endpoints
  static const requestOtp = '/auth/messaging/otp';
  static const verifyOtp = '/auth/verify';
  static const refreshToken = '/auth/refresh';
  static const logout = '/auth/logout';
  static const userData = '/user-data';

  // Home Endpoints
  static const homeBootstrap = '/home/bootstrap';

  // Users
  static const users = '/users';
  static String userById(int id) => '$users/$id';
  static String updateUser(int id) => '$users/$id';
  static String deleteUser(int id) => '$users/$id';
}
