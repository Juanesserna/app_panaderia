import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../riverpod/shell_providers.dart';

class BrandLogo extends ConsumerWidget {
  final double size;
  final bool showLabel;
  final Color? labelColor;
  final Color? circleColor;
  final bool? forceLightVariant;

  const BrandLogo({
    super.key,
    required this.size,
    this.showLabel = false,
    this.labelColor,
    this.circleColor,
    this.forceLightVariant,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final isDark = forceLightVariant != null
        ? !forceLightVariant!
        : ref.watch(themeModeProvider) == ThemeMode.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: circleColor ?? colors.surface2,
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            isDark ? 'assets/img/logo_oscuro.png' : 'assets/img/logo_claro.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.bakery_dining_outlined,
              size: size * 0.5,
              color: colors.text,
            ),
          ),
        ),
        if (showLabel) ...[
          const SizedBox(height: 14),
          Text(
            'Al Horno',
            style: AppTextStyles.authTitle.copyWith(
              fontSize: 22,
              color: labelColor ?? colors.text,
            ),
          ),
        ],
      ],
    );
  }
}