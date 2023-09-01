import 'package:bloc/bloc.dart';
import 'package:tdd_bloc_tutorial/src/authentication/domain/usecases/create_user.dart';
import 'package:tdd_bloc_tutorial/src/authentication/domain/usecases/get_users.dart';
import 'package:tdd_bloc_tutorial/src/authentication/presentation/bloc/authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit({
    required CreateUSer createUSer,
    required GetUsers getUsers,
  })  : _createUser = createUSer,
        _getUsers = getUsers,
        super(const AuthenticationInitial());

  final CreateUSer _createUser;
  final GetUsers _getUsers;

  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    emit(const CreatingUser());

    final result = await _createUser(CreateUserParams(
      createdAt: createdAt,
      name: name,
      avatar: avatar,
    ));

    result.fold((failure) => emit(AuthenticationError(failure.errorMessage)),
        (_) => emit(const UserCreated()));
  }

  Future<void> getUsers() async {
    emit(const GettingUsers());

    final result = await _getUsers();

    result.fold((failure) => emit(AuthenticationError(failure.errorMessage)),
        (users) => emit(UsersLoaded(users)));
  }
}
