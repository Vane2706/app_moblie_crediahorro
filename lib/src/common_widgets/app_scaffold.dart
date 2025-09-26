import 'package:crediahorro/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:crediahorro/src/common_widgets/app_sidebar.dart';
import 'package:crediahorro/src/constants/app_colors.dart';
import 'package:crediahorro/src/constants/app_text_styles.dart';

class AppScaffold extends StatefulWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.floatingActionButton,
  });

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  bool _isSidebarOpen = false;
  int _selectedIndex = 0; // 👈 para saber qué botón está activo

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
  }

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // 👇 Aquí defines la navegación según el botón
    switch (index) {
      case 0:
        Navigator.pushNamed(context, AppRouter.dashboard);
        break;
      case 1:
        Navigator.pushNamed(context, AppRouter.clientes);
        break;
      case 2:
        Navigator.pushNamed(context, AppRouter.reportes);
        break;
      case 3:
        Navigator.pushNamed(context, AppRouter.perfil);
        break;
      case 4:
        Navigator.pushNamed(context, AppRouter.configuracion);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              widget.title,
              style: AppTextStyles.screenTitle.copyWith(color: AppColors.black),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.menu, color: AppColors.secondary),
              onPressed: _toggleSidebar,
            ),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/img/appbar.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          body: widget.body,

          floatingActionButton: widget.floatingActionButton,

          // 🔽 Barra de navegación inferior
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onNavTapped,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            items: [
              _buildNavItem(Icons.home, "Home", 0),
              _buildNavItem(Icons.people, "Clientes", 1),
              _buildNavItem(Icons.bar_chart, "Estadísticas", 2),
              _buildNavItem(Icons.person, "Perfil", 3),
              _buildNavItem(Icons.settings, "Ajustes", 4),
            ],
          ),
        ),

        // Sidebar overlay
        if (_isSidebarOpen) ...[
          GestureDetector(
            onTap: _toggleSidebar,
            child: Container(color: Colors.black54),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: AppSidebar(onClose: _toggleSidebar),
          ),
        ],
      ],
    );
  }

  /// 👇 Método auxiliar para animar el crecimiento de ícono/texto al seleccionar
  BottomNavigationBarItem _buildNavItem(
    IconData icon,
    String label,
    int index,
  ) {
    final bool isSelected = _selectedIndex == index;

    return BottomNavigationBarItem(
      icon: AnimatedScale(
        scale: isSelected ? 1.2 : 1.0, // crece si está seleccionado
        duration: const Duration(milliseconds: 200),
        child: Icon(icon),
      ),
      label: label,
    );
  }
}
