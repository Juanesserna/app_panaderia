import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Encabezado de sección dentro de una página de módulo (ej. "Ventas
/// recientes"). Equivale al componente `SectionHeader` de los diseños web.
class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  const SectionHeader({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.bodyBold.copyWith(color: colors.text)),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Par etiqueta/valor usado en pantallas de detalle (equivale al
/// componente `Field` de los diseños web). `value` acepta cualquier
/// widget para poder usar texto mono, negritas, badges, etc.
class AppFieldDisplay extends StatelessWidget {
  final String label;
  final Widget value;
  const AppFieldDisplay({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTextStyles.tiny.copyWith(color: colors.textMuted, letterSpacing: 0.4),
        ),
        const SizedBox(height: 3),
        DefaultTextStyle(
          style: AppTextStyles.bodyMedium.copyWith(color: colors.text),
          child: value,
        ),
      ],
    );
  }
}

/// Botón de acción secundario/terciario reutilizable (equivale a
/// `ActionBtn`). No se auto-expande: si necesitas que reparta el ancho
/// disponible dentro de un `Row` (como en la fila de 3 botones del
/// detalle de venta), envuélvelo tú en `Expanded` al usarlo.
enum ActionBtnVariant { normal, accent }

class ActionBtn extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final ActionBtnVariant variant;
  const ActionBtn({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
    this.variant = ActionBtnVariant.normal,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final isAccent = variant == ActionBtnVariant.accent;
    final bg = isAccent ? colors.accent : colors.surface2;
    final fg = isAccent ? colors.accentFg : colors.text;
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: isAccent ? null : Border.all(color: colors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 15, color: fg),
                const SizedBox(width: 6),
              ],
              Text(label, style: AppTextStyles.captionBold.copyWith(color: fg)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Barra de búsqueda reutilizable (equivale a `SearchBar` de los diseños
/// web). Se llama `AppSearchField` para no chocar con el `SearchBar`
/// propio de Flutter Material. Pensada para vivir dentro de un `Row`.
class AppSearchField extends StatelessWidget {
  final String placeholder;
  final ValueChanged<String>? onChanged;
  const AppSearchField({super.key, required this.placeholder, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Expanded(
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: colors.surface2,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          children: [
            Icon(Icons.search, size: 18, color: colors.textMuted),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                onChanged: onChanged,
                style: AppTextStyles.bodyRegular.copyWith(color: colors.text),
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: placeholder,
                  hintStyle: AppTextStyles.bodyRegular.copyWith(color: colors.textMuted),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
