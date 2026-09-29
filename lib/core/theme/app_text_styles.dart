import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tipografías de AlHorno: Outfit para todo el texto de UI y JetBrains Mono
/// para cifras/datos (montos, horas, códigos de pedido — la clase `.mono`
/// del CSS). Nadie debería usar TextStyle() suelto: siempre desde aquí.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle _outfit(double size, FontWeight weight) =>
      GoogleFonts.outfit(fontSize: size, fontWeight: weight, height: 1.2);

  static TextStyle _mono(double size, FontWeight weight) =>
      GoogleFonts.jetBrainsMono(fontSize: size, fontWeight: weight, height: 1.2);

  // Marca / encabezado
  static final brandTitle = _outfit(14, FontWeight.w700); // "AlHorno"
  static final brandSubtitle = _outfit(12, FontWeight.w400); // nombre del módulo

  // Pantallas de autenticación (login/registro): título grande con
// tipografía serif para el acento de marca ("Bienvenido de vuelta").
  static final authTitle = GoogleFonts.playfairDisplay(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      height: 1.2,
     );

  // Texto general
  static final titleLg = _outfit(18, FontWeight.w700);
  static final titleMd = _outfit(16, FontWeight.w700);
  static final bodyBold = _outfit(14, FontWeight.w600);
  static final bodyMedium = _outfit(14, FontWeight.w500);
  static final bodyRegular = _outfit(14, FontWeight.w400);
  static final caption = _outfit(12, FontWeight.w400);
  static final captionBold = _outfit(12, FontWeight.w600);
  static final tiny = _outfit(10, FontWeight.w600); // labels del bottom nav

  // Numérico / monoespaciado
  static final monoBody = _mono(14, FontWeight.w500);
  static final monoCaption = _mono(12, FontWeight.w400);
}
