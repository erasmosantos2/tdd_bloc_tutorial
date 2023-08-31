import 'dart:convert';

import 'package:tdd_bloc_tutorial/src/authentication/data/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:tdd_bloc_tutorial/core/utils/constants.dart';

import '../../../../core/errors/exceptions.dart';

abstract class AuthenticationRemoteDatasource {
  Future<void> createUser(
      {required String createdAt,
      required String name,
      required String avatar});

  Future<List<UserModel>> getUsers();
}

const kCreateUserEndPoint = '/users';
const kGetEndPoint = '/user';

class AuthenticationRemoteDataSrcImpl
    implements AuthenticationRemoteDatasource {
  const AuthenticationRemoteDataSrcImpl(this._client);

  final http.Client _client;

  @override
  Future<void> createUser(
      {required String createdAt,
      required String name,
      required String avatar}) async {
    final response =
        await _client.post(Uri.parse('$kBaseUrl$kCreateUserEndPoint'),
            body: jsonEncode({
              'createdAt': createdAt,
              'name': name,
              avatar: avatar,
            }));

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw APIException(
          message: response.body, statusCode: response.statusCode);
    }
  }

  @override
  Future<List<UserModel>> getUsers() {
    // TODO: implement getUsers
    throw UnimplementedError();
  }
}
