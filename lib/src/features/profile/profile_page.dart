import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crediahorro/src/common_widgets/profile_avatar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crediahorro/src/layouts/app_scaffold.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _savedImagePath;
  String? _tempImagePath;

  final _nameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _whatsappController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedImagePath = prefs.getString('profile_image');
      _nameController.text = prefs.getString('profile_name') ?? '';
      _lastnameController.text = prefs.getString('profile_lastname') ?? '';
      _whatsappController.text = prefs.getString('profile_whatsapp') ?? '';
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _tempImagePath = picked.path; // Solo vista previa
      });
    }
  }

  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'profile_image',
      _tempImagePath ?? _savedImagePath ?? '',
    );
    await prefs.setString('profile_name', _nameController.text);
    await prefs.setString('profile_lastname', _lastnameController.text);
    await prefs.setString('profile_whatsapp', _whatsappController.text);

    setState(() {
      _savedImagePath = _tempImagePath ?? _savedImagePath;
      _tempImagePath = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Perfil actualizado correctamente")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayImage = _tempImagePath ?? _savedImagePath;

    return AppScaffold(
      title: "Editar Perfil",
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ProfileAvatar(
              imagePath: displayImage,
              size: 120,
              onTap: _pickImage,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text("Seleccionar nueva foto"),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Nombre"),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _lastnameController,
              decoration: const InputDecoration(labelText: "Apellidos"),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _whatsappController,
              decoration: const InputDecoration(labelText: "N° de WhatsApp"),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text("Guardar cambios"),
            ),
          ],
        ),
      ),
    );
  }
}
