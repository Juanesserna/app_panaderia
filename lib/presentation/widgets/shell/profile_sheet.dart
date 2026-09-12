import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'app_bottom_sheet.dart';

/// Abre el bottom sheet de perfil. Los datos son estáticos por ahora (aún
/// no hay backend); cuando exista un authProvider, reemplazar los valores
/// fijos de _ProfileSheetContent por datos del usuario real.
void showProfileSheet(BuildContext context) {
  showAppBottomSheet(context, builder: (context) => const _ProfileSheetContent());
}

class _ProfileSheetContent extends StatelessWidget {
  const _ProfileSheetContent();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: colors.accent,
                child: Text('JD', style: AppTextStyles.titleMd.copyWith(color: colors.accentFg)),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Juan Carlos Díaz', style: AppTextStyles.bodyBold.copyWith(color: colors.text)),
                  Text('Administrador', style: AppTextStyles.caption.copyWith(color: colors.textMuted)),
                  Text('jdiaz@alhorno.co', style: AppTextStyles.monoCaption.copyWith(color: colors.textMuted)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const AppDivider(),
          const SizedBox(height: 8),
          _ProfileTile(icon: Icons.person_outline, label: 'Ver perfil', onTap: () {}),
          _ProfileTile(icon: Icons.lock_outline, label: 'Cambiar contraseña', onTap: () {}),
          _ProfileTile(icon: Icons.settings_outlined, label: 'Configuración', onTap: () {}),
          const SizedBox(height: 8),
          const AppDivider(),
          const SizedBox(height: 8),
          _ProfileTile(
            icon: Icons.logout,
            label: 'Cerrar sesión',
            color: colors.danger,
            bold: true,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  final bool bold;
  const _ProfileTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 20, color: color ?? colors.textMuted),
              const SizedBox(width: 14),
              Text(
                label,
                style: (bold ? AppTextStyles.bodyBold : AppTextStyles.bodyMedium)
                    .copyWith(color: color ?? colors.text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
