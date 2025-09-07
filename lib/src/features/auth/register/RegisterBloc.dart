import 'package:crediahorro/src/domain/utils/Resource.dart';
import 'package:crediahorro/src/features/auth/register/RegisterEvent.dart';
import 'package:crediahorro/src/features/auth/register/RegisterState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(const RegisterState()) {
    on<RegisterUsernameChanged>((event, emit) {
      emit(state.copyWith(username: event.username));
    });

    on<RegisterWhatsappChanged>((event, emit) {
      emit(state.copyWith(whatsapp: event.whatsapp));
    });

    on<RegisterPasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });

    on<RegisterSubmitted>((event, emit) async {
      emit(state.copyWith(status: Resource.loading()));

      await Future.delayed(const Duration(seconds: 2)); // Simula llamada API

      if (state.username.isNotEmpty &&
          state.whatsapp.isNotEmpty &&
          state.password.isNotEmpty) {
        emit(state.copyWith(status: Resource.success(null)));
      } else {
        emit(
          state.copyWith(
            status: Resource.error("Todos los campos son obligatorios"),
          ),
        );
      }
    });
  }
}
