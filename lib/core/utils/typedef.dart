import 'package:dartz/dartz.dart';
import 'package:tdd_bloc_tutorial/core/errors/failure.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;

typedef ResultVoid = Future<Either<Failure, void>>;
