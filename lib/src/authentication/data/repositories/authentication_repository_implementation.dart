import 'package:dartz/dartz.dart';
import 'package:tdd_bloc_tutorial/core/errors/exceptions.dart';
import 'package:tdd_bloc_tutorial/core/errors/failure.dart';
import 'package:tdd_bloc_tutorial/core/utils/typedef.dart';
import 'package:tdd_bloc_tutorial/src/authentication/data/datasources/authentication_remote_datasource.dart';
import 'package:tdd_bloc_tutorial/src/authentication/domain/entities/user.dart';
import 'package:tdd_bloc_tutorial/src/authentication/domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImplementation
    implements AuthenticationRepository {
  final AuthenticationRemoteDatasource _remoteDatasource;

  AuthenticationRepositoryImplementation(this._remoteDatasource);

  @override
  ResultVoid createUser(
      {required String createdAt,
      required String name,
      required String avatar}) async {
    // Test-Driven Development
    // call the remote data source
    // make sure that it returns the proper data if there is no exception
    // check if the method return the proper data
    // Check if when the remoteDataSource throws as Exception, we return a
    // failure and if when it doesn't throw and exception, we return the actual
    // expected data

    try {
      await _remoteDatasource.createUser(
          createdAt: createdAt, name: name, avatar: avatar);

      return const Right(null);
      // todo verify ServerException(replace: APIException)
    } on APIException catch (e) {
      return Left(APIFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<User>> getUsers() async {
    try {
      final users = await _remoteDatasource.getUsers();
      return Right(users);
    } on APIException catch (e) {
      return Left(APIFailure.fromException(e));
    }
  }
}
