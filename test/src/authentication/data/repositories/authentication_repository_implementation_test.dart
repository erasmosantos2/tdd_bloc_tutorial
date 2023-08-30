import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_bloc_tutorial/core/errors/exceptions.dart';
import 'package:tdd_bloc_tutorial/core/errors/failure.dart';
import 'package:tdd_bloc_tutorial/src/authentication/data/datasources/authentication_remote_datasource.dart';
import 'package:tdd_bloc_tutorial/src/authentication/data/models/user_model.dart';
import 'package:tdd_bloc_tutorial/src/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:tdd_bloc_tutorial/src/authentication/domain/entities/user.dart';

class MockAuthRemoteDataSrc extends Mock
    implements AuthenticationRemoteDatasource {}

void main() {
  late AuthenticationRemoteDatasource remoteDataSource;
  late AuthenticationRepositoryImplementation repoImpl;

  setUp(() {
    remoteDataSource = MockAuthRemoteDataSrc();
    repoImpl = AuthenticationRepositoryImplementation(remoteDataSource);
  });

  const tException = APIException(message: 'message', statusCode: 500);

  group('createUser', () {
    const createdAt = 'whatever.createdAt';
    const name = 'whatever.name';
    const avatar = 'whatever.avatar';

    test(
        'Should call the [RemoteDataSource.createUser] and complete '
        ' successfully when the call to the remote source is successful',
        () async {
      // Arrange
      when(() => remoteDataSource.createUser(
              createdAt: any(named: 'createdAt'),
              name: any(named: 'name'),
              avatar: any(named: 'avatar')))
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await repoImpl.createUser(
          createdAt: createdAt, name: name, avatar: avatar);
      // Assert
      expect(result, equals(const Right(null)));
      verify(() => remoteDataSource.createUser(
          createdAt: createdAt, name: name, avatar: avatar)).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
        'Should return a [APIFailure] when call to the remote '
        'source is unsuccessful', () async {
      // Arrange
      when(() => remoteDataSource.createUser(
          createdAt: any(named: 'createdAt'),
          name: any(named: 'name'),
          avatar: any(named: 'avatar'))).thenThrow(tException);
      // Act
      final result = await repoImpl.createUser(
          createdAt: createdAt, name: name, avatar: avatar);
      // Assert
      expect(
          result,
          equals(Left<APIFailure, dynamic>(APIFailure(
            message: tException.message,
            statusCode: tException.statusCode,
          ))));
      verify(() => remoteDataSource.createUser(
          createdAt: createdAt, name: name, avatar: avatar)).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });
  group('getUsers', () {
    final tUsers = [const UserModel.empty()];
    test(
        'Should call the [RemoteDataSource.getUsers] and return [List<User>] '
        'when call to remote source is successful', () async {
      // Arrange
      when(() => remoteDataSource.getUsers()).thenAnswer((_) async => tUsers);
      // Act
      final result = await repoImpl.getUsers();

      // Assert
      expect(result, equals(Right<dynamic, List<User>>(tUsers)));
      expect(result, isA<Right<dynamic, List<User>>>());
      verify(() => remoteDataSource.getUsers()).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
        'Should return a [APIFailure] when call to the remote '
        'source is unsuccessful', () async {
      // Arrange
      when(() => remoteDataSource.getUsers()).thenThrow(tException);
      // Act
      final result = await repoImpl.getUsers();
      // Assert
      expect(
          result,
          equals(Left(APIFailure(
            message: tException.message,
            statusCode: tException.statusCode,
          ))));
      verify(() => remoteDataSource.getUsers()).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });
}
