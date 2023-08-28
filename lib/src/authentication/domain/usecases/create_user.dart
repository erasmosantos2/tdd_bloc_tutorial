import 'package:equatable/equatable.dart';
import 'package:tdd_bloc_tutorial/core/usecase/usecase.dart';
import 'package:tdd_bloc_tutorial/core/utils/typedef.dart';
import 'package:tdd_bloc_tutorial/src/authentication/domain/repositories/authentication_repository.dart';

class CreateUSer extends UsecaseWithParams<void, CreateUserParams> {
  CreateUSer(this._repository);

  final AuthenticationRepository _repository;

  @override
  ResultVoid call(CreateUserParams params) async => _repository.createUser(
      createdAt: params.createdAt, name: params.name, avatar: params.avatar);
}

class CreateUserParams extends Equatable {
  final String createdAt;
  final String name;
  final String avatar;

  const CreateUserParams({
    required this.createdAt,
    required this.name,
    required this.avatar,
  });

  const CreateUserParams.empty()
      : this(
            createdAt: '_empty.createdAt',
            name: '_empty.name',
            avatar: '_empty.avatar');

  @override
  List<Object?> get props => [createdAt, name, avatar];
}
