import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crediahorro/src/common_widgets/app_scaffold.dart';
import 'package:crediahorro/src/features/dashboard/DashboardContent.dart';
import 'package:crediahorro/src/features/dashboard/bloc/DashboardBloc.dart';
import 'package:crediahorro/src/services/cliente_service.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardBloc(ClienteService()),
      child: const AppScaffold(title: "CREDIAHORRO", body: DashboardContent()),
    );
  }
}
