import 'package:crediahorro/src/common_widgets/app_scaffold.dart';
import 'package:crediahorro/src/constants/app_colors.dart';
import 'package:crediahorro/src/features/cuotas/models/cuota.dart';
import 'package:crediahorro/src/services/cuota_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CuotasPage extends StatefulWidget {
  final int prestamoId;

  const CuotasPage({super.key, required this.prestamoId});

  @override
  State<CuotasPage> createState() => _CuotasPageState();
}

class _CuotasPageState extends State<CuotasPage> {
  final CuotaService _service = CuotaService();
  late Future<PrestamoCuotasResponse> _future;

  int cuotasPendientes = 0;
  double totalAPagar = 0;
  double totalPagado = 0;
  double faltaPagar = 0;

  @override
  void initState() {
    super.initState();
    _future = _service.getCuotasByPrestamo(widget.prestamoId);
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _service.getCuotasByPrestamo(widget.prestamoId);
    });
  }

  void _calcularTotales(List<Cuota> cuotas) {
    totalAPagar = cuotas.fold(0, (s, c) => s + c.montoCuota);
    totalPagado = cuotas
        .where((c) => c.estado == "PAGADA")
        .fold(0, (s, c) => s + c.montoCuota);
    faltaPagar = cuotas
        .where((c) => c.estado == "PENDIENTE")
        .fold(0, (s, c) => s + c.montoCuota);
    cuotasPendientes = cuotas.where((c) => c.estado == "PENDIENTE").length;
  }

  String _formatCurrency(double value) {
    return NumberFormat.currency(symbol: 'S/', locale: 'es_PE').format(value);
  }

  String _formatDate(String? fecha) {
    if (fecha == null) return "-";
    try {
      final date = DateTime.parse(fecha);
      return DateFormat("dd/MM/yyyy").format(date);
    } catch (_) {
      return fecha;
    }
  }

  void _mostrarAccionesCuota(Cuota cuota, bool habilitarPagar) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          children: [
            if (cuota.estado == "PENDIENTE") ...[
              ListTile(
                leading: const Icon(Icons.payment, color: Colors.green),
                title: const Text("Pagar"),
                onTap: habilitarPagar
                    ? () async {
                        Navigator.pop(context);
                        await _service.pagarCuota(cuota.id);
                        _refresh();
                      }
                    : null,
              ),
              ListTile(
                leading: const Icon(Icons.cancel, color: Colors.red),
                title: const Text("No pagar"),
                onTap: () async {
                  Navigator.pop(context);
                  await _service.marcarCuotaNoPagada(cuota.id);
                  _refresh();
                },
              ),
              ListTile(
                leading: const Icon(Icons.money_off, color: Colors.blue),
                title: const Text("Pago Parcial"),
                onTap: () {
                  Navigator.pop(context);
                  _mostrarDialogoPagoParcial(cuota);
                },
              ),
            ],
            if (cuota.estado != "PENDIENTE")
              ListTile(
                leading: const Icon(Icons.info, color: Colors.grey),
                title: const Text("Esta cuota ya fue gestionada"),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _mostrarDialogoPagoParcial(Cuota c) async {
    final controller = TextEditingController();
    final monto = await showDialog<double>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Pago Parcial"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Ingrese el monto"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              final val = double.tryParse(controller.text);
              if (val != null && val > 0) {
                Navigator.pop(context, val);
              }
            },
            child: const Text("Aceptar"),
          ),
        ],
      ),
    );

    if (monto != null) {
      await _service.pagarCuotaParcial(c.id, monto);
      _refresh();
    }
  }

  bool _esPagarHabilitado(List<Cuota> cuotas, int i) {
    final cuota = cuotas[i];
    if (cuota.estado != "PENDIENTE") return false;
    if (i == 0) return true;
    final anterior = cuotas[i - 1];
    return anterior.estado == "PAGADA" ||
        anterior.estado == "ADELANTADO" ||
        anterior.tipoPago == "PAGO_INCOMPLETO";
  }

  Color _estadoColor(String? estado) {
    switch (estado) {
      case "PAGADA":
        return Colors.green;
      case "PENDIENTE":
        return Colors.orange;
      case "ADELANTADO":
        return Colors.blue;
      case "NO_PAGADA":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "CREDIAHORRO",
      body: FutureBuilder<PrestamoCuotasResponse>(
        future: _future,
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text("Error: ${snap.error}"));
          }

          final data = snap.data!;
          final cuotas = data.cuotas;
          _calcularTotales(cuotas);

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                Card(
                  color: Colors.indigo.shade50,
                  child: ListTile(
                    title: Text("Tipo de Cuota: ${data.tipoCuota ?? "-"}"),
                    subtitle: Text("Cuotas pendientes: $cuotasPendientes"),
                  ),
                ),
                const SizedBox(height: 10),
                ...cuotas.asMap().entries.map((entry) {
                  final i = entry.key;
                  final c = entry.value;
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 233, 241, 246),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      onTap: () => _mostrarAccionesCuota(
                        c,
                        _esPagarHabilitado(cuotas, i),
                      ),
                      leading: CircleAvatar(
                        radius: 22,
                        backgroundColor: _estadoColor(c.estado),
                        child: const Icon(
                          Icons.event_note,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        _formatCurrency(c.montoCuota),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Fecha de Pago: ${_formatDate(c.fechaPago)}"),
                          Text("Fecha Pagada: ${_formatDate(c.fechaPagada)}"),
                          Text(
                            "Estado: ${c.estado ?? "N/A"}",
                            style: TextStyle(
                              color: _estadoColor(c.estado),
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
                        Text("Total a pagar: ${_formatCurrency(totalAPagar)}"),
                        Text("Total pagado: ${_formatCurrency(totalPagado)}"),
                        Text("Falta pagar: ${_formatCurrency(faltaPagar)}"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
