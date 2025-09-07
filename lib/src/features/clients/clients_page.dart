import 'package:crediahorro/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:crediahorro/src/layouts/app_scaffold.dart';
import 'package:crediahorro/src/constants/app_colors.dart';
import 'package:crediahorro/src/constants/app_text_styles.dart';
import 'package:crediahorro/src/common_widgets/app_logo.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _allClients = List.generate(20, (i) => "Cliente ${i + 1}");
  List<String> _filteredClients = [];

  @override
  void initState() {
    super.initState();
    _filteredClients = _allClients;
    _searchController.addListener(_filterClients);
  }

  void _filterClients() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredClients = _allClients
          .where((c) => c.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Clientes",
      body: Column(
        children: [
          const SizedBox(height: 20),
          const AppLogo(size: 80),
          const SizedBox(height: 10),
          Text(
            "Gestión de Clientes",
            style: AppTextStyles.screenTitle.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
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

          // Lista filtrada
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder: (_, index) {
                final client = _filteredClients[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: const Icon(Icons.person, color: AppColors.primary),
                  ),
                  title: Text(client),
                  subtitle: const Text("Número de WhatsApp: +51 900000000"),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  onTap: () {},
                );
              },
              separatorBuilder: (_, __) => const Divider(),
              itemCount: _filteredClients.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRouter.clienteForm);
        },
        backgroundColor: const Color.fromARGB(255, 236, 240, 245),
        child: const Icon(Icons.add),
      ),
    );
  }
}
