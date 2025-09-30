import 'package:crediahorro/src/features/admin/loans/edit/LoanEditPage.dart';
import 'package:crediahorro/src/features/admin/loans/view/bloc/LoansBloc.dart';
import 'package:crediahorro/src/features/admin/loans/view/bloc/LoansEvent.dart';
import 'package:crediahorro/src/features/admin/loans/view/bloc/LoansState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crediahorro/src/features/admin/clients/models/cliente.dart';
import 'package:crediahorro/src/routing/app_router.dart';
import 'package:crediahorro/src/constants/app_colors.dart';
import 'package:intl/intl.dart';

class LoansContent extends StatelessWidget {
  final int clienteId;
  const LoansContent({super.key, required this.clienteId});

  String _formatCurrency(double value) {
    return NumberFormat.currency(symbol: 'S/', locale: 'es_PE').format(value);
  }

  String _formatDate(String fecha) {
    try {
      final date = DateTime.parse(fecha);
      return DateFormat("dd/MM/yyyy").format(date);
    } catch (_) {
      return fecha;
    }
  }

  void _mostrarAccionesPrestamo(
    BuildContext context,
    Cliente cliente,
    prestamo,
  ) {
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
              leading: const Icon(Icons.visibility, color: AppColors.primary),
              title: const Text("Ver Cuotas"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  AppRouter.cuotas,
                  arguments: prestamo.id,
                );
              },
            ),
            if (prestamo.estado != "PAGADO")
              ListTile(
                leading: const Icon(Icons.edit, color: AppColors.primary),
                title: const Text("Editar Préstamo"),
                onTap: () async {
                  Navigator.pop(context);
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LoanEditPage(
                        clienteId: cliente.id!,
                        prestamoId: prestamo.id!,
                      ),
                    ),
                  );
                  if (result == true && context.mounted) {
                    context.read<LoansBloc>().add(LoansLoaded(clienteId));
                  }
                },
              ),

            if (prestamo.estado == "PAGADO")
              ListTile(
                leading: const Icon(Icons.file_present, color: Colors.green),
                title: const Text("Exportar Excel"),
                onTap: () {
                  Navigator.pop(context);
                  // Exportar Excel
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoansBloc, LoansState>(
      builder: (context, state) {
        if (state.status == LoansStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == LoansStatus.failure) {
          return Center(child: Text("Error: ${state.errorMessage}"));
        }

        if (state.cliente == null ||
            state.cliente!.prestamos == null ||
            state.cliente!.prestamos!.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 50,
                  color: Colors.grey,
                ),
                SizedBox(height: 10),
                Text(
                  "No existen préstamos",
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          );
        }

        final cliente = state.cliente!;
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: cliente.prestamos!.length,
          itemBuilder: (context, index) {
            final prestamo = cliente.prestamos![index];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 233, 241, 246),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                onTap: () =>
                    _mostrarAccionesPrestamo(context, cliente, prestamo),
                leading: const CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.blueGrey,
                  child: Icon(Icons.attach_money, color: Colors.white),
                ),
                title: Text(
                  _formatCurrency(prestamo.monto),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Interés: ${prestamo.tasaInteresMensual}%"),
                    Text("Cuotas: ${prestamo.numeroCuotas}"),
                    Text("Creación: ${_formatDate(prestamo.fechaCreacion)}"),
                    Text(
                      "Estado: ${prestamo.estado ?? "N/A"}",
                      style: TextStyle(
                        color: prestamo.estado == "PAGADO"
                            ? Colors.green
                            : Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                trailing: const Icon(
                  Icons.more_vert,
                  color: AppColors.textSecondary,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
