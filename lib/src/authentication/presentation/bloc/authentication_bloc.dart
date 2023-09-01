import 'package:bloc/bloc.dart';
import 'package:tdd_bloc_tutorial/src/authentication/domain/usecases/create_user.dart';
import 'package:tdd_bloc_tutorial/src/authentication/domain/usecases/get_users.dart';

import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required CreateUSer createUSer,
    required GetUsers getUsers,
  })  : _createUser = createUSer,
        _getUsers = getUsers,
        super(const AuthenticationInitial()) {
    on<CreateUserEvent>(_createUserHandler);
    on<GetUsersEvent>(_getUsersHandler);
  }

  final CreateUSer _createUser;
  final GetUsers _getUsers;

  Future<void> _createUserHandler(
    CreateUserEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const CreatingUser());

    final result = await _createUser(CreateUserParams(
      createdAt: event.createdAt,
      name: event.name,
      avatar: event.avatar,
    ));

    result.fold((failure) => emit(AuthenticationError(failure.errorMessage)),
        (_) => emit(const UserCreated()));
  }

  Future<void> _getUsersHandler(
      GetUsersEvent evemt, Emitter<AuthenticationState> emit) async {
    emit(const GettingUsers());
    final result = await _getUsers();
    result.fold((failure) => emit(AuthenticationError(failure.errorMessage)),
        (users) => emit(UsersLoaded(users)));
  }
}
