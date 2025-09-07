import 'package:crediahorro/src/features/auth/login/LoginPage.dart';
import 'package:crediahorro/src/features/auth/register/RegisterPage.dart';
import 'package:crediahorro/src/features/clients/clients_page.dart';
import 'package:crediahorro/src/features/dashboard/dashboard_screen.dart';
import 'package:crediahorro/src/features/loans/loans_page.dart';
import 'package:crediahorro/src/features/reports/reports_page.dart';
import 'package:crediahorro/src/features/settings/settings_page.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static const String login = '/';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String clientes = '/clientes';
  static const String prestamos = '/prestamos';
  static const String reportes = '/reportes';
  static const String configuracion = '/configuracion';

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
        return MaterialPageRoute(builder: (_) => const LoansPage());
      case reportes:
        return MaterialPageRoute(builder: (_) => const ReportsPage());
      case configuracion:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("Página no encontrada"))),
        );
    }
  }
}
