import 'package:crediahorro/src/features/clients/view/ClientsContent.dart';
import 'package:crediahorro/src/features/clients/view/bloc/ClientsBloc.dart';
import 'package:crediahorro/src/features/clients/view/bloc/ClientsEvent.dart';
import 'package:crediahorro/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crediahorro/src/common_widgets/app_scaffold.dart';
import 'package:crediahorro/src/services/cliente_service.dart';

class ClientsPage extends StatelessWidget {
  const ClientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ClientsBloc(ClienteService())..add(LoadClients()),
      child: AppScaffold(
        title: "CREDIAHORRO",
        body: ClientsContent(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, AppRouter.clienteForm);
          },
          backgroundColor: Colors.white,
          icon: const Icon(Icons.add, color: Colors.black),
          label: const Text("Agregar", style: TextStyle(color: Colors.black)),
        ),
      ),
    );
  }
}
