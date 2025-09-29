import 'package:crediahorro/src/features/clients/view/bloc/ClientsBloc.dart';
import 'package:crediahorro/src/features/clients/view/bloc/ClientsEvent.dart';
import 'package:crediahorro/src/features/clients/view/bloc/ClientsState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crediahorro/src/constants/app_colors.dart';
import 'package:crediahorro/src/features/clients/models/cliente.dart';
import 'package:crediahorro/src/routing/app_router.dart';

class ClientsContent extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();

  ClientsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        // Buscador
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: searchController,
            onChanged: (value) =>
                context.read<ClientsBloc>().add(SearchClients(value)),
            decoration: InputDecoration(
              hintText: "Buscar cliente...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Lista de clientes
        Expanded(
          child: BlocBuilder<ClientsBloc, ClientsState>(
            builder: (context, state) {
              if (state is ClientsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ClientsError) {
                return Center(child: Text(state.message));
              } else if (state is ClientsLoaded) {
                if (state.filteredClientes.isEmpty) {
                  return _emptyList();
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: state.filteredClientes.length,
                  itemBuilder: (_, index) {
                    final cliente = state.filteredClientes[index];
                    return _clienteTile(context, cliente);
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget _clienteTile(BuildContext context, Cliente cliente) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 233, 241, 246),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: () => _mostrarAccionesCliente(context, cliente),
        leading: const CircleAvatar(
          radius: 22,
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(
          cliente.nombre,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        subtitle: Text(
          "${cliente.telefonoWhatsapp}",
          style: const TextStyle(fontSize: 13),
        ),
        trailing: const Icon(Icons.more_vert, color: AppColors.textSecondary),
      ),
    );
  }

  Widget _emptyList() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.people_outline, size: 50, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            "No se encontraron clientes",
            style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  void _mostrarAccionesCliente(BuildContext context, Cliente cliente) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: AppColors.primary),
              title: const Text("Editar Cliente"),
              onTap: () async {
                Navigator.pop(context);
                final result = await Navigator.pushNamed(
                  context,
                  AppRouter.clienteEdit,
                  arguments: cliente.id,
                );
                if (result == true && context.mounted) {
                  context.read<ClientsBloc>().add(LoadClients());
                }
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.account_balance_wallet,
                color: AppColors.primary,
              ),
              title: const Text("Ver Préstamos"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  AppRouter.prestamos,
                  arguments: cliente.id,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
