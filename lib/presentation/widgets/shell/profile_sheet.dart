import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_roles.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../riverpod/auth_providers.dart';
import 'app_bottom_sheet.dart';
import '../../pages/login_page.dart';

/// Abre el bottom sheet de perfil con los datos del usuario autenticado.
void showProfileSheet(BuildContext context) {
  showAppBottomSheet(context, builder: (context) => const _ProfileSheetContent());
}

class _ProfileSheetContent extends ConsumerWidget {
  const _ProfileSheetContent();

  String _iniciales(String nombre) {
    final partes = nombre.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (partes.isEmpty) return '?';
    if (partes.length == 1) return partes.first.substring(0, 1).toUpperCase();
    return (partes.first.substring(0, 1) + partes.last.substring(0, 1)).toUpperCase();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final usuario = ref.watch(authProvider);

    final nombre = usuario?.nombre ?? 'Invitado';
    final rolLabel = usuario?.rol.label ?? 'Sin sesión';
    final correo = usuario?.correo ?? '—';

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
                child: Text(_iniciales(nombre), style: AppTextStyles.titleMd.copyWith(color: colors.accentFg)),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(nombre, style: AppTextStyles.bodyBold.copyWith(color: colors.text)),
                  Text(rolLabel, style: AppTextStyles.caption.copyWith(color: colors.textMuted)),
                  Text(correo, style: AppTextStyles.monoCaption.copyWith(color: colors.textMuted)),
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
           onTap: () {
              ref.read(authProvider.notifier).logout();
              final navigator = Navigator.of(context);
              navigator.pop();
              navigator.pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false,
                );
             },
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