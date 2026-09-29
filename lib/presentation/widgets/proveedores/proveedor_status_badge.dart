import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Pastilla de color con el estado (Activo/Inactivo) de un proveedor,
/// igual al componente usado en el resto de módulos (ej.
/// `InsumoStatusBadge`, `ProductoStatusBadge`).
class ProveedorStatusBadge extends StatelessWidget {
  final bool activo;
  const ProveedorStatusBadge({super.key, required this.activo});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final fg = activo ? colors.success : colors.mutedFg;
    final bg = activo ? colors.successBg : colors.mutedBg;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 7, color: fg),
          const SizedBox(width: 5),
          Text(
            activo ? 'Activo' : 'Inactivo',
            style: AppTextStyles.captionBold.copyWith(color: fg, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
