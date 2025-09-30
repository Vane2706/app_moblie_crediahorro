import 'package:crediahorro/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:crediahorro/src/constants/app_colors.dart';

class CuotasClientePage extends StatelessWidget {
  const CuotasClientePage({super.key});

  Color _estadoColor(String estado) {
    switch (estado) {
      case "PAGADA":
        return Colors.green;
      case "PENDIENTE":
        return Colors.orange;
      case "NO_PAGADA":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _mostrarAccionesCuota(BuildContext context, Map<String, dynamic> cuota) {
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
              leading: const Icon(Icons.payment, color: Colors.green),
              title: const Text("Pagar"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRouter.clientes);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🔹 Datos irreales, fijos
    final cuotas = [
      {
        "monto": "S/ 250.00",
        "fechaPago": "02/11/2025",
        "fechaPagada": "-",
        "estado": "PENDIENTE",
      },
      {
        "monto": "S/ 250.00",
        "fechaPago": "02/12/2025",
        "fechaPagada": "16/09/2025",
        "estado": "PENDIENTE",
      },
      {
        "monto": "S/ 250.00",
        "fechaPago": "02/01/2026",
        "fechaPagada": "-",
        "estado": "PENDIENTE",
      },
    ];

    // 🔹 Resumen irreales
    final totalAPagar = "S/ 750.00";
    final totalPagado = "S/ 0.00";
    final faltaPagar = "S/ 750.00";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Cuotas"),
        backgroundColor: AppColors.primary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            color: Colors.indigo.shade50,
            child: const ListTile(
              title: Text("Tipo de Cuota: Mensual"),
              subtitle: Text("Cuotas pendientes: 3"),
            ),
          ),
          const SizedBox(height: 10),
          ...cuotas.map((c) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 233, 241, 246),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                onTap: () => _mostrarAccionesCuota(context, c),
                leading: CircleAvatar(
                  radius: 22,
                  backgroundColor: _estadoColor(c["estado"]!),
                  child: const Icon(Icons.event_note, color: Colors.white),
                ),
                title: Text(
                  c["monto"]!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Fecha de Pago: ${c["fechaPago"]}"),
                    Text("Fecha Pagada: ${c["fechaPagada"]}"),
                    Text(
                      "Estado: ${c["estado"]}",
                      style: TextStyle(
                        color: _estadoColor(c["estado"]!),
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
          }),
          const Divider(),
          Card(
            color: Colors.indigo.shade50,
            child: ListTile(
              title: const Text("Resumen"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total a pagar: $totalAPagar"),
                  Text("Total pagado: $totalPagado"),
                  Text("Falta pagar: $faltaPagar"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
