import 'package:flutter/material.dart';
import 'package:crediahorro/src/constants/app_colors.dart';
import 'package:crediahorro/src/constants/app_text_styles.dart';
import 'package:crediahorro/src/common_widgets/app_logo.dart';

class ClientsPage extends StatelessWidget {
  const ClientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Clientes"),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
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
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder: (_, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: const Icon(Icons.person, color: AppColors.primary),
                  ),
                  title: Text("Cliente ${index + 1}"),
                  subtitle: const Text("Número de WhatsApp: +51 900000000"),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  onTap: () {},
                );
              },
              separatorBuilder: (_, __) => const Divider(),
              itemCount: 10,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
