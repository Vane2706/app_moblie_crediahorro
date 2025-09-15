import 'package:crediahorro/src/common_widgets/app_logo.dart';
import 'package:crediahorro/src/constants/app_colors.dart';
import 'package:crediahorro/src/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class ClientHomeScreen extends StatelessWidget {
  const ClientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_ClientItem> items = [
      _ClientItem(
        title: "Mis Préstamos",
        icon: Icons.account_balance_wallet_rounded,
        onTap: () {
          // Navegar a la lista de préstamos del cliente
        },
      ),
      _ClientItem(
        title: "Mis Cuotas",
        icon: Icons.payment_rounded,
        onTap: () {
          // Navegar a cuotas pendientes
        },
      ),
      _ClientItem(
        title: "Realizar Pago",
        icon: Icons.credit_card_rounded,
        onTap: () {
          // Navegar a pantalla de pago
        },
      ),
      _ClientItem(
        title: "Perfil",
        icon: Icons.person_rounded,
        onTap: () {
          // Navegar a perfil del cliente
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Panel del Cliente"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const AppLogo(size: 90),
          const SizedBox(height: 10),
          Text(
            "Bienvenido, Cliente",
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                itemCount: items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  return _ClientCard(item: items[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClientItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  _ClientItem({required this.title, required this.icon, required this.onTap});
}

class _ClientCard extends StatefulWidget {
  final _ClientItem item;

  const _ClientCard({required this.item});

  @override
  State<_ClientCard> createState() => _ClientCardState();
}

class _ClientCardState extends State<_ClientCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.item.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF43CEA2), Color(0xFF185A9D)], // verde/azul
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.item.icon, size: 45, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                widget.item.title,
                style: AppTextStyles.body.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
