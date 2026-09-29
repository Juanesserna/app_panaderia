import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Campo de texto con el estilo de marca (label, ícono, borde redondeado).
class AlHornoField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final TextEditingController controller;

  const AlHornoField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.obscure = false,
    this.suffix,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.captionBold.copyWith(
            fontSize: 11.5,
            letterSpacing: 0.4,
            color: colors.accent,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          style: AppTextStyles.bodyRegular.copyWith(
              color: colors.text, fontSize: 14.5),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyRegular
                .copyWith(color: colors.textMuted, fontSize: 14),
            prefixIcon: Icon(icon, size: 19, color: colors.textMuted),
            suffixIcon: suffix,
            filled: true,
            fillColor: colors.surface2,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: colors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: colors.accent, width: 1.4),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: colors.border),
            ),
          ),
        ),
      ],
    );
  }
}