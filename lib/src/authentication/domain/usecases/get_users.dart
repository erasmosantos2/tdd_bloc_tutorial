import 'package:tdd_bloc_tutorial/core/usecase/usecase.dart';
import 'package:tdd_bloc_tutorial/core/utils/typedef.dart';
import 'package:tdd_bloc_tutorial/src/authentication/domain/entities/user.dart';
import 'package:tdd_bloc_tutorial/src/authentication/domain/repositories/authentication_repository.dart';

class GetUsers extends UsecaseWithoutParams<List<User>> {
  @override
  ResultFuture<List<User>> call() async => _repository.getUsers();

  final AuthenticationRepository _repository;
  GetUsers(
    this._repository,
  );
}
