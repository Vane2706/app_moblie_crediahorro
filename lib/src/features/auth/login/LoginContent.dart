import 'package:crediahorro/src/common_widgets/app_logo.dart';
import 'package:crediahorro/src/common_widgets/custom_text_field.dart';
import 'package:crediahorro/src/common_widgets/primary_button.dart';
import 'package:crediahorro/src/constants/app_text_styles.dart';
import 'package:crediahorro/src/domain/utils/Resource.dart';
import 'package:crediahorro/src/features/auth/login/LoginBloc.dart';
import 'package:crediahorro/src/features/auth/login/LoginEvent.dart';
import 'package:crediahorro/src/features/auth/login/LoginState.dart';
import 'package:crediahorro/src/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginContent extends StatelessWidget {
  const LoginContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status?.status == Status.success) {
          Navigator.pushReplacementNamed(context, '/dashboard');
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          final status = state.status;

          return Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const AppLogo(size: 100),
                    const SizedBox(height: 20),
                    Text(
                      "Bienvenido a CrediAhorro",
                      style: AppTextStyles.screenTitle,
                    ),
                    const SizedBox(height: 30),

                    // Usuario
                    CustomTextField(
                      label: "Usuario",
                      hint: "Ingresa tu usuario",
                      onChanged: (value) => context.read<LoginBloc>().add(
                        LoginUsernameChanged(value),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Contraseña
                    CustomTextField(
                      label: "Contraseña",
                      hint: "Ingresa tu contraseña",
                      isPassword: true,
                      onChanged: (value) => context.read<LoginBloc>().add(
                        LoginPasswordChanged(value),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Botón login
                    if (status?.status == Status.loading)
                      const CircularProgressIndicator(color: AppColors.primary)
                    else
                      PrimaryButton(
                        text: "Ingresar",
                        onPressed: () {
                          context.read<LoginBloc>().add(const LoginSubmitted());
                        },
                      ),
                    const SizedBox(height: 20),

                    // Error
                    if (status?.status == Status.error)
                      Text(
                        status?.message ?? "Error",
                        style: const TextStyle(color: AppColors.error),
                      ),

                    // Ir a registro
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: const Text(
                        "¿No tienes cuenta? Regístrate",
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
