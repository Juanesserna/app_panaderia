import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/insumo_inventario.dart';
import '../../riverpod/insumos_providers.dart';
import '../common/common_ui.dart';

/// Contenido del bottom sheet "Filtrar insumos". A diferencia del de
/// Producción (todavía visual), este sí filtra de una vez la lista real
/// a través de [filtrosInsumosProvider].
class FiltrosInsumosSheet extends ConsumerStatefulWidget {
  const FiltrosInsumosSheet({super.key});

  @override
  ConsumerState<FiltrosInsumosSheet> createState() =>
      _FiltrosInsumosSheetState();
}

class _FiltrosInsumosSheetState extends ConsumerState<FiltrosInsumosSheet> {
  late CategoriaInsumo? _categoria;
  late bool? _activo;
  late NivelStock? _nivelStock;

  @override
  void initState() {
    super.initState();
    final actuales = ref.read(filtrosInsumosProvider);
    _categoria = actuales.categoria;
    _activo = actuales.activo;
    _nivelStock = actuales.nivelStock;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ChipGroup<CategoriaInsumo?>(
            label: 'Categoría',
            selected: _categoria,
            options: const [
              _Opcion(null, 'Todas'),
              _Opcion(CategoriaInsumo.harinas, 'Harinas'),
              _Opcion(CategoriaInsumo.lacteos, 'Lácteos'),
              _Opcion(CategoriaInsumo.endulzantes, 'Endulzantes'),
              _Opcion(CategoriaInsumo.leudantes, 'Leudantes'),
              _Opcion(CategoriaInsumo.proteinas, 'Proteínas'),
            ],
            onSelected: (v) => setState(() => _categoria = v),
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
          _ChipGroup<NivelStock?>(
            label: 'Nivel de stock',
            selected: _nivelStock,
            options: const [
              _Opcion(null, 'Todos'),
              _Opcion(NivelStock.normal, 'Normal'),
              _Opcion(NivelStock.stockBajo, 'Stock bajo'),
              _Opcion(NivelStock.agotado, 'Agotado'),
            ],
            onSelected: (v) => setState(() => _nivelStock = v),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ActionBtn(
                  label: 'Limpiar',
                  onTap: () => setState(() {
                    _categoria = null;
                    _activo = null;
                    _nivelStock = null;
                  }),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ActionBtn(
                  label: 'Aplicar',
                  variant: ActionBtnVariant.accent,
                  onTap: () {
                    final notifier = ref.read(filtrosInsumosProvider.notifier);
                    notifier.setCategoria(_categoria);
                    notifier.setActivo(_activo);
                    notifier.setNivelStock(_nivelStock);
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

/// Una opción de chip: valor real + texto mostrado.
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
