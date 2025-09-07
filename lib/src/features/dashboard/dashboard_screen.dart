import 'package:crediahorro/src/common_widgets/app_logo.dart';
import 'package:crediahorro/src/constants/app_colors.dart';
import 'package:crediahorro/src/constants/app_text_styles.dart';
import 'package:crediahorro/src/routing/app_router.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_DashboardItem> items = [
      _DashboardItem(
        title: "Clientes",
        icon: Icons.people,
        onTap: () => Navigator.pushNamed(context, AppRouter.clientes),
      ),
      _DashboardItem(
        title: "Préstamos",
        icon: Icons.attach_money,
        onTap: () => Navigator.pushNamed(context, AppRouter.prestamos),
      ),
      _DashboardItem(
        title: "Reportes",
        icon: Icons.bar_chart,
        onTap: () => Navigator.pushNamed(context, AppRouter.reportes),
      ),
      _DashboardItem(
        title: "Configuración",
        icon: Icons.settings,
        onTap: () => Navigator.pushNamed(context, AppRouter.configuracion),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Dashboard",
          style: AppTextStyles.screenTitle.copyWith(color: AppColors.primary),
        ),
      ),
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const SizedBox(height: 20),

          // Logo centrado arriba
          const AppLogo(size: 100),
          const SizedBox(height: 10),
          Text(
            "Bienvenido a CrediAhorro",
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 30),

          // Grid de opciones
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                itemCount: items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  return _DashboardCard(item: items[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  _DashboardItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}

class _DashboardCard extends StatefulWidget {
  final _DashboardItem item;

  const _DashboardCard({required this.item});

  @override
  State<_DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<_DashboardCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.item.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)], // azul suave
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.item.icon, size: 45, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                widget.item.title,
                style: AppTextStyles.body.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
