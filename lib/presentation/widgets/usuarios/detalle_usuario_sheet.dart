import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../common/common_ui.dart';
import 'usuario_tile.dart';
import 'usuario_status_badge.dart';

/// Se abre con:
///   showAppBottomSheet(context, title: usuario.nombre, builder: (_) => DetalleUsuarioSheet(usuario: usuario));
class DetalleUsuarioSheet extends StatelessWidget {
  final Usuario usuario;
  const DetalleUsuarioSheet({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppFieldDisplay(
                    label: 'ID/NIT',
                    value: Text(usuario.nit, style: AppTextStyles.monoBody.copyWith(fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ),
                Expanded(
                  child: AppFieldDisplay(label: 'ROL', value: Text(usuario.rol.label, style: AppTextStyles.bodyBold)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: AppFieldDisplay(
                    label: 'EMAIL',
                    value: Text(usuario.email, style: AppTextStyles.bodyMedium.copyWith(color: colors.accent)),
                  ),
                ),
                Expanded(
                  child: AppFieldDisplay(label: 'TELÉFONO', value: Text(usuario.telefono)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text('Estado', style: AppTextStyles.caption.copyWith(color: colors.textMuted)),
                const SizedBox(width: 8),
                UsuarioStatusBadge(estado: usuario.estado),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'PERMISOS (${usuario.permisos.length})',
              style: AppTextStyles.tiny.copyWith(color: colors.textMuted, letterSpacing: 0.4),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: usuario.permisos.map((p) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: colors.surface2,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: colors.accent.withOpacity(0.3)),
                  ),
                  child: Text(p, style: AppTextStyles.bodyMedium.copyWith(color: colors.accent)),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}