import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // --- Colores Principales (Branding CrediAhorro) ---
  static const Color primary = Color(0xFF0D47A1); // Azul oscuro institucional
  static const Color secondary = Color.fromARGB(255, 66, 68, 70);
  static const Color accent = Color(0xFFFBC02D); // Amarillo dorado elegante

  // --- Colores de Branding (variantes suaves) ---
  static const Color lightBlue = Color(0xFF5472D3); // Azul más claro
  static const Color softYellow = Color(0xFFFFE082); // Amarillo pastel

  // --- Fondos y Superficies ---
  static const Color background = Color(0xFFF9FAFB); // Blanco muy suave
  static const Color surface =
      Colors.white; // Superficie clara (cards, contenedores)

  // --- Textos ---
  static const Color textPrimary = Color(0xFF1C2A35); // Gris oscuro
  static const Color textSecondary = Color(0xFF607D8B); // Gris azulado suave

  // --- Bordes e Inputs ---
  static const Color inputBorder = Color(0xFFCFD8DC); // Gris claro

  // --- Estados ---
  static const Color error = Color(0xFFD32F2F); // Rojo para errores
  static const Color success = Color(0xFF2E7D32); // Verde para éxito
  static const Color info = Color(0xFF0288D1); // Azul para información
}
