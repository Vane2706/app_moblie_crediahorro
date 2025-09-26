import 'package:flutter/material.dart';
import 'package:crediahorro/src/common_widgets/app_scaffold.dart';
import 'package:crediahorro/src/constants/app_colors.dart';
import 'package:crediahorro/src/services/cliente_service.dart';
import 'package:crediahorro/src/features/clients/models/cliente.dart';

class ClienteEditPage extends StatefulWidget {
  final int clienteId;

  const ClienteEditPage({super.key, required this.clienteId});

  @override
  State<ClienteEditPage> createState() => _ClienteEditPageState();
}

class _ClienteEditPageState extends State<ClienteEditPage> {
  final _formKey = GlobalKey<FormState>();
  final ClienteService _clienteService = ClienteService();

  final _nombreController = TextEditingController();
  final _dniController = TextEditingController();
  final _direccionController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _correoController = TextEditingController();

  bool _loading = true;
  Cliente? _cliente;

  @override
  void initState() {
    super.initState();
    _loadCliente();
  }

  void _loadCliente() async {
    try {
      final cliente = await _clienteService.getClienteById(widget.clienteId);
      setState(() {
        _cliente = cliente;
        _nombreController.text = cliente.nombre;
        _dniController.text = cliente.dni;
        _direccionController.text = cliente.direccion;
        _whatsappController.text = cliente.telefonoWhatsapp;
        _correoController.text = cliente.correoElectronico;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error cargando cliente: $e")));
    }
  }

  void _actualizarCliente() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final updatedCliente = Cliente(
        id: _cliente!.id,
        nombre: _nombreController.text.trim(),
        dni: _dniController.text.trim(),
        direccion: _direccionController.text.trim(),
        telefonoWhatsapp: _whatsappController.text.trim(),
        correoElectronico: _correoController.text.trim(),
        prestamos: _cliente!.prestamos,
      );

      await _clienteService.updateCliente(widget.clienteId, updatedCliente);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cliente actualizado con éxito")),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error al actualizar: $e")));
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
                    _buildTextField(_nombreController, "Nombre"),
                    _buildTextField(_dniController, "DNI"),
                    _buildTextField(_direccionController, "Dirección"),
                    _buildTextField(_whatsappController, "WhatsApp"),
                    _buildCorreoField(), // <-- campo especial para correo
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
                        onPressed: _actualizarCliente,
                        icon: const Icon(Icons.save, color: Colors.white),
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

  /// Campos normales (obligatorios)
  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboard = TextInputType.text,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        validator: (value) =>
            value == null || value.isEmpty ? "Ingrese $label" : null,
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

  /// Campo especial para correo (opcional)
  Widget _buildCorreoField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: _correoController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return null; // ✅ opcional, no valida vacío
          }
          // ✅ si no está vacío, valida formato de email
          final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
          if (!emailRegex.hasMatch(value)) {
            return "Ingrese un correo válido";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "Correo Electrónico (opcional)",
          hintText: "ejemplo@correo.com",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: AppColors.surface,
        ),
      ),
    );
  }
}
