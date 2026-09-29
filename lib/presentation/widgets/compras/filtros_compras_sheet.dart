import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/modelo_compra.dart';
import '../common/common_ui.dart';

/// Contenido del bottom sheet "Filtros" para compras.
class FiltrosComprasSheet extends StatefulWidget {
  final EstadoCompra? estadoSeleccionado;
  final ValueChanged<EstadoCompra?> onEstadoChanged;

  const FiltrosComprasSheet({
    super.key,
    required this.estadoSeleccionado,
    required this.onEstadoChanged,
  });

  @override
  State<FiltrosComprasSheet> createState() => _FiltrosComprasSheetState();
}

class _FiltrosComprasSheetState extends State<FiltrosComprasSheet> {
  late EstadoCompra? _estadoTemp;

  @override
  void initState() {
    super.initState();
    _estadoTemp = widget.estadoSeleccionado;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ESTADO', style: AppTextStyles.tiny.copyWith(color: colors.textMuted, letterSpacing: 0.4)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilterChip(
                label: const Text('Todos'),
                selected: _estadoTemp == null,
                onSelected: (_) => setState(() => _estadoTemp = null),
                selectedColor: colors.accent.withValues(alpha: 0.2),
                checkmarkColor: colors.accent,
              ),
              ...EstadoCompra.values.map((estado) {
                return FilterChip(
                  label: Text(ModeloCompra.obtenerEtiquetaEstado(estado)),
                  selected: _estadoTemp == estado,
                  onSelected: (val) => setState(() => _estadoTemp = val ? estado : null),
                  selectedColor: colors.accent.withValues(alpha: 0.2),
                  checkmarkColor: colors.accent,
                );
              }),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ActionBtn(
                  label: 'Limpiar',
                  onTap: () {
                    setState(() => _estadoTemp = null);
                    widget.onEstadoChanged(null);
                    Navigator.of(context).pop();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ActionBtn(
                  label: 'Aplicar filtros',
                  variant: ActionBtnVariant.accent,
                  onTap: () {
                    widget.onEstadoChanged(_estadoTemp);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}