import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:crediahorro/src/common_widgets/app_scaffold.dart';
import 'package:crediahorro/src/constants/app_colors.dart';
import 'package:crediahorro/src/features/loans/models/loans.dart';
import 'package:crediahorro/src/services/loan_service.dart';

class LoanEditPage extends StatefulWidget {
  final int clienteId;
  final int prestamoId;
  const LoanEditPage({
    super.key,
    required this.clienteId,
    required this.prestamoId,
  });

  @override
  State<LoanEditPage> createState() => _LoanEditPageState();
}

class _LoanEditPageState extends State<LoanEditPage> {
  final _formKey = GlobalKey<FormState>();
  final LoanService _loanService = LoanService();
  Prestamo? prestamo;
  bool _loading = false;

  final _montoController = TextEditingController();
  final _tasaController = TextEditingController();
  final _cuotasController = TextEditingController();
  final _fechaInicioController = TextEditingController();
  final _fechaCreacionController = TextEditingController();
  String _tipoCuota = "MENSUAL";
  String? _estado;

  @override
  void initState() {
    super.initState();
    _loadPrestamo();
  }

  Future<void> _loadPrestamo() async {
    setState(() => _loading = true);
    prestamo = await _loanService.getPrestamoById(widget.prestamoId);
    if (prestamo != null) {
      _montoController.text = prestamo!.monto.toString();
      _tasaController.text = prestamo!.tasaInteresMensual.toString();
      _cuotasController.text = prestamo!.numeroCuotas.toString();
      _tipoCuota = prestamo!.tipoCuota;
      _estado = prestamo!.estado;
      _fechaInicioController.text = _formatDateForUI(prestamo!.fechaInicio);
      _fechaCreacionController.text = _formatDateForUI(prestamo!.fechaCreacion);
    }
    setState(() => _loading = false);
  }

  String _formatDateForUI(String fecha) {
    try {
      final parsed = DateTime.parse(fecha);
      return DateFormat("dd/MM/yyyy").format(parsed);
    } catch (_) {
      return fecha;
    }
  }

  String _formatDateForBackend(String fechaUI) {
    try {
      final parsed = DateFormat("dd/MM/yyyy").parse(fechaUI);
      return DateFormat("yyyy-MM-dd").format(parsed);
    } catch (_) {
      return fechaUI;
    }
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final initialDate =
        DateTime.tryParse(_formatDateForBackend(controller.text)) ??
        DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale("es", "ES"),
    );
    if (picked != null) {
      controller.text = DateFormat("dd/MM/yyyy").format(picked);
    }
  }

  Future<void> _actualizar() async {
    if (!_formKey.currentState!.validate() || prestamo == null) return;

    setState(() => _loading = true);

    prestamo!
      ..monto = double.tryParse(_montoController.text) ?? prestamo!.monto
      ..tasaInteresMensual =
          double.tryParse(_tasaController.text) ?? prestamo!.tasaInteresMensual
      ..numeroCuotas =
          int.tryParse(_cuotasController.text) ?? prestamo!.numeroCuotas
      ..tipoCuota = _tipoCuota
      ..estado = _estado
      ..fechaInicio = _formatDateForBackend(_fechaInicioController.text)
      ..fechaCreacion = _formatDateForBackend(_fechaCreacionController.text);

    try {
      await _loanService.actualizarPrestamo(widget.prestamoId, prestamo!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Préstamo actualizado con éxito")),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Editar Préstamo",
      body: _loading || prestamo == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: _montoController,
                      label: "Monto del préstamo",
                      keyboard: TextInputType.number,
                    ),
                    _buildTextField(
                      controller: _tasaController,
                      label: "Interés mensual (%)",
                      keyboard: TextInputType.number,
                    ),
                    _buildTextField(
                      controller: _cuotasController,
                      label: "Número de cuotas",
                      keyboard: TextInputType.number,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text("Mensual"),
                            value: "MENSUAL",
                            groupValue: _tipoCuota,
                            onChanged: null, // 🔒 Desactiva interacción
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text("Diario"),
                            value: "DIARIO",
                            groupValue: _tipoCuota,
                            onChanged: null, // 🔒 Desactiva interacción
                          ),
                        ),
                      ],
                    ),

                    GestureDetector(
                      onTap: () => _selectDate(_fechaCreacionController),
                      child: AbsorbPointer(
                        child: _buildTextField(
                          controller: _fechaCreacionController,
                          label: "Fecha de creación",
                          hint: "dd/MM/yyyy",
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _selectDate(_fechaInicioController),
                      child: AbsorbPointer(
                        child: _buildTextField(
                          controller: _fechaInicioController,
                          label: "Fecha de inicio",
                          hint: "dd/MM/yyyy",
                        ),
                      ),
                    ),
                    IgnorePointer(
                      child: DropdownButtonFormField<String>(
                        value: _estado,
                        items: ["ACTIVO", "PAGADO"]
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged:
                            (_) {}, // No se usa porque IgnorePointer lo bloquea
                        decoration: InputDecoration(
                          labelText: "Estado",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: AppColors.surface,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                    Center(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _actualizar,
                        icon: const Icon(Icons.update, color: Colors.white),
                        label: const Text(
                          "Actualizar",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboard = TextInputType.text,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        validator: (v) =>
            (v == null || v.trim().isEmpty) ? "Ingrese $label" : null,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: AppColors.surface,
        ),
      ),
    );
  }
}
