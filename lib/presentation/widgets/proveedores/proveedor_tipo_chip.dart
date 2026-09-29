import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Chip pequeño no interactivo con el nombre de un tipo de proveedor
/// (ej. "Harinas", "Cereales"). Se usa tanto en la tarjeta del
/// directorio como en el detalle de un proveedor.
class ProveedorTipoChip extends StatelessWidget {
  final String label;
  const ProveedorTipoChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors.surface2,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colors.accent.withOpacity(0.25)),
      ),
      child: Text(
        label,
        style: AppTextStyles.captionBold.copyWith(
          color: colors.accent,
          fontSize: 11,
        ),
      ),
    );
  }
}
