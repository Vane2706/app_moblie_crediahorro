import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:crediahorro/src/common_widgets/app_scaffold.dart';
import 'package:crediahorro/src/constants/app_colors.dart';
import 'package:crediahorro/src/features/loans/models/loans.dart';
import 'package:crediahorro/src/services/loan_service.dart';

class LoanFormPage extends StatefulWidget {
  final int clienteId;
  const LoanFormPage({super.key, required this.clienteId});

  @override
  State<LoanFormPage> createState() => _LoanFormPageState();
}

class _LoanFormPageState extends State<LoanFormPage> {
  final _formKey = GlobalKey<FormState>();
  final LoanService _loanService = LoanService();

  final _montoController = TextEditingController();
  final _tasaController = TextEditingController();
  final _cuotasController = TextEditingController();
  final _fechaInicioController = TextEditingController();
  final _fechaCreacionController = TextEditingController();

  String _tipoCuota = "MENSUAL"; // default
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    // Por defecto, fecha de creación = hoy
    _fechaCreacionController.text = DateFormat(
      "dd/MM/yyyy",
    ).format(DateTime.now());
  }

  // Abrir datepicker y setear en formato dd/MM/yyyy
  Future<void> _seleccionarFecha(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale("es", "ES"),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat("dd/MM/yyyy").format(picked);
      });
    }
  }

  // Convertir fecha a yyyy-MM-dd (para backend)
  String _convertirFecha(String fechaDDMMYYYY) {
    if (fechaDDMMYYYY.trim().isEmpty) return fechaDDMMYYYY;
    try {
      final DateTime parsed = DateFormat("dd/MM/yyyy").parse(fechaDDMMYYYY);
      return DateFormat("yyyy-MM-dd").format(parsed);
    } catch (_) {
      return fechaDDMMYYYY;
    }
  }

  Future<void> _guardarPrestamo() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      final prestamo = Prestamo(
        monto: double.tryParse(_montoController.text) ?? 0,
        tasaInteresMensual: double.tryParse(_tasaController.text) ?? 0,
        numeroCuotas: int.tryParse(_cuotasController.text) ?? 0,
        tipoCuota: _tipoCuota,
        fechaInicio: _convertirFecha(_fechaInicioController.text.trim()),
        fechaCreacion: _convertirFecha(_fechaCreacionController.text.trim()),
      );

      await _loanService.crearPrestamo(widget.clienteId, prestamo);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Préstamo creado con éxito")),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error al guardar: $e")));
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "CrediAhorro",
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Datos del Préstamo",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Tipo de cuota
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text("Mensual"),
                            value: "MENSUAL",
                            groupValue: _tipoCuota,
                            onChanged: (value) =>
                                setState(() => _tipoCuota = value!),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text("Diario"),
                            value: "DIARIO",
                            groupValue: _tipoCuota,
                            onChanged: (value) =>
                                setState(() => _tipoCuota = value!),
                          ),
                        ),
                      ],
                    ),
                    _buildTextField(
                      _montoController,
                      "Monto del préstamo",
                      keyboard: TextInputType.number,
                    ),
                    _buildTextField(
                      _tasaController,
                      "Tasa de interés mensual (%)",
                      keyboard: TextInputType.number,
                    ),
                    _buildTextField(
                      _cuotasController,
                      "Número de cuotas",
                      keyboard: TextInputType.number,
                    ),

                    // Fecha de creación
                    GestureDetector(
                      onTap: () => _seleccionarFecha(_fechaCreacionController),
                      child: AbsorbPointer(
                        child: _buildTextField(
                          _fechaCreacionController,
                          "Fecha de creación",
                          hint: "dd/MM/yyyy",
                        ),
                      ),
                    ),

                    // Fecha de inicio
                    GestureDetector(
                      onTap: () => _seleccionarFecha(_fechaInicioController),
                      child: AbsorbPointer(
                        child: _buildTextField(
                          _fechaInicioController,
                          "Fecha de inicio",
                          hint: "dd/MM/yyyy",
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
                        onPressed: _guardarPrestamo,
                        icon: const Icon(Icons.save, color: Colors.white),
                        label: const Text(
                          "Guardar",
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

  // Campo genérico
  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboard = TextInputType.text,
    String? hint,
    bool required = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        validator: (value) {
          if (required && (value == null || value.trim().isEmpty)) {
            return "Ingrese $label";
          }
          return null;
        },
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
