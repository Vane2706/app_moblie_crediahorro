import 'package:crediahorro/src/features/auth/register/RegisterBloc.dart';
import 'package:crediahorro/src/features/auth/register/RegisterContent.dart';
import 'package:crediahorro/src/services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => RegisterBloc(AuthService()),
        child: const Center(
          child: SingleChildScrollView(child: RegisterContent()),
        ),
      ),
    );
  }
}
