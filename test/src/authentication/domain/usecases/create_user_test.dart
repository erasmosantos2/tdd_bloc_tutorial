// what does the class depend on
// Answer: AuthenticartionRepository
// How can we create a fake version of the dependecy
// Answer: Use Mocktail
// How do we control what our dependencies do
// Answer: Using the Moctail's APIs

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_bloc_tutorial/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:tdd_bloc_tutorial/src/authentication/domain/usecases/create_user.dart';

import 'authentication_repository.mock.dart';

void main() {
  late CreateUSer usecases;
  late AuthenticationRepository repository;

  setUp(() {
    repository = MockAuthRepo();
    usecases = CreateUSer(repository);
  });

  const params = CreateUserParams.empty();
  test('Should call the [AuthRapositorio.createUser]', () async {
    // arrange
    // (Called a stub)
    when(
      () => repository.createUser(
          createdAt: any(named: 'createdAt'),
          name: any(named: 'name'),
          avatar: any(named: 'avatar')),
    ).thenAnswer((_) async => const Right(null));
    // act
    final result = await usecases(params);
    // assert
    expect(result, const Right<dynamic, void>(null));
    verify(() => repository.createUser(
        createdAt: params.createdAt,
        name: params.name,
        avatar: params.avatar)).called(1);

    verifyNoMoreInteractions(repository);
  });
}
