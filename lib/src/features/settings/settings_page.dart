import 'package:crediahorro/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:crediahorro/src/constants/app_colors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_SettingItem> items = [
      _SettingItem(title: "Perfil", icon: Icons.person, onTap: () {}),
      _SettingItem(
        title: "Notificaciones",
        icon: Icons.notifications,
        onTap: () {},
      ),
      _SettingItem(title: "Seguridad", icon: Icons.lock, onTap: () {}),
      _SettingItem(
        title: "Cerrar Sesión",
        icon: Icons.logout,
        onTap: () => Navigator.pushNamed(context, AppRouter.login),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Configuración"),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (_, index) {
          final item = items[index];
          return ListTile(
            leading: Icon(item.icon, color: AppColors.primary),
            title: Text(item.title),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: AppColors.textSecondary,
            ),
            onTap: item.onTap,
          );
        },
        separatorBuilder: (_, __) => const Divider(),
      ),
    );
  }
}

class _SettingItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  _SettingItem({required this.title, required this.icon, required this.onTap});
}
