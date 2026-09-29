import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/venta.dart';
import '../../riverpod/ventas_providers.dart';
import '../common/common_ui.dart';

/// Contenido del bottom sheet "Filtros" de Ventas: estado, método de pago,
/// canal (multi-selección con chips) y filtro por ID.
class FiltrosVentasSheet extends ConsumerStatefulWidget {
  const FiltrosVentasSheet({super.key});

  @override
  ConsumerState<FiltrosVentasSheet> createState() => _FiltrosVentasSheetState();
}

class _FiltrosVentasSheetState extends ConsumerState<FiltrosVentasSheet> {
  late Set<EstadoVenta> _estados;
  late Set<MetodoPago> _metodos;
  late Set<CanalVenta> _canales;
  late final TextEditingController _idCtrl;

  @override
  void initState() {
    super.initState();
    // Se parte de lo que ya esté aplicado, para que reabrir el sheet no
    // pierda la selección anterior.
    _estados = Set.of(ref.read(filtroEstadosProvider));
    _metodos = Set.of(ref.read(filtroMetodosProvider));
    _canales = Set.of(ref.read(filtroCanalesProvider));
    _idCtrl = TextEditingController(text: ref.read(filtroIdProvider));
  }

  @override
  void dispose() {
    _idCtrl.dispose();
    super.dispose();
  }

  void _limpiar() {
    ref.read(filtroEstadosProvider.notifier).state = {};
    ref.read(filtroMetodosProvider.notifier).state = {};
    ref.read(filtroCanalesProvider.notifier).state = {};
    ref.read(filtroIdProvider.notifier).state = '';
    Navigator.of(context).pop();
  }

  void _aplicar() {
    ref.read(filtroEstadosProvider.notifier).state = _estados;
    ref.read(filtroMetodosProvider.notifier).state = _metodos;
    ref.read(filtroCanalesProvider.notifier).state = _canales;
    ref.read(filtroIdProvider.notifier).state = _idCtrl.text.trim();
    Navigator.of(context).pop();
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
          _Label('ID DE VENTA'),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: colors.surface2,
              border: Border.all(color: colors.border),
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: TextField(
              controller: _idCtrl,
              style: AppTextStyles.bodyRegular.copyWith(color: colors.text),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: InputBorder.none,
                hintText: 'Ej. #1024',
                hintStyle: AppTextStyles.bodyRegular.copyWith(color: colors.textMuted),
              ),
            ),
          ),
          const SizedBox(height: 20),

          _Label('ESTADO'),
          const SizedBox(height: 8),
          _ChipGroup<EstadoVenta>(
            values: EstadoVenta.values,
            labelOf: (e) => e.label,
            selected: _estados,
            onToggle: (e) => setState(() {
              _estados.contains(e) ? _estados.remove(e) : _estados.add(e);
            }),
          ),
          const SizedBox(height: 20),

          _Label('MÉTODO DE PAGO'),
          const SizedBox(height: 8),
          _ChipGroup<MetodoPago>(
            values: MetodoPago.values,
            labelOf: (m) => m.label,
            selected: _metodos,
            onToggle: (m) => setState(() {
              _metodos.contains(m) ? _metodos.remove(m) : _metodos.add(m);
            }),
          ),
          const SizedBox(height: 20),

          _Label('CANAL'),
          const SizedBox(height: 8),
          _ChipGroup<CanalVenta>(
            values: CanalVenta.values,
            labelOf: (c) => c.label,
            selected: _canales,
            onToggle: (c) => setState(() {
              _canales.contains(c) ? _canales.remove(c) : _canales.add(c);
            }),
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(child: ActionBtn(label: 'Limpiar', onTap: _limpiar)),
              const SizedBox(width: 8),
              Expanded(
                child: ActionBtn(
                  label: 'Aplicar filtros',
                  variant: ActionBtnVariant.accent,
                  onTap: _aplicar,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Text(text, style: AppTextStyles.tiny.copyWith(color: colors.textMuted, letterSpacing: 0.4));
  }
}

/// Grupo de chips de selección múltiple para un enum cualquiera.
class _ChipGroup<T> extends StatelessWidget {
  final List<T> values;
  final String Function(T) labelOf;
  final Set<T> selected;
  final ValueChanged<T> onToggle;

  const _ChipGroup({
    required this.values,
    required this.labelOf,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: values.map((v) {
        final active = selected.contains(v);
        return InkWell(
          onTap: () => onToggle(v),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: active ? colors.accent : colors.surface2,
              border: Border.all(color: active ? colors.accent : colors.border),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              labelOf(v),
              style: AppTextStyles.captionBold.copyWith(
                color: active ? colors.accentFg : colors.text,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}