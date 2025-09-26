import 'package:crediahorro/src/services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:crediahorro/src/routing/app_router.dart';
import 'package:crediahorro/src/common_widgets/profile_avatar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSidebar extends StatefulWidget {
  final VoidCallback onClose;
  const AppSidebar({super.key, required this.onClose});

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  String? _profileImagePath;
  String? _profileName;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _profileImagePath = prefs.getString('profile_image');
      _profileName = prefs.getString('profile_name') ?? "Usuario";
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();
    final items = [
      _SidebarItem("Home", Icons.dashboard_rounded, AppRouter.dashboard),
      _SidebarItem("Clientes", Icons.people_alt_rounded, AppRouter.clientes),
      _SidebarItem("Reportes", Icons.bar_chart_rounded, AppRouter.reportes),
      _SidebarItem(
        "Configuración",
        Icons.settings_rounded,
        AppRouter.configuracion,
      ),
    ];

    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: Container(
          width: 280,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 233, 241, 246), // Azul suave
                Color.fromARGB(255, 233, 241, 246), // Morado elegante
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
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
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onClose,
                    icon: const Icon(Icons.close_rounded, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // Perfil mejorado
              Center(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.15),
                            Colors.black.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(3),
                      child: ProfileAvatar(
                        imagePath: _profileImagePath,
                        size: 100,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRouter.perfil,
                          ).then((_) => _loadProfileData());
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _profileName ?? "",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),

              // Divisor elegante
              Container(
                height: 1,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.05),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),

              // Opciones con divisores sutiles
              Expanded(
                child: ListView.separated(
                  itemBuilder: (_, index) {
                    final item = items[index];
                    return _SidebarTile(item: item, onClose: widget.onClose);
                  },
                  separatorBuilder: (_, __) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black.withOpacity(0.1), Colors.black],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                  itemCount: items.length,
                ),
              ),

              // Cerrar sesión
              const SizedBox(height: 16),
              Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.05),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.logout_rounded, color: Colors.black),
                title: const Text(
                  "Cerrar sesión",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
                onTap: () async {
                  await _authService.logout(); // limpia el token
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRouter.login,
                    (route) => false, // elimina todas las rutas anteriores
                  );
                },
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
  final VoidCallback onClose;

  const _SidebarTile({required this.item, required this.onClose});

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
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: _hovered ? Colors.black.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: ListTile(
          leading: Icon(
            widget.item.icon,
            color: _hovered ? Colors.black : Colors.black,
          ),
          title: Text(
            widget.item.title,
            style: TextStyle(
              color: _hovered ? Colors.black : Colors.black,
              fontWeight: _hovered ? FontWeight.bold : FontWeight.w500,
              fontSize: 15.5,
            ),
          ),
          onTap: () {
            Navigator.pushNamed(context, widget.item.route);
            if (Navigator.canPop(context)) widget.onClose();
          },
        ),
      ),
    );
  }
}
