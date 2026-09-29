import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Chip con checkbox para mostrar (o editar) si un módulo está incluido
/// en un rol. Si [onTap] es `null`, se muestra en modo solo lectura
/// (usado en el detalle); si tiene [onTap], es interactivo (usado en el
/// formulario de crear/editar).
class ModuloAccessChip extends StatelessWidget {
  final String label;
  final bool checked;
  final VoidCallback? onTap;

  const ModuloAccessChip({
    super.key,
    required this.label,
    required this.checked,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final bg = checked ? colors.accent.withOpacity(0.12) : colors.surface2;
    final border = checked ? colors.accent : colors.border;
    final fg = checked ? colors.accent : colors.textMuted;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              Icon(
                checked ? Icons.check_box : Icons.check_box_outline_blank,
                size: 16,
                color: fg,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.caption.copyWith(color: fg),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}