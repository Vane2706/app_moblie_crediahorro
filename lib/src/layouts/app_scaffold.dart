import 'package:flutter/material.dart';
import 'package:crediahorro/src/common_widgets/app_sidebar.dart';
import 'package:crediahorro/src/constants/app_colors.dart';
import 'package:crediahorro/src/constants/app_text_styles.dart';

class AppScaffold extends StatefulWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.floatingActionButton,
  });

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  bool _isSidebarOpen = false;

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Contenido principal
        Scaffold(
          appBar: AppBar(
            title: Text(
              widget.title,
              style: AppTextStyles.screenTitle.copyWith(
                color: AppColors.primary,
              ),
            ),
            backgroundColor: Colors.white,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.menu, color: AppColors.primary),
              onPressed: _toggleSidebar,
            ),
          ),
          body: widget.body,
          floatingActionButton: widget.floatingActionButton,
        ),

        // Sidebar overlay
        if (_isSidebarOpen) ...[
          GestureDetector(
            onTap: _toggleSidebar,
            child: Container(
              color: Colors.black54, // Fondo oscuro transparente
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: AppSidebar(onClose: _toggleSidebar),
          ),
        ],
      ],
    );
  }
}
