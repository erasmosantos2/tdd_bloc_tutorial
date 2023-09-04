import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:tdd_bloc_tutorial/src/authentication/data/datasources/authentication_remote_datasource.dart';
import 'package:tdd_bloc_tutorial/src/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:tdd_bloc_tutorial/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:tdd_bloc_tutorial/src/authentication/domain/usecases/create_user.dart';
import 'package:tdd_bloc_tutorial/src/authentication/domain/usecases/get_users.dart';
import 'package:tdd_bloc_tutorial/src/authentication/presentation/cubit/authentication_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // App logic
  sl
    ..registerFactory(
        () => AuthenticationCubit(createUSer: sl(), getUsers: sl()))

    // Use cases
    ..registerLazySingleton(() => CreateUSer(sl()))
    ..registerLazySingleton(() => GetUsers(sl()))

    // Repositories
    ..registerLazySingleton<AuthenticationRepository>(
        () => AuthenticationRepositoryImplementation(sl()))

    // Data sources
    ..registerLazySingleton<AuthenticationRemoteDatasource>(
        () => AuthenticationRemoteDataSrcImpl(sl()))

    // External Dependencies
    ..registerLazySingleton(() => http.Client());
}
