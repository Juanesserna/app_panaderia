import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_modules.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../riverpod/shell_providers.dart';
import 'app_drawer_sheet.dart';

/// Barra inferior fija con los 4 módulos principales + botón "Más".
class AppBottomNav extends ConsumerWidget {
  const AppBottomNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final current = ref.watch(currentModuleProvider);
    final isMoreActive = kDrawerItems.any((i) => i.module == current);

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              ...kBottomTabs.map(
                (item) => _NavButton(
                  icon: item.icon,
                  label: item.label,
                  active: current == item.module,
                  onTap: () => ref.read(currentModuleProvider.notifier).setModule(item.module),
                ),
              ),
              _NavButton(
                icon: Icons.more_horiz,
                label: 'Más',
                active: isMoreActive,
                onTap: () => showAppDrawerSheet(context, ref),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _NavButton({required this.icon, required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final color = active ? colors.accent : colors.textMuted;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 2),
            Text(label, style: AppTextStyles.tiny.copyWith(color: color)),
            const SizedBox(height: 2),
            if (active)
              Container(
                width: 16,
                height: 2,
                decoration: BoxDecoration(color: colors.accent, borderRadius: BorderRadius.circular(2)),
              ),
          ],
        ),
      ),
    );
  }
}