import 'package:crediahorro/src/domain/utils/Resource.dart';
import 'package:crediahorro/src/features/auth/login/LoginEvent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crediahorro/src/features/auth/login/LoginBloc.dart';
import 'package:crediahorro/src/features/auth/login/LoginState.dart';
import 'package:crediahorro/src/constants/app_colors.dart';
import 'package:crediahorro/src/constants/app_text_styles.dart';
import 'package:crediahorro/src/common_widgets/custom_text_field.dart';
import 'package:crediahorro/src/common_widgets/primary_button.dart';

class LoginContent extends StatelessWidget {
  const LoginContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        // Verifica si el estado ha cambiado a éxito o error
        if (state.status != null) {
          if (state.status!.status == Status.success) {
            Navigator.pushReplacementNamed(
              context,
              '/dashboard', // Redirige si el login es exitoso
            );
          } else if (state.status!.status == Status.error) {
            // Muestra un error si las credenciales son incorrectas
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.status!.message ?? 'Error')),
            );
          }
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
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
                    Text(
                      "Bienvenido a CrediAhorro",
                      style: AppTextStyles.screenTitle,
                    ),
                    const SizedBox(height: 30),

                    // Campo para el usuario
                    CustomTextField(
                      label: "Usuario",
                      hint: "Ingresa tu usuario",
                      onChanged: (value) {
                        context.read<LoginBloc>().add(
                          LoginUsernameChanged(
                            value,
                          ), // Evento para cambiar el usuario
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Campo para la contraseña
                    CustomTextField(
                      label: "Contraseña",
                      hint: "Ingresa tu contraseña",
                      isPassword: true,
                      onChanged: (value) {
                        context.read<LoginBloc>().add(
                          LoginPasswordChanged(
                            value,
                          ), // Evento para cambiar la contraseña
                        );
                      },
                    ),
                    const SizedBox(height: 30),

                    // Botón para ingresar
                    if (state.status?.status == Status.loading)
                      const CircularProgressIndicator(color: AppColors.primary)
                    else
                      PrimaryButton(
                        text: "Ingresar",
                        onPressed: () {
                          context.read<LoginBloc>().add(
                            const LoginSubmitted(),
                          ); // Enviar evento de login
                        },
                      ),

                    const SizedBox(height: 20),
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
