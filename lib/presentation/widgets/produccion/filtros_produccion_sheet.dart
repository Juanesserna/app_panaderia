import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../common/common_ui.dart';

/// Contenido del bottom sheet "Filtros" de Producción. Por ahora los
/// chips son solo visuales (igual que en el diseño web); cuando se
/// conecten a la lista real, se reemplaza `onApply` para que filtre
/// `ordenesProduccionProvider` en la página.
class FiltrosProduccionSheet extends StatefulWidget {
  const FiltrosProduccionSheet({super.key});

  @override
  State<FiltrosProduccionSheet> createState() => _FiltrosProduccionSheetState();
}

class _FiltrosProduccionSheetState extends State<FiltrosProduccionSheet> {
  static const _estados = [
    'Todos',
    'Pendiente',
    'En proceso',
    'Completado',
    'Retrasado',
    'Cancelado',
  ];
  static const _origenes = ['Todos', 'Manual', 'Página'];

  String _estadoSeleccionado = _estados.first;
  String _origenSeleccionado = _origenes.first;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ChipGroup(
            label: 'Estado',
            options: _estados,
            selected: _estadoSeleccionado,
            onSelected: (v) => setState(() => _estadoSeleccionado = v),
          ),
          const SizedBox(height: 16),
          _ChipGroup(
            label: 'Origen',
            options: _origenes,
            selected: _origenSeleccionado,
            onSelected: (v) => setState(() => _origenSeleccionado = v),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ActionBtn(
                  label: 'Limpiar',
                  onTap: () => setState(() {
                    _estadoSeleccionado = _estados.first;
                    _origenSeleccionado = _origenes.first;
                  }),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ActionBtn(
                  label: 'Aplicar filtros',
                  variant: ActionBtnVariant.accent,
                  onTap: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChipGroup extends StatelessWidget {
  final String label;
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;
  const _ChipGroup({
    required this.label,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTextStyles.tiny.copyWith(
            color: colors.textMuted,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((opt) {
            final activo = opt == selected;
            return InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () => onSelected(opt),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: activo ? colors.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: activo ? colors.accent : colors.border,
                  ),
                ),
                child: Text(
                  opt,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: activo ? colors.accentFg : colors.text,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
