import 'package:crediahorro/src/domain/utils/Resource.dart';
import 'package:equatable/equatable.dart';

class RegisterState extends Equatable {
  final String username;
  final String whatsapp;
  final String password;
  final Resource<void>? status;

  const RegisterState({
    this.username = '',
    this.whatsapp = '',
    this.password = '',
    this.status,
  });

  RegisterState copyWith({
    String? username,
    String? whatsapp,
    String? password,
    Resource<void>? status,
  }) {
    return RegisterState(
      username: username ?? this.username,
      whatsapp: whatsapp ?? this.whatsapp,
      password: password ?? this.password,
      status: status,
    );
  }

  @override
  List<Object?> get props => [username, whatsapp, password, status];
}
