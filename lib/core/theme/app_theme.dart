import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Tema único de toda la app. Es el equivalente Flutter del archivo
/// global.css con las variables --ah-*. Nadie debería crear un ThemeData
/// nuevo ni sobreescribir colores en un widget puntual: todo pasa por acá.
class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(AppColors.light, Brightness.light);
  static ThemeData get dark => _build(AppColors.dark, Brightness.dark);

  static ThemeData _build(AppColors colors, Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: colors.bg,
      fontFamily: AppTextStyles.bodyRegular.fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors.accent,
        brightness: brightness,
        primary: colors.accent,
        onPrimary: colors.accentFg,
        surface: colors.surface,
        error: colors.danger,
      ),
      dividerColor: colors.border,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.text,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      extensions: [colors],
    );
  }
}
