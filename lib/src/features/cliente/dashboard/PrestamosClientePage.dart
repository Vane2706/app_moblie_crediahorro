import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:crediahorro/src/constants/app_colors.dart';
import 'package:crediahorro/src/routing/app_router.dart';

class PrestamosClientePage extends StatelessWidget {
  const PrestamosClientePage({super.key});

  String _formatCurrency(dynamic value) {
    double val;
    if (value is num) {
      val = value.toDouble();
    } else {
      val = double.tryParse(value?.toString() ?? '') ?? 0.0;
    }
    return NumberFormat.currency(symbol: 'S/', locale: 'es_PE').format(val);
  }

  String _formatDate(dynamic fecha) {
    if (fecha == null) return "-";
    if (fecha is DateTime) {
      return DateFormat("dd/MM/yyyy").format(fecha);
    }
    if (fecha is String) {
      try {
        final parsed = DateTime.parse(fecha);
        return DateFormat("dd/MM/yyyy").format(parsed);
      } catch (_) {
        return fecha;
      }
    }
    return fecha.toString();
  }

  // Mostrar opciones al tocar un préstamo (incluye "Ver cuotas")
  void _mostrarOpcionesPrestamo(
    BuildContext context,
    Map<String, dynamic> prestamo,
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
              leading: const Icon(Icons.list_alt, color: AppColors.primary),
              title: const Text("Ver Cuotas"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRouter.cuotasclientes);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Map<String, dynamic>> prestamos,
  ) {
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
        child: ExpansionTile(
          initiallyExpanded: true,
          tilePadding: const EdgeInsets.symmetric(horizontal: 12),
          backgroundColor: AppColors.surface,
          collapsedBackgroundColor: AppColors.surface,
          trailing: const SizedBox.shrink(),
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
            ],
          ),
          children: prestamos.isEmpty
              ? [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: const [
                        Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 40,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Sin préstamos en esta sección",
                          style: TextStyle(
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]
              : prestamos
                    .map(
                      (prestamo) => Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 233, 241, 246),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          onTap: () =>
                              _mostrarOpcionesPrestamo(context, prestamo),
                          leading: const CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.blueGrey,
                            child: Icon(
                              Icons.attach_money,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            _formatCurrency(prestamo["monto"]),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Interés: ${prestamo["interes"]}%"),
                              Text("Cuotas: ${prestamo["cuotas"]}"),
                              Text(
                                "Creación: ${_formatDate(prestamo["fecha"])}",
                              ),
                              Text(
                                "Estado: ${prestamo["estado"]}",
                                style: TextStyle(
                                  color: prestamo["estado"] == "PAGADO"
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
                      ),
                    )
                    .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🔹 Tipos explícitos: evitar List<dynamic> que generan errores de tipo
    final List<Map<String, dynamic>> hoy = <Map<String, dynamic>>[];
    final List<Map<String, dynamic>> anteriores = <Map<String, dynamic>>[];
    final List<Map<String, dynamic>> pagados = <Map<String, dynamic>>[];

    final List<Map<String, dynamic>> proximos = <Map<String, dynamic>>[
      {
        "monto": 600.00,
        "interes": 5,
        "cuotas": 3,
        "fecha": DateTime.now().add(const Duration(days: 2)),
        "estado": "PENDIENTE",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Préstamos"),
        backgroundColor: AppColors.primary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _buildSection(context, "Hoy", hoy),
          _buildSection(context, "Próximos", proximos),
          _buildSection(context, "Anteriores", anteriores),
          _buildSection(context, "Pagados", pagados),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
