import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Ícono de acción reutilizable (encendido/apagar, editar, eliminar)
/// para tarjetas de categoría.
class CategoriaActionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const CategoriaActionIcon({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: colors.surface2,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}