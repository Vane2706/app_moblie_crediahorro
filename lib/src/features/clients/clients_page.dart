import 'package:crediahorro/src/features/clients/models/cliente.dart';
import 'package:crediahorro/src/routing/app_router.dart';
import 'package:crediahorro/src/services/cliente_service.dart';
import 'package:flutter/material.dart';
import 'package:crediahorro/src/common_widgets/app_scaffold.dart';
import 'package:crediahorro/src/constants/app_colors.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  final TextEditingController _searchController = TextEditingController();
  final ClienteService _clienteService = ClienteService();
  List<Cliente> _clientes = [];
  List<Cliente> _filteredClientes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchClientes();
    _searchController.addListener(_filterClientes);
  }

  void _fetchClientes() async {
    try {
      final data = await _clienteService.getClientes();
      setState(() {
        _clientes = data;
        _filteredClientes = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error cargando clientes: $e")));
    }
  }

  void _filterClientes() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredClientes = _clientes
          .where(
            (c) =>
                c.nombre.toLowerCase().contains(query) ||
                c.dni.toLowerCase().contains(query),
          )
          .toList();
    });
  }

  void _mostrarAccionesCliente(Cliente cliente) {
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
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  AppRouter.clienteEdit,
                  arguments: cliente.id,
                );
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "CREDIAHORRO",
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Buscador
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
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

          // Lista clientes
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _filteredClientes.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.people_outline,
                          size: 50,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "No se encontraron clientes",
                          style: TextStyle(
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _filteredClientes.length,
                    itemBuilder: (_, index) {
                      final cliente = _filteredClientes[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 233, 241, 246),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          onTap: () => _mostrarAccionesCliente(cliente),
                          leading: const CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(
                            cliente.nombre,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Text(
                            "${cliente.telefonoWhatsapp}",
                            style: const TextStyle(fontSize: 13),
                          ),
                          trailing: const Icon(
                            Icons.more_vert,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppRouter.clienteForm);
        },
        backgroundColor: Colors.white,
        icon: const Icon(Icons.add, color: Colors.black),
        label: const Text("Agregar", style: TextStyle(color: Colors.black)),
      ),
    );
  }
}
