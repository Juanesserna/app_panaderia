import 'package:flutter/material.dart';

/// Paleta de colores para el punto y la barra de cada categoría (en el
/// directorio y en "Distribución"). El índice se guarda en
/// `Categoria.colorIndex`, así que el color se mantiene estable aunque
/// cambie el orden de la lista.
const List<Color> kCategoriaPalette = [
  Color(0xFFC1592F), // naranja (acento AlHorno) — ej. Panes
  Color(0xFF6E8B3D), // verde — ej. Bollería
  Color(0xFF7E57C2), // morado — ej. Tortas
  Color(0xFFC0392B), // rojo — ej. Galletas
  Color(0xFF2E7D8C), // teal — ej. Postres
  Color(0xFFF2A93C), // ámbar
];

Color categoriaColor(int index) =>
    kCategoriaPalette[index % kCategoriaPalette.length];
