import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/insumo_inventario.dart';

/// Pastilla de color con el nivel de stock de un insumo, igual al
/// componente usado en el resto de módulos (ej. `VentaStatusBadge`,
/// `OrdenStatusBadge`).
class InsumoStatusBadge extends StatelessWidget {
  final NivelStock nivel;
  const InsumoStatusBadge({super.key, required this.nivel});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    Color fg;
    Color bg;
    IconData icon;
    switch (nivel) {
      case NivelStock.normal:
        fg = colors.success;
        bg = colors.successBg;
        icon = Icons.check_circle;
        break;
      case NivelStock.stockBajo:
        fg = colors.warning;
        bg = colors.warningBg;
        icon = Icons.error;
        break;
      case NivelStock.agotado:
        fg = colors.danger;
        bg = colors.dangerBg;
        icon = Icons.cancel;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: fg),
          const SizedBox(width: 4),
          Text(
            nivel.label,
            style: AppTextStyles.captionBold.copyWith(color: fg, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
