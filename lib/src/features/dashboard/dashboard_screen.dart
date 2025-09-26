import 'package:crediahorro/src/features/clients/models/cliente.dart';
import 'package:crediahorro/src/routing/app_router.dart';
import 'package:crediahorro/src/services/cliente_service.dart';
import 'package:flutter/material.dart';
import 'package:crediahorro/src/common_widgets/app_scaffold.dart';
import 'package:crediahorro/src/constants/app_colors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ClienteService _clienteService = ClienteService();
  List<Cliente> _clientes = [];
  bool _loading = true;

  // Secciones
  List<Cliente> _anteriores = [];
  List<Cliente> _hoy = [];
  List<Cliente> _proximos = [];

  @override
  void initState() {
    super.initState();
    _fetchClientes();
  }

  void _fetchClientes() async {
    try {
      final data = await _clienteService.getClientes();
      _clasificarClientes(data);
      setState(() {
        _clientes = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error cargando clientes: $e")));
    }
  }

  void _clasificarClientes(List<Cliente> clientes) {
    final hoy = DateTime.now();
    final hoyDate = DateTime(hoy.year, hoy.month, hoy.day);

    _anteriores.clear();
    _hoy.clear();
    _proximos.clear();

    for (final cliente in clientes) {
      if (cliente.prestamos == null || cliente.prestamos!.isEmpty) continue;

      for (final prestamo in cliente.prestamos!) {
        if (prestamo.cuotas == null) continue;

        for (final cuota in prestamo.cuotas!) {
          if (cuota.estado != "PENDIENTE") continue;

          final fecha = DateTime.tryParse(cuota.fechaPago);
          if (fecha == null) continue;

          final fechaPago = DateTime(fecha.year, fecha.month, fecha.day);
          final diferencia = fechaPago.difference(hoyDate).inDays;

          if (fechaPago.isAtSameMomentAs(hoyDate)) {
            _hoy.add(cliente);
            break;
          } else if (diferencia > 0 && diferencia <= 3) {
            _anteriores.add(cliente);
            break;
          } else if (fechaPago.isBefore(hoyDate)) {
            _proximos.add(cliente);
            break;
          }
        }
      }
    }
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

  Widget _buildSection(String title, List<Cliente> clientes) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: AppColors.transparent,
        splashColor: AppColors.transparent,
        highlightColor: AppColors.transparent,
        hoverColor: AppColors.transparent,
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: StatefulBuilder(
          builder: (context, setStateSB) {
            bool expanded = true;
            return ExpansionTile(
              initiallyExpanded: true,
              tilePadding: const EdgeInsets.symmetric(horizontal: 12),
              backgroundColor: AppColors.surface,
              collapsedBackgroundColor: AppColors.surface,
              trailing: const SizedBox.shrink(), // quitamos ícono de la derecha
              onExpansionChanged: (isOpen) {
                setStateSB(() {
                  expanded = isOpen;
                });
              },
              title: Row(
                children: [
                  const SizedBox(width: 6),
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  AnimatedRotation(
                    turns: expanded ? 0.25 : 0.0,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(
                      Icons.arrow_right,
                      size: 22,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              children: clientes.isEmpty
                  ? [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: const [
                            Icon(
                              Icons.people_outline,
                              size: 40,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Sin clientes en esta sección",
                              style: TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]
                  : clientes
                        .map(
                          (cliente) => Container(
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
                                cliente.telefonoWhatsapp,
                                style: const TextStyle(fontSize: 13),
                              ),
                              trailing: const Icon(
                                Icons.more_vert,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        )
                        .toList(),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "CREDIAHORRO",
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(12),
              children: [
                _buildSection("Anterior", _anteriores),
                _buildSection("Hoy", _hoy),
                _buildSection("Próximo", _proximos),
                const SizedBox(height: 25),
                Center(
                  child: GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, AppRouter.clientes),
                    child: const Text(
                      "Verifique todos los clientes",
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
    );
  }
}
