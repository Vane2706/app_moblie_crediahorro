import 'package:flutter/material.dart';
import 'package:crediahorro/src/constants/app_colors.dart';
import 'package:crediahorro/src/routing/app_router.dart';

class AppSidebar extends StatelessWidget {
  final VoidCallback onClose;

  const AppSidebar({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final items = [
      _SidebarItem("Dashboard", Icons.dashboard_rounded, AppRouter.dashboard),
      _SidebarItem("Clientes", Icons.people_alt_rounded, AppRouter.clientes),
      _SidebarItem(
        "Préstamos",
        Icons.account_balance_wallet_rounded,
        AppRouter.prestamos,
      ),
      _SidebarItem("Reportes", Icons.bar_chart_rounded, AppRouter.reportes),
      _SidebarItem(
        "Configuración",
        Icons.settings_rounded,
        AppRouter.configuracion,
      ),
    ];

    return Material(
      color: AppColors.background,
      child: SafeArea(
        child: Container(
          width: 270,
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 2, 18, 103),
                Color.fromARGB(255, 18, 38, 163),
                Color.fromARGB(255, 56, 41, 191),
              ], // degradado elegante azul-gris
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "CrediAhorro",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                  IconButton(
                    onPressed: onClose,
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 35),

              // Opciones de menú
              Expanded(
                child: ListView.separated(
                  itemBuilder: (_, index) {
                    final item = items[index];
                    return _SidebarTile(item: item);
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 4),
                  itemCount: items.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SidebarItem {
  final String title;
  final IconData icon;
  final String route;

  _SidebarItem(this.title, this.icon, this.route);
}

class _SidebarTile extends StatefulWidget {
  final _SidebarItem item;

  const _SidebarTile({required this.item});

  @override
  State<_SidebarTile> createState() => _SidebarTileState();
}

class _SidebarTileState extends State<_SidebarTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _hovered ? Colors.white.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Icon(
            widget.item.icon,
            color: _hovered ? Colors.cyanAccent : Colors.white70,
          ),
          title: Text(
            widget.item.title,
            style: TextStyle(
              color: _hovered ? Colors.white : Colors.white70,
              fontWeight: _hovered ? FontWeight.bold : FontWeight.w500,
              fontSize: 16,
            ),
          ),
          onTap: () {
            Navigator.pushNamed(context, widget.item.route);
            // cierra el sidebar
            if (Navigator.canPop(context)) onClose();
          },
        ),
      ),
    );
  }

  void onClose() {}
}
