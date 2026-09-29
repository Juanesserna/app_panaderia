import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/categoria.dart';
import '../../riverpod/categorias_providers.dart';
import 'categoria_color.dart';

/// Contenido del bottom sheet "Nueva categoría" / "Editar categoría". Se
/// abre con:
///   showAppBottomSheet(context, title: 'Nueva categoría',
///       builder: (_) => const CategoriaFormSheet());
///   showAppBottomSheet(context, title: 'Editar categoría',
///       builder: (_) => CategoriaFormSheet(categoriaId: id));
class CategoriaFormSheet extends ConsumerStatefulWidget {
  /// `null` = modo "nueva categoría". Con un id existente = modo "editar".
  final String? categoriaId;
  const CategoriaFormSheet({super.key, this.categoriaId});

  bool get esEdicion => categoriaId != null;

  @override
  ConsumerState<CategoriaFormSheet> createState() => _CategoriaFormSheetState();
}

class _CategoriaFormSheetState extends ConsumerState<CategoriaFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final String _formId;

  final _nombreCtrl = TextEditingController();
  final _descripcionCtrl = TextEditingController();

  bool _activa = true;
  int _colorIndex = 0;
  int _cantidadProductos = 0;
  int _cantidadInsumos = 0;

  @override
  void initState() {
    super.initState();
    if (widget.esEdicion) {
      final categorias = ref.read(categoriasProvider);
      final original = categorias.firstWhere((c) => c.id == widget.categoriaId);
      _formId = original.id;
      _nombreCtrl.text = original.nombre;
      _descripcionCtrl.text = original.descripcion;
      _activa = original.activa;
      _colorIndex = original.colorIndex;
      _cantidadProductos = original.cantidadProductos;
      _cantidadInsumos = original.cantidadInsumos;
    } else {
      _formId = ref.read(categoriasProvider.notifier).siguienteId();
      _colorIndex =
          ref.read(categoriasProvider).length % kCategoriaPalette.length;
    }
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _descripcionCtrl.dispose();
    super.dispose();
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;

    final categoria = Categoria(
      id: _formId,
      nombre: _nombreCtrl.text.trim(),
      descripcion: _descripcionCtrl.text.trim(),
      colorIndex: _colorIndex,
      cantidadProductos: _cantidadProductos,
      cantidadInsumos: _cantidadInsumos,
      activa: _activa,
    );

    final notifier = ref.read(categoriasProvider.notifier);
    if (widget.esEdicion) {
      notifier.actualizarCategoria(categoria);
    } else {
      notifier.registrarCategoria(categoria);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
            child: Text(
              'Completa los datos y guarda el registro',
              style: AppTextStyles.caption.copyWith(color: colors.textMuted),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _Field(
                          label: 'CÓDIGO',
                          child: Container(
                            height: 42,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: colors.mutedBg,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              _formId,
                              style: AppTextStyles.monoBody.copyWith(
                                color: colors.textMuted,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _Field(
                          label: 'ESTADO',
                          child: _Dropdown<bool>(
                            value: _activa,
                            items: const [true, false],
                            labelOf: (v) => v ? 'Activo' : 'Inactivo',
                            onChanged: (v) => setState(() => _activa = v),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _Field(
                    label: 'NOMBRE',
                    required: true,
                    child: _TextField(
                      controller: _nombreCtrl,
                      hint: 'Ej. Panes',
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'El nombre de la categoría es obligatorio'
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _Field(
                    label: 'DESCRIPCIÓN',
                    child: _TextField(
                      controller: _descripcionCtrl,
                      hint: 'Ej. Variedades de pan artesanal',
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _Field(
                    label: 'COLOR',
                    child: _ColorSelector(
                      seleccionado: _colorIndex,
                      onChanged: (i) => setState(() => _colorIndex = i),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Row(
              children: [
                Expanded(
                  child: _SecondaryButton(
                    label: 'Cancelar',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _PrimaryButton(
                    label: widget.esEdicion
                        ? 'Guardar cambios'
                        : 'Guardar categoría',
                    onTap: _guardar,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- Helpers de UI internos del formulario ----------

class _ColorSelector extends StatelessWidget {
  final int seleccionado;
  final ValueChanged<int> onChanged;
  const _ColorSelector({required this.seleccionado, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (int i = 0; i < kCategoriaPalette.length; i++)
          InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: () => onChanged(i),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: kCategoriaPalette[i],
                shape: BoxShape.circle,
                border: Border.all(
                  color: i == seleccionado ? colors.text : Colors.transparent,
                  width: 2,
                ),
              ),
              child: i == seleccionado
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final bool required;
  final Widget child;
  const _Field({
    required this.label,
    this.required = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label + (required ? ' *' : ''),
          style: AppTextStyles.tiny.copyWith(
            color: required ? colors.danger : colors.textMuted,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

class _TextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final String? Function(String?)? validator;
  const _TextField({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: colors.surface2,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: AppTextStyles.bodyRegular.copyWith(color: colors.text),
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          hintText: hint,
          hintStyle: AppTextStyles.bodyRegular.copyWith(
            color: colors.textMuted,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        validator: validator,
      ),
    );
  }
}

class _Dropdown<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final String Function(T) labelOf;
  final ValueChanged<T> onChanged;
  const _Dropdown({
    required this.value,
    required this.items,
    required this.labelOf,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: colors.surface2,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          style: AppTextStyles.bodyRegular.copyWith(color: colors.text),
          dropdownColor: colors.surface2,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(labelOf(e))))
              .toList(),
          onChanged: (v) => v != null ? onChanged(v) : null,
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.accent,
        foregroundColor: colors.accentFg,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodyBold.copyWith(color: colors.accentFg),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _SecondaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.text,
        side: BorderSide(color: colors.border),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodyBold.copyWith(color: colors.text),
      ),
    );
  }
}
