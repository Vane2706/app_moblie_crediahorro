import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crediahorro/src/features/auth/login/LoginContent.dart';
import 'package:crediahorro/src/features/auth/login/LoginBloc.dart';
import 'package:crediahorro/src/services/AuthService.dart'; // Agregado para importar el servicio AuthService

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => LoginBloc(AuthService()), // Pasar el AuthService aquí
        child: const Center(
          child: SingleChildScrollView(
            child: LoginContent(),
          ), // Mostrar el contenido del login
        ),
      ),
    );
  }
}
