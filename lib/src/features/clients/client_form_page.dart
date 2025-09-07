import 'package:flutter/material.dart';
import 'package:crediahorro/src/constants/app_colors.dart';
import 'package:crediahorro/src/constants/app_text_styles.dart';
import 'package:crediahorro/src/layouts/app_scaffold.dart';

class ClientFormPage extends StatefulWidget {
  const ClientFormPage({super.key});

  @override
  State<ClientFormPage> createState() => _ClientFormPageState();
}

class _ClientFormPageState extends State<ClientFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Controladores
  final _nameController = TextEditingController();
  final _dniController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _amountController = TextEditingController();
  final _interestController = TextEditingController();
  final _cuotasController = TextEditingController();

  String _tipoPago = "Diario";
  DateTime? _fechaPrestamo;
  DateTime? _fechaInicio;

  Future<void> _pickDate(BuildContext context, bool isPrestamo) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (date != null) {
      setState(() {
        if (isPrestamo) {
          _fechaPrestamo = date;
        } else {
          _fechaInicio = date;
        }
      });
    }
  }

  Widget _sectionTitle(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(width: 8),
          Text(
            text,
            style: AppTextStyles.screenTitle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardWrapper({required Widget child}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 26),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(padding: const EdgeInsets.all(20), child: child),
    );
  }

  Widget _space() => const SizedBox(height: 18);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Nuevo Cliente",
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Datos del Cliente
              _cardWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle("Datos del Cliente", Icons.person_outline),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: "Nombre del cliente",
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) => value!.isEmpty
                          ? "Ingrese el nombre del cliente"
                          : null,
                    ),
                    _space(),
                    TextFormField(
                      controller: _dniController,
                      decoration: const InputDecoration(
                        labelText: "DNI",
                        prefixIcon: Icon(Icons.badge_outlined),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value!.isEmpty ? "Ingrese el DNI" : null,
                    ),
                    _space(),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: "Número de celular",
                        prefixIcon: Icon(Icons.phone_android),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    _space(),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: "Dirección",
                        prefixIcon: Icon(Icons.home_outlined),
                      ),
                    ),
                  ],
                ),
              ),

              // Datos del Préstamo
              _cardWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle("Datos del Préstamo", Icons.attach_money),
                    DropdownButtonFormField<String>(
                      value: _tipoPago,
                      items: const [
                        DropdownMenuItem(
                          value: "Diario",
                          child: Text("Diario"),
                        ),
                        DropdownMenuItem(
                          value: "Mensual",
                          child: Text("Mensual"),
                        ),
                      ],
                      onChanged: (value) => setState(() => _tipoPago = value!),
                      decoration: const InputDecoration(
                        labelText: "Tipo de pago",
                        prefixIcon: Icon(Icons.schedule_outlined),
                      ),
                    ),
                    _space(),
                    TextFormField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                        labelText: "Monto",
                        prefixIcon: Icon(Icons.monetization_on_outlined),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    _space(),
                    TextFormField(
                      controller: _interestController,
                      decoration: const InputDecoration(
                        labelText: "Interés (%)",
                        prefixIcon: Icon(Icons.percent),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    _space(),
                    TextFormField(
                      controller: _cuotasController,
                      decoration: const InputDecoration(
                        labelText: "Número de cuotas",
                        prefixIcon: Icon(Icons.list_alt_outlined),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    _space(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        _fechaPrestamo == null
                            ? "Fecha del préstamo"
                            : "Fecha del préstamo: ${_fechaPrestamo!.day}/${_fechaPrestamo!.month}/${_fechaPrestamo!.year}",
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () => _pickDate(context, true),
                    ),
                    _space(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        _fechaInicio == null
                            ? "Fecha de inicio de cuota"
                            : "Fecha de inicio: ${_fechaInicio!.day}/${_fechaInicio!.month}/${_fechaInicio!.year}",
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () => _pickDate(context, false),
                    ),
                  ],
                ),
              ),

              // Botón
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Cliente registrado ✅")),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: Text(
                    "Guardar Cliente",
                    style: AppTextStyles.body.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
