import 'package:tdd_bloc_tutorial/src/authentication/data/models/user_model.dart';

abstract class AuthenticationRemoteDatasource {
  Future<void> createUser(
      {required String createdAt,
      required String name,
      required String avatar});

  Future<List<UserModel>> getUsers();
}
