import 'package:crediahorro/src/features/auth/login/LoginPage.dart';
import 'package:crediahorro/src/features/auth/register/RegisterPage.dart';
import 'package:crediahorro/src/features/clients/client_form_page.dart';
import 'package:crediahorro/src/features/clients/cliente_edit_page.dart';
import 'package:crediahorro/src/features/clients/clients_page.dart';
import 'package:crediahorro/src/features/cuotas/cuotas_page.dart';
import 'package:crediahorro/src/features/dashboard/dashboard_screen.dart';
import 'package:crediahorro/src/features/loans/loans_page.dart';
import 'package:crediahorro/src/features/loans/loan_form_page.dart';
import 'package:crediahorro/src/features/loans/loan_edit_page.dart';
import 'package:crediahorro/src/features/profile/profile_page.dart';
import 'package:crediahorro/src/features/reports/reports_page.dart';
import 'package:crediahorro/src/features/settings/settings_page.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static const String login = '/';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String clientes = '/clientes';
  static const String prestamos = '/prestamos';
  static const String prestamoNuevo = '/prestamo-nuevo';
  static const String prestamoEditar = '/prestamo-editar';
  static const String cuotas = '/cuotas';
  static const String reportes = '/reportes';
  static const String configuracion = '/configuracion';
  static const String clienteForm = '/cliente-form';
  static const String clienteEdit = '/cliente-edit';
  static const String perfil = '/perfil';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case clientes:
        return MaterialPageRoute(builder: (_) => const ClientsPage());
      case prestamos:
        final clienteId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => LoansPage(clienteId: clienteId),
        );
      case cuotas:
        final prestamoId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => CuotasPage(prestamoId: prestamoId),
        );
      case prestamoNuevo:
        final clienteId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => LoanFormPage(clienteId: clienteId),
        );
      case prestamoEditar:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => LoanEditPage(
            clienteId: args['clienteId'],
            prestamoId: args['prestamoId'],
          ),
        );
      case reportes:
        return MaterialPageRoute(builder: (_) => const ReportsPage());
      case configuracion:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case clienteForm:
        return MaterialPageRoute(builder: (_) => const ClienteFormPage());
      case clienteEdit:
        final clienteId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => ClienteEditPage(clienteId: clienteId),
        );
      case perfil:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("Página no encontrada"))),
        );
    }
  }
}
