import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../common/common_ui.dart';

/// Diálogo reutilizable de confirmación de eliminación.
///
/// Se abre con:
///   showDialog(
///     context: context,
///     builder: (_) => ConfirmarEliminarDialog(
///       title: 'Eliminar producto',
///       itemName: producto.nombre,
///       warningText: 'Este producto será eliminado permanentemente del sistema.',
///     ),
///   );
class ConfirmarEliminarDialog extends StatelessWidget {
  final String title;
  final String itemName;
  final String warningText;
  final VoidCallback? onConfirm;
  const ConfirmarEliminarDialog({
    super.key,
    required this.title,
    required this.itemName,
    required this.warningText,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.titleMd.copyWith(color: colors.text),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: colors.textMuted),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Divider(color: colors.border, height: 1),
            const SizedBox(height: 16),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: colors.dangerBg,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.delete_outline, size: 28, color: colors.danger),
            ),
            const SizedBox(height: 16),
            Text(
              '¿Eliminar $itemName?',
              style: AppTextStyles.titleMd.copyWith(color: colors.text, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: 'Estás a punto de eliminar '),
                  TextSpan(text: itemName, style: AppTextStyles.bodyBold.copyWith(color: colors.text)),
                  const TextSpan(text: '. Esta acción no se puede deshacer.'),
                ],
              ),
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(color: colors.textMuted),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.dangerBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: colors.danger.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, size: 16, color: colors.danger),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      warningText,
                      style: AppTextStyles.caption.copyWith(color: colors.danger),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Divider(color: colors.border, height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ActionBtn(
                    label: 'Cancelar',
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ActionBtn(
                    label: 'Sí, eliminar',
                    variant: ActionBtnVariant.accent,
                    onTap: () {
                      Navigator.pop(context);
                      if (onConfirm != null) {
                        onConfirm!();
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Próximamente')),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
