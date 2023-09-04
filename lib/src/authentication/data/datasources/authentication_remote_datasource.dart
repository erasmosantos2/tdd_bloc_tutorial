import 'dart:convert';

import 'package:tdd_bloc_tutorial/core/utils/typedef.dart';
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

const kCreateUserEndPoint = '/test-tdd-api/users';
const kGetEndPoint = '/test-tdd-api/users';

class AuthenticationRemoteDataSrcImpl
    implements AuthenticationRemoteDatasource {
  const AuthenticationRemoteDataSrcImpl(this._client);

  final http.Client _client;

  @override
  Future<void> createUser(
      {required String createdAt,
      required String name,
      required String avatar}) async {
    try {
      final response =
          await _client.post(Uri.https(kBaseUrl, kCreateUserEndPoint),
              body: jsonEncode({
                'createdAt': createdAt,
                'name': name,
                avatar: avatar,
              }),
              headers: {'Content-Type': 'application/json'});

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw APIException(
            message: response.body, statusCode: response.statusCode);
      }
    } on APIException {
      rethrow;
    } catch (e) {
      APIException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await _client.get(Uri.https(kBaseUrl, kGetEndPoint));

      if (response.statusCode != 200) {
        throw APIException(
            message: response.body, statusCode: response.statusCode);
      }

      return List<DataMap>.from(jsonDecode(response.body) as List)
          .map((userData) => UserModel.fromMap(userData))
          .toList();
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: 500);
    }
  }
}
