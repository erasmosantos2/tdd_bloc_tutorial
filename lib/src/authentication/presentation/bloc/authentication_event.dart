import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class CreateUserEvent extends AuthenticationEvent {
  final String createdAt;
  final String name;
  final String avatar;

  const CreateUserEvent(this.createdAt, this.name, this.avatar);

  @override
  List<Object> get props => [createdAt, name, avatar];
}

class GetUsersEvent extends AuthenticationEvent {
  const GetUsersEvent();

  @override
  List<Object> get props => [];
}
