import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_bloc_tutorial/core/errors/failure.dart';
import 'package:tdd_bloc_tutorial/src/authentication/domain/usecases/create_user.dart';
import 'package:tdd_bloc_tutorial/src/authentication/domain/usecases/get_users.dart';
import 'package:tdd_bloc_tutorial/src/authentication/presentation/bloc/authentication_state.dart';
import 'package:tdd_bloc_tutorial/src/authentication/presentation/cubit/authentication_cubit.dart';

class MockGetUsers extends Mock implements GetUsers {}

class MockCreateUser extends Mock implements CreateUSer {}

void main() {
  late GetUsers getUsers;
  late CreateUSer createUSer;
  late AuthenticationCubit cubit;

  const tCreateUserParams = CreateUserParams.empty();
  const tAPIFailure = APIFailure(message: 'message', statusCode: 400);

  setUp(() {
    getUsers = MockGetUsers();
    createUSer = MockCreateUser();

    cubit = AuthenticationCubit(createUSer: createUSer, getUsers: getUsers);
    registerFallbackValue(tCreateUserParams);
  });

  tearDown(() => cubit.close());

  test('Initial state should be [AthenticationInitial]', () {
    expect(cubit.state, const AuthenticationInitial());
  });

  group('CreateUser', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'Should emit [creatingUser, UserCreated] when successful',
      build: () {
        // Arrange
        when(() => createUSer(any()))
            .thenAnswer((_) async => const Right(null));

        return cubit;
      },
      act: (cubit) => cubit.createUser(
          createdAt: tCreateUserParams.createdAt,
          name: tCreateUserParams.name,
          avatar: tCreateUserParams.avatar),
      expect: () => const [
        CreatingUser(),
        UserCreated(),
      ],
      verify: (_) {
        verify(() => createUSer(tCreateUserParams)).called(1);
        verifyNoMoreInteractions(createUSer);
      },
    );

    blocTest<AuthenticationCubit, AuthenticationState>(
        'Should emit [CreatingUser, AuthenticationError when unsuccessful]',
        build: () {
          when(() => createUSer(any()))
              .thenAnswer((_) async => const Left(tAPIFailure));
          return cubit;
        },
        act: (cubit) => cubit.createUser(
            createdAt: tCreateUserParams.createdAt,
            name: tCreateUserParams.name,
            avatar: tCreateUserParams.avatar),
        expect: () => [
              const CreatingUser(),
              AuthenticationError(tAPIFailure.errorMessage)
            ],
        verify: (_) {
          verify(() => createUSer(tCreateUserParams)).called(1);
          verifyNoMoreInteractions(createUSer);
        });
  });
}
