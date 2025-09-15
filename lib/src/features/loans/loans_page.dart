import 'package:crediahorro/src/layouts/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:crediahorro/src/constants/app_colors.dart';
import 'package:crediahorro/src/constants/app_text_styles.dart';
import 'package:crediahorro/src/common_widgets/app_logo.dart';

class LoansPage extends StatefulWidget {
  const LoansPage({super.key});

  @override
  State<LoansPage> createState() => _LoansPageState();
}

class _LoansPageState extends State<LoansPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _allLoans = List.generate(15, (i) => "Préstamo #${i + 1}");
  List<String> _filteredLoans = [];

  @override
  void initState() {
    super.initState();
    _filteredLoans = _allLoans;
    _searchController.addListener(_filterLoans);
  }

  void _filterLoans() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredLoans = _allLoans
          .where((l) => l.toLowerCase().contains(query))
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
      title: "Préstamos",
      body: Column(
        children: [
          const SizedBox(height: 20),
          const AppLogo(size: 80),
          const SizedBox(height: 10),
          Text(
            "Gestión de Préstamos",
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
                hintText: "Buscar préstamo...",
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
                final loan = _filteredLoans[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: ListTile(
                    leading: const Icon(
                      Icons.attach_money,
                      color: AppColors.primary,
                    ),
                    title: Text(loan),
                    subtitle: const Text("Monto: S/ 1,500 - Estado: Activo"),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                    onTap: () {},
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemCount: _filteredLoans.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: const Color.fromARGB(255, 236, 240, 245),
        icon: const Icon(Icons.add, color: Colors.black),
        label: const Text("Nuevo", style: TextStyle(color: Colors.black)),
      ),
    );
  }
}
