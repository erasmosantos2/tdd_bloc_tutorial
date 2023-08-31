import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:tdd_bloc_tutorial/core/errors/exceptions.dart';
import 'package:tdd_bloc_tutorial/core/utils/constants.dart';
import 'package:tdd_bloc_tutorial/src/authentication/data/datasources/authentication_remote_datasource.dart';
import 'package:flutter_test/flutter_test.dart';

// Todo verify [MockClient] packahe Http

class MockClient extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late AuthenticationRemoteDatasource remoteDatasource;

  setUp(() {
    client = MockClient();
    remoteDatasource = AuthenticationRemoteDataSrcImpl(client);
    registerFallbackValue(Uri());
  });

  group('createUser', () {
    test('Should complete successfully when the status code is 200 or 201',
        () async {
      // Arrange
      when(() => client.post(any(), body: any(named: 'body'))).thenAnswer(
          (_) async => http.Response('User created successfully', 201));
      // Act
      final methodCall = remoteDatasource.createUser;
      // Asset
      expect(
          () async => methodCall(
                createdAt: 'createdAt',
                name: 'name',
                avatar: 'avatar',
              ),
          completes);
      verify(() => client.post(Uri.parse('$kBaseUrl$kCreateUserEndPoint'),
          body: jsonEncode({
            'createdAt': 'createdAt',
            'name': 'name',
            'avatar': 'avatar',
          }))).called(1);
      verifyNoMoreInteractions(client);
    });

    test('Should throw a [APIException] when the status code is not 200 or 201',
        () async {
      // Arrange
      when(
        () => client.post(any(), body: any(named: 'body')),
      ).thenAnswer((_) async => http.Response('Invalid email address', 400));
      // Act
      final methodCall = remoteDatasource.createUser;
      // Assert
      expect(
          () async => methodCall(
              createdAt: 'createdAt', name: 'name', avatar: 'avatar'),
          throwsA(const APIException(
              message: 'Invalid email address', statusCode: 400)));
      verify(() => client.post(Uri.parse('$kBaseUrl$kCreateUserEndPoint'),
          body: jsonEncode({
            'createdAt': 'createdAt',
            'name': 'name',
            'avatar': 'avatar',
          }))).called(1);
      verifyNoMoreInteractions(client);
    });
  });
}
