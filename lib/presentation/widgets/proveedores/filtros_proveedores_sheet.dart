import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/proveedor.dart';
import '../../riverpod/proveedores_providers.dart';
import '../common/common_ui.dart';

/// Contenido del bottom sheet "Filtrar proveedores". Filtra de una vez la
/// lista real a través de [filtrosProveedoresProvider].
class FiltrosProveedoresSheet extends ConsumerStatefulWidget {
  const FiltrosProveedoresSheet({super.key});

  @override
  ConsumerState<FiltrosProveedoresSheet> createState() =>
      _FiltrosProveedoresSheetState();
}

class _FiltrosProveedoresSheetState
    extends ConsumerState<FiltrosProveedoresSheet> {
  late TipoProveedor? _tipo;
  late bool? _activo;

  @override
  void initState() {
    super.initState();
    final actuales = ref.read(filtrosProveedoresProvider);
    _tipo = actuales.tipo;
    _activo = actuales.activo;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ChipGroup<TipoProveedor?>(
            label: 'Tipo',
            selected: _tipo,
            options: [
              const _Opcion(null, 'Todos'),
              for (final tipo in TipoProveedor.values)
                _Opcion(tipo, tipo.label),
            ],
            onSelected: (v) => setState(() => _tipo = v),
          ),
          const SizedBox(height: 16),
          _ChipGroup<bool?>(
            label: 'Estado',
            selected: _activo,
            options: const [
              _Opcion(null, 'Todos'),
              _Opcion(true, 'Activo'),
              _Opcion(false, 'Inactivo'),
            ],
            onSelected: (v) => setState(() => _activo = v),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ActionBtn(
                  label: 'Limpiar',
                  onTap: () => setState(() {
                    _tipo = null;
                    _activo = null;
                  }),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ActionBtn(
                  label: 'Aplicar',
                  variant: ActionBtnVariant.accent,
                  onTap: () {
                    final notifier = ref.read(
                      filtrosProveedoresProvider.notifier,
                    );
                    notifier.setTipo(_tipo);
                    notifier.setActivo(_activo);
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

class _Opcion<T> {
  final T value;
  final String texto;
  const _Opcion(this.value, this.texto);
}

class _ChipGroup<T> extends StatelessWidget {
  final String label;
  final List<_Opcion<T>> options;
  final T selected;
  final ValueChanged<T> onSelected;
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
            final activo = opt.value == selected;
            return InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () => onSelected(opt.value),
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
                  opt.texto,
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
