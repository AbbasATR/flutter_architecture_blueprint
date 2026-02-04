import 'package:flutter_architecture_blueprint/features/profile/data/models/user_model.dart';
import 'package:flutter_architecture_blueprint/features/profile/domain/entities/user.dart';

abstract class UserRemoteDataSource {
  /// Calls the API endpoint to update user information
  ///
  /// Throws a [ServerException] for all error codes
  Future<UserModel> updateUser(User user);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  // final http.Client client;
  // final String baseUrl;

  // UserRemoteDataSourceImpl({
  //   required this.client,
  //   required this.baseUrl,
  // });

  @override
  Future<UserModel> updateUser(User user) async {
    // final userModel = UserModel.fromEntity(user);
    // final response = await client.put(
    //   Uri.parse('$baseUrl/users/${user.id}'),
    //   headers: {'Content-Type': 'application/json'},
    //   body: json.encode(userModel.toJson()),
    // );
    //
    // if (response.statusCode == 200) {
    //   return UserModel.fromJson(json.decode(response.body));
    // } else {
    //   throw ServerException();
    // }
    throw UnimplementedError();
  }
}
