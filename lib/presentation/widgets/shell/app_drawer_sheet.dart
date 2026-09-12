import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_modules.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../riverpod/shell_providers.dart';
import 'app_bottom_sheet.dart';

/// Abre el bottom sheet "Menú Completo" con TODOS los módulos navegables.
void showAppDrawerSheet(BuildContext context, WidgetRef ref) {
  showAppBottomSheet(
    context,
    title: 'Menú Completo',
    builder: (context) => _AppDrawerContent(ref: ref),
  );
}

class _AppDrawerContent extends ConsumerWidget {
  final WidgetRef ref;
  const _AppDrawerContent({required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef _) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final current = ref.watch(currentModuleProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        children: kAllNavItems.map((item) {
          final active = current == item.module;
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Material(
              color: active ? colors.accent : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  ref.read(currentModuleProvider.notifier).setModule(item.module);
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Icon(item.icon, size: 20, color: active ? colors.accentFg : colors.textMuted),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item.label,
                          style: AppTextStyles.bodyBold.copyWith(
                            color: active ? colors.accentFg : colors.text,
                          ),
                        ),
                      ),
                      if (active) Icon(Icons.chevron_right, size: 16, color: colors.accentFg),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}