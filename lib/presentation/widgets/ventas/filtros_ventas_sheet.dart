import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../common/common_ui.dart';

/// Contenido del bottom sheet "Filtros". Por ahora es un placeholder
/// (igual que en el diseño web); cuando se definan los filtros reales
/// (por estado, método de pago, rango de fechas, etc.) se reemplaza el
/// contenido de este widget sin tocar quién lo abre.
class FiltrosVentasSheet extends StatelessWidget {
  const FiltrosVentasSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Opciones de filtrado...', style: AppTextStyles.bodyRegular.copyWith(color: colors.textMuted)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: ActionBtn(label: 'Limpiar', onTap: () => Navigator.of(context).pop())),
              const SizedBox(width: 8),
              Expanded(
                child: ActionBtn(
                  label: 'Aplicar filtros',
                  variant: ActionBtnVariant.accent,
                  onTap: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
