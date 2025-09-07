import 'package:crediahorro/src/domain/utils/Resource.dart';
import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final String username;
  final String password;
  final Resource<void>? status;

  const LoginState({this.username = '', this.password = '', this.status});

  LoginState copyWith({
    String? username,
    String? password,
    Resource<void>? status,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      status: status,
    );
  }

  @override
  List<Object?> get props => [username, password, status];
}
