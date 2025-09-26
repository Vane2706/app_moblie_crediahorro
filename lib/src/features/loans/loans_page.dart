import 'package:crediahorro/src/features/clients/models/cliente.dart';
import 'package:crediahorro/src/features/loans/loan_edit_page.dart';
import 'package:crediahorro/src/features/loans/loan_form_page.dart';
import 'package:crediahorro/src/routing/app_router.dart';
import 'package:crediahorro/src/services/cliente_service.dart';
import 'package:crediahorro/src/common_widgets/app_scaffold.dart';
import 'package:crediahorro/src/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LoansPage extends StatefulWidget {
  final int clienteId;
  const LoansPage({super.key, required this.clienteId});

  @override
  State<LoansPage> createState() => _LoansPageState();
}

class _LoansPageState extends State<LoansPage> {
  late Future<Cliente> _clienteFuture;
  final ClienteService _clienteService = ClienteService();

  @override
  void initState() {
    super.initState();
    _clienteFuture = _clienteService.getClienteById(widget.clienteId);
  }

  void _reload() {
    setState(() {
      _clienteFuture = _clienteService.getClienteById(widget.clienteId);
    });
  }

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

  void _mostrarAccionesPrestamo(Cliente cliente, prestamo) {
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
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LoanEditPage(
                        clienteId: cliente.id!,
                        prestamoId: prestamo.id!,
                      ),
                    ),
                  );
                  _reload();
                },
              ),
            if (prestamo.estado == "PAGADO")
              ListTile(
                leading: const Icon(Icons.file_present, color: Colors.green),
                title: const Text("Exportar Excel"),
                onTap: () {
                  Navigator.pop(context);
                  // 👉 Exportar Excel
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "CREDIAHORRO",
      body: FutureBuilder<Cliente>(
        future: _clienteFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData ||
              snapshot.data!.prestamos == null ||
              snapshot.data!.prestamos!.isEmpty) {
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

          final cliente = snapshot.data!;

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
                  onTap: () => _mostrarAccionesPrestamo(cliente, prestamo),
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LoanFormPage(clienteId: widget.clienteId),
            ),
          );
          _reload();
        },
        backgroundColor: Colors.white,
        icon: const Icon(Icons.add, color: Colors.black),
        label: const Text("Agregar", style: TextStyle(color: Colors.black)),
      ),
    );
  }
}
