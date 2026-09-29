import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_modules.dart'; // <--- IMPORT QUE FALTABA
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../riverpod/shell_providers.dart';
import 'notifications_sheet.dart';
import 'profile_sheet.dart';

/// Header fijo en la parte superior de toda la app: logo + módulo activo,
/// toggle de tema, notificaciones y perfil.
class AppHeader extends ConsumerWidget implements PreferredSizeWidget {
  const AppHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final module = ref.watch(currentModuleProvider);
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.border)),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: colors.surface2,
              child: ClipOval(
                child: Image.asset(
                  isDark ? 'assets/img/logo_oscuro.png' : 'assets/img/logo_claro.png',
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('AlHorno', style: AppTextStyles.brandTitle.copyWith(color: colors.text)),
                  Text(
                    module.label, // Ya funcionará correctamente
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.brandSubtitle.copyWith(color: colors.textMuted),
                  ),
                ],
              ),
            ),
            _CircleIconButton(
              icon: isDark ? Icons.wb_sunny_outlined : Icons.nightlight_outlined,
              onTap: () => ref.read(themeModeProvider.notifier).toggleTheme(),
            ),
            const SizedBox(width: 8),
            _CircleIconButton(
              icon: Icons.notifications_outlined,
              showDot: true,
              onTap: () => showNotificationsSheet(context),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => showProfileSheet(context),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: colors.accent,
                child: Text('JD', style: AppTextStyles.captionBold.copyWith(color: colors.accentFg)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool showDot;
  const _CircleIconButton({required this.icon, required this.onTap, this.showDot = false});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: colors.surface2,
            child: Icon(icon, size: 18, color: colors.textMuted),
          ),
          if (showDot)
            Positioned(
              top: 2,
              right: 2,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: colors.danger, shape: BoxShape.circle),
              ),
            ),
        ],
      ),
    );
  }
}