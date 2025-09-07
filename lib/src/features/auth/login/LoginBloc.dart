import 'package:crediahorro/src/domain/utils/Resource.dart';
import 'package:crediahorro/src/features/auth/login/LoginEvent.dart';
import 'package:crediahorro/src/features/auth/login/LoginState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<LoginUsernameChanged>((event, emit) {
      emit(state.copyWith(username: event.username));
    });

    on<LoginPasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });

    on<LoginSubmitted>((event, emit) async {
      emit(state.copyWith(status: Resource.loading()));

      await Future.delayed(const Duration(seconds: 2)); // Simula login remoto

      if (state.username == "admin" && state.password == "1234") {
        emit(state.copyWith(status: Resource.success(null)));
      } else {
        emit(state.copyWith(status: Resource.error("Credenciales inválidas")));
      }
    });
  }
}
