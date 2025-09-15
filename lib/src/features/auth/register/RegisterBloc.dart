import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crediahorro/src/domain/utils/Resource.dart';
import 'package:crediahorro/src/features/auth/register/RegisterEvent.dart';
import 'package:crediahorro/src/features/auth/register/RegisterState.dart';
import 'package:crediahorro/src/services/AuthService.dart'; // Asegúrate de que el servicio AuthService sea correcto

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthService authService;

  RegisterBloc(this.authService) : super(const RegisterState());

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is RegisterUsernameChanged) {
      yield state.copyWith(username: event.username);
    } else if (event is RegisterWhatsappChanged) {
      yield state.copyWith(whatsapp: event.whatsapp);
    } else if (event is RegisterPasswordChanged) {
      yield state.copyWith(password: event.password);
    } else if (event is RegisterEmailChanged) {
      yield state.copyWith(email: event.email); // Agregar el campo email
    } else if (event is RegisterSubmitted) {
      yield state.copyWith(status: Resource.loading());

      try {
        await authService.register(
          state.username,
          state.password,
          state.whatsapp,
          state.email, // Asegúrate de enviar el email aquí
        );
        yield state.copyWith(status: Resource.success("Registro exitoso"));
      } catch (e) {
        yield state.copyWith(status: Resource.error("Error en el registro"));
      }
    }
  }
}
