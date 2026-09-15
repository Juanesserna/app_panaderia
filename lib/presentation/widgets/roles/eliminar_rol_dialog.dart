import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../common/common_ui.dart';

/// Diálogo de confirmación de eliminación exclusivo de Roles.
///
/// A diferencia de `ConfirmarEliminarDialog` (usado por productos,
/// categorías, insumos y proveedores), este widget es independiente:
/// tiene su propio fondo y no depende del ColorScheme derivado del
/// `seedColor` de acento, así que no hereda el tinte rosado que
/// Material 3 aplica por defecto a los `Dialog`.
class EliminarRolDialog extends StatelessWidget {
  final String rolNombre;
  final VoidCallback? onConfirm;

  const EliminarRolDialog({
    super.key,
    required this.rolNombre,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    // Fondo propio del diálogo de roles: blanco fijo, sin heredar
    // tintes de Material 3 ni del tema global.
    final dialogBg = colors.surface;

    return Dialog(
      backgroundColor: dialogBg,
      surfaceTintColor: Colors.transparent,
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
                    'Eliminar rol',
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
              '¿Eliminar $rolNombre?',
              style: AppTextStyles.titleMd.copyWith(color: colors.text, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: 'Estás a punto de eliminar '),
                  TextSpan(text: rolNombre, style: AppTextStyles.bodyBold.copyWith(color: colors.text)),
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
                      'Esta acción es permanente y no se puede deshacer.',
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