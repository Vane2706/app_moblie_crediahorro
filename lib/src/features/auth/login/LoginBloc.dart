import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crediahorro/src/domain/utils/Resource.dart';
import 'package:crediahorro/src/features/auth/login/LoginEvent.dart';
import 'package:crediahorro/src/features/auth/login/LoginState.dart';
import 'package:crediahorro/src/services/AuthService.dart'; // Importar el servicio AuthService

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService authService;

  // Inicializa el Bloc con el servicio AuthService
  LoginBloc(this.authService) : super(const LoginState());

  // Manejadores de eventos
  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginUsernameChanged) {
      // Cambiar el estado con el nuevo nombre de usuario
      yield state.copyWith(username: event.username);
    } else if (event is LoginPasswordChanged) {
      // Cambiar el estado con la nueva contraseña
      yield state.copyWith(password: event.password);
    } else if (event is LoginSubmitted) {
      // Cambiar el estado a cargando antes de hacer el login
      yield state.copyWith(status: Resource.loading());

      try {
        // Llamada al servicio para hacer el login
        await authService.login(state.username, state.password);
        yield state.copyWith(status: Resource.success("Login Successful"));
      } catch (e) {
        yield state.copyWith(status: Resource.error("Credenciales inválidas"));
      }
    }
  }
}
