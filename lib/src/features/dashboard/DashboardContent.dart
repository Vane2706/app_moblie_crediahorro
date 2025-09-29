import 'package:crediahorro/src/domain/utils/Resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crediahorro/src/constants/app_colors.dart';
import 'package:crediahorro/src/features/clients/models/cliente.dart';
import 'package:crediahorro/src/features/dashboard/bloc/DashboardBloc.dart';
import 'package:crediahorro/src/features/dashboard/bloc/DashboardEvent.dart';
import 'package:crediahorro/src/features/dashboard/bloc/DashboardState.dart';
import 'package:crediahorro/src/routing/app_router.dart';

class DashboardContent extends StatefulWidget {
  const DashboardContent({super.key});

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(DashboardLoadClientes());
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
              trailing: const SizedBox.shrink(),
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
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state.status?.status == Status.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status?.status == Status.error) {
          return Center(child: Text(state.status?.message ?? "Error"));
        }

        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            _buildSection("Anterior", state.anteriores),
            _buildSection("Hoy", state.hoy),
            _buildSection("Próximo", state.proximos),
            const SizedBox(height: 25),
            Center(
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRouter.clientes),
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
        );
      },
    );
  }
}
