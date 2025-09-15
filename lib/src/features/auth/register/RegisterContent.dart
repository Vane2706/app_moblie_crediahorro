import 'package:crediahorro/src/common_widgets/app_logo.dart';
import 'package:crediahorro/src/domain/utils/Resource.dart';
import 'package:crediahorro/src/features/auth/register/RegisterEvent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crediahorro/src/features/auth/register/RegisterBloc.dart';
import 'package:crediahorro/src/features/auth/register/RegisterState.dart';
import 'package:crediahorro/src/constants/app_colors.dart';
import 'package:crediahorro/src/constants/app_text_styles.dart';
import 'package:crediahorro/src/common_widgets/custom_text_field.dart';
import 'package:crediahorro/src/common_widgets/primary_button.dart';

class RegisterContent extends StatelessWidget {
  const RegisterContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
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
                  Text("Crear Cuenta", style: AppTextStyles.screenTitle),
                  const SizedBox(height: 30),

                  CustomTextField(
                    label: "Usuario",
                    hint: "Ingresa tu nombre de usuario",
                    onChanged: (value) => context.read<RegisterBloc>().add(
                      RegisterUsernameChanged(value),
                    ),
                  ),
                  const SizedBox(height: 20),

                  CustomTextField(
                    label: "WhatsApp",
                    hint: "Ingresa tu número de WhatsApp",
                    keyboardType: TextInputType.phone,
                    onChanged: (value) => context.read<RegisterBloc>().add(
                      RegisterWhatsappChanged(value),
                    ),
                  ),
                  const SizedBox(height: 20),

                  CustomTextField(
                    label: "Correo electrónico",
                    hint: "Ingresa tu email",
                    onChanged: (value) => context.read<RegisterBloc>().add(
                      RegisterEmailChanged(value),
                    ),
                  ),
                  const SizedBox(height: 20),

                  CustomTextField(
                    label: "Contraseña",
                    hint: "Crea tu contraseña",
                    isPassword: true,
                    onChanged: (value) => context.read<RegisterBloc>().add(
                      RegisterPasswordChanged(value),
                    ),
                  ),
                  const SizedBox(height: 30),

                  if (status?.status == Status.loading)
                    const CircularProgressIndicator(color: AppColors.primary)
                  else
                    PrimaryButton(
                      text: "Registrarme",
                      onPressed: () {
                        context.read<RegisterBloc>().add(
                          const RegisterSubmitted(),
                        );
                      },
                    ),

                  const SizedBox(height: 20),

                  if (status?.status == Status.error)
                    Text(
                      status?.message ?? "Error",
                      style: const TextStyle(color: AppColors.error),
                    ),
                  if (status?.status == Status.success)
                    const Text(
                      "✅ Registro exitoso",
                      style: TextStyle(color: AppColors.success),
                    ),

                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                    child: const Text(
                      "¿Ya tienes cuenta? Inicia sesión",
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
