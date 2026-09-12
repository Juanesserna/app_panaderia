import 'package:flutter/material.dart';

/// Paleta de colores de AlHorno.
/// Refleja 1:1 las variables CSS (--ah-*) usadas en los diseños de referencia,
/// para que Flutter y los diseños web hablen exactamente el mismo idioma.
/// Nadie debería escribir un Color(0xFF...) suelto en un widget: siempre
/// se debe leer de aquí vía `context.colors.xxx`.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color bg;
  final Color surface;
  final Color surface2;
  final Color text;
  final Color textMuted;
  final Color accent;
  final Color accentFg;
  final Color success;
  final Color successBg;
  final Color warning;
  final Color warningBg;
  final Color danger;
  final Color dangerBg;
  final Color info;
  final Color mutedBg;
  final Color mutedFg;
  final Color border;
  final Color sidebar;
  final Color sidebarFg;

  const AppColors({
    required this.bg,
    required this.surface,
    required this.surface2,
    required this.text,
    required this.textMuted,
    required this.accent,
    required this.accentFg,
    required this.success,
    required this.successBg,
    required this.warning,
    required this.warningBg,
    required this.danger,
    required this.dangerBg,
    required this.info,
    required this.mutedBg,
    required this.mutedFg,
    required this.border,
    required this.sidebar,
    required this.sidebarFg,
  });

  /// --ah-* del bloque :root (modo claro)
  static const light = AppColors(
    bg: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    surface2: Color(0xFFFAE8DB),
    text: Color(0xFF5C2A1A),
    textMuted: Color(0xFFA56A50),
    accent: Color(0xFFC1592F),
    accentFg: Color(0xFFFFFFFF),
    success: Color(0xFF6E8B3D),
    successBg: Color(0xFFE8F5EE),
    warning: Color(0xFFF2A93C),
    warningBg: Color(0xFFFEF3DC),
    danger: Color(0xFFC0392B),
    dangerBg: Color(0xFFFEE8E6),
    info: Color(0xFF2E7D8C),
    mutedBg: Color(0xFFEDE8E0),
    mutedFg: Color(0xFF8A7A68),
    border: Color(0xFFE4D9C8),
    sidebar: Color(0xFF4A2E22),
    sidebarFg: Color(0xFFFAF3E9),
  );

  /// --ah-* del bloque .dark (modo oscuro)
  static const dark = AppColors(
    bg: Color(0xFF17110D),
    surface: Color(0xFF2A1D16),
    surface2: Color(0xFF241811),
    text: Color(0xFFF2E9DD),
    textMuted: Color(0xFFB8A794),
    accent: Color(0xFFA85D33),
    accentFg: Color(0xFFFFFFFF),
    success: Color(0xFF6E8B3D),
    successBg: Color(0xFF0D2E1A),
    warning: Color(0xFFF2A93C),
    warningBg: Color(0xFF2A1E06),
    danger: Color(0xFFC0392B),
    dangerBg: Color(0xFF2E0F0C),
    info: Color(0xFF2E7D8C),
    mutedBg: Color(0xFF261F16),
    mutedFg: Color(0xFFB8A794),
    border: Color(0xFF3D2C21),
    sidebar: Color(0xFF241811),
    sidebarFg: Color(0xFFF2E9DD),
  );

  @override
  AppColors copyWith({
    Color? bg,
    Color? surface,
    Color? surface2,
    Color? text,
    Color? textMuted,
    Color? accent,
    Color? accentFg,
    Color? success,
    Color? successBg,
    Color? warning,
    Color? warningBg,
    Color? danger,
    Color? dangerBg,
    Color? info,
    Color? mutedBg,
    Color? mutedFg,
    Color? border,
    Color? sidebar,
    Color? sidebarFg,
  }) {
    return AppColors(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      surface2: surface2 ?? this.surface2,
      text: text ?? this.text,
      textMuted: textMuted ?? this.textMuted,
      accent: accent ?? this.accent,
      accentFg: accentFg ?? this.accentFg,
      success: success ?? this.success,
      successBg: successBg ?? this.successBg,
      warning: warning ?? this.warning,
      warningBg: warningBg ?? this.warningBg,
      danger: danger ?? this.danger,
      dangerBg: dangerBg ?? this.dangerBg,
      info: info ?? this.info,
      mutedBg: mutedBg ?? this.mutedBg,
      mutedFg: mutedFg ?? this.mutedFg,
      border: border ?? this.border,
      sidebar: sidebar ?? this.sidebar,
      sidebarFg: sidebarFg ?? this.sidebarFg,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surface2: Color.lerp(surface2, other.surface2, t)!,
      text: Color.lerp(text, other.text, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentFg: Color.lerp(accentFg, other.accentFg, t)!,
      success: Color.lerp(success, other.success, t)!,
      successBg: Color.lerp(successBg, other.successBg, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningBg: Color.lerp(warningBg, other.warningBg, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerBg: Color.lerp(dangerBg, other.dangerBg, t)!,
      info: Color.lerp(info, other.info, t)!,
      mutedBg: Color.lerp(mutedBg, other.mutedBg, t)!,
      mutedFg: Color.lerp(mutedFg, other.mutedFg, t)!,
      border: Color.lerp(border, other.border, t)!,
      sidebar: Color.lerp(sidebar, other.sidebar, t)!,
      sidebarFg: Color.lerp(sidebarFg, other.sidebarFg, t)!,
    );
  }
}

/// Acceso rápido en cualquier widget: `context.colors.accent`
extension AppColorsX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
