import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/insumo_inventario.dart';
import '../../riverpod/insumos_providers.dart';

/// Contenido del bottom sheet "Nuevo insumo" / "Editar insumo". Se abre
/// con:
///   showAppBottomSheet(context, title: 'Nuevo insumo',
///       builder: (_) => const InsumoFormSheet());
///   showAppBottomSheet(context, title: 'Editar insumo',
///       builder: (_) => InsumoFormSheet(insumoId: id));
class InsumoFormSheet extends ConsumerStatefulWidget {
  /// `null` = modo "nuevo insumo". Con un id existente = modo "editar".
  final String? insumoId;
  const InsumoFormSheet({super.key, this.insumoId});

  bool get esEdicion => insumoId != null;

  @override
  ConsumerState<InsumoFormSheet> createState() => _InsumoFormSheetState();
}

class _InsumoFormSheetState extends ConsumerState<InsumoFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final String _formId;

  final _nombreCtrl = TextEditingController();
  final _stockActualCtrl = TextEditingController();
  final _stockMinimoCtrl = TextEditingController();

  CategoriaInsumo _categoria = CategoriaInsumo.harinas;
  UnidadInsumo _unidad = UnidadInsumo.kg;
  bool _activo = true;
  final List<LoteInsumo> _lotes = [];

  @override
  void initState() {
    super.initState();
    if (widget.esEdicion) {
      final insumos = ref.read(insumosProvider);
      final original = insumos.firstWhere((i) => i.id == widget.insumoId);
      _formId = original.id;
      _nombreCtrl.text = original.nombre;
      _stockActualCtrl.text = _formatNumero(original.stockActual);
      _stockMinimoCtrl.text = _formatNumero(original.stockMinimo);
      _categoria = original.categoria;
      _unidad = original.unidad;
      _activo = original.activo;
      _lotes.addAll(original.lotes);
    } else {
      _formId = ref.read(insumosProvider.notifier).siguienteId();
      _stockActualCtrl.text = '0';
      _stockMinimoCtrl.text = '0';
    }
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _stockActualCtrl.dispose();
    _stockMinimoCtrl.dispose();
    super.dispose();
  }

  String _formatNumero(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toString();

  Future<void> _agregarLote() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
    );
    if (fecha == null) return;
    String pad(int n) => n.toString().padLeft(2, '0');
    setState(() {
      _lotes.add(
        LoteInsumo(
          id: 'L-${DateTime.now().millisecondsSinceEpoch}',
          cantidad:
              double.tryParse(_stockActualCtrl.text.replaceAll(',', '.')) ?? 0,
          fechaVencimiento:
              '${pad(fecha.day)}/${pad(fecha.month)}/${fecha.year}',
        ),
      );
    });
  }

  void _quitarLote(String id) {
    setState(() => _lotes.removeWhere((l) => l.id == id));
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;
    final stockActual = double.parse(
      _stockActualCtrl.text.replaceAll(',', '.'),
    );
    final stockMinimo = double.parse(
      _stockMinimoCtrl.text.replaceAll(',', '.'),
    );

    final insumo = InsumoInventario(
      id: _formId,
      nombre: _nombreCtrl.text.trim(),
      categoria: _categoria,
      unidad: _unidad,
      stockActual: stockActual,
      stockMinimo: stockMinimo,
      activo: _activo,
      lotes: List.of(_lotes),
    );

    final notifier = ref.read(insumosProvider.notifier);
    if (widget.esEdicion) {
      notifier.actualizarInsumo(insumo);
    } else {
      notifier.registrarInsumo(insumo);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _Label('CÓDIGO'),
            const SizedBox(height: 6),
            Container(
              height: 42,
              width: double.infinity,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: colors.mutedBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _formId,
                style: AppTextStyles.monoBody.copyWith(color: colors.textMuted),
              ),
            ),
            const SizedBox(height: 16),
            _Label('NOMBRE', required: true),
            const SizedBox(height: 6),
            _TextField(
              controller: _nombreCtrl,
              hint: 'Ej. Harina de trigo',
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'El nombre es obligatorio'
                  : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _Label('CATEGORÍA')),
                const SizedBox(width: 12),
                Expanded(child: _Label('UNIDAD')),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: _Dropdown<CategoriaInsumo>(
                    value: _categoria,
                    items: CategoriaInsumo.values,
                    labelOf: (c) => c.label,
                    onChanged: (v) => setState(() => _categoria = v),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _Dropdown<UnidadInsumo>(
                    value: _unidad,
                    items: UnidadInsumo.values,
                    labelOf: (u) => u.label,
                    onChanged: (v) => setState(() => _unidad = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _Label('STOCK ACTUAL', required: true)),
                const SizedBox(width: 12),
                Expanded(child: _Label('STOCK MÍNIMO', required: true)),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: _TextField(
                    controller: _stockActualCtrl,
                    hint: '0',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: _validarNumero,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TextField(
                    controller: _stockMinimoCtrl,
                    hint: '0',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: _validarNumero,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ESTADO',
                  style: AppTextStyles.captionBold.copyWith(
                    color: colors.textMuted,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _activo ? 'Activo' : 'Inactivo',
                      style: AppTextStyles.captionBold.copyWith(
                        color: _activo ? colors.success : colors.danger,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Switch(
                      value: _activo,
                      onChanged: (v) => setState(() => _activo = v),
                      activeThumbColor: colors.accent,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _Label('LOTES'),
                _MiniButton(label: '+ Agregar lote', onTap: _agregarLote),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 56),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.surface2,
                border: Border.all(color: colors.border),
                borderRadius: BorderRadius.circular(14),
              ),
              child: _lotes.isEmpty
                  ? Center(
                      child: Text(
                        'Sin lotes registrados',
                        style: AppTextStyles.caption.copyWith(
                          color: colors.textMuted,
                        ),
                      ),
                    )
                  : Column(
                      children: _lotes
                          .map(
                            (lote) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.inventory_2_outlined,
                                    size: 14,
                                    color: colors.textMuted,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '${_formatNumero(lote.cantidad)} ${_unidad.label} · vence ${lote.fechaVencimiento}',
                                      style: AppTextStyles.caption.copyWith(
                                        color: colors.text,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    icon: Icon(
                                      Icons.close,
                                      size: 16,
                                      color: colors.danger,
                                    ),
                                    onPressed: () => _quitarLote(lote.id),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _guardar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.accent,
                  foregroundColor: colors.accentFg,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  widget.esEdicion ? 'Guardar cambios' : 'Guardar insumo',
                  style: AppTextStyles.bodyBold.copyWith(
                    color: colors.accentFg,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _validarNumero(String? v) {
    if (v == null || v.trim().isEmpty) return 'Requerido';
    final n = double.tryParse(v.replaceAll(',', '.'));
    if (n == null) return 'Valor inválido';
    if (n < 0) return 'Debe ser ≥ 0';
    return null;
  }
}

// ---------- Helpers de UI internos del formulario ----------

class _Label extends StatelessWidget {
  final String text;
  final bool required;
  const _Label(this.text, {this.required = false});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Text(
      text + (required ? ' *' : ''),
      style: AppTextStyles.tiny.copyWith(
        color: required ? colors.danger : colors.textMuted,
        letterSpacing: 0.4,
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  const _TextField({
    required this.controller,
    required this.hint,
    this.keyboardType,
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
        keyboardType: keyboardType,
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

class _MiniButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _MiniButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Material(
      color: colors.surface2,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: colors.border),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: AppTextStyles.captionBold.copyWith(color: colors.accent),
          ),
        ),
      ),
    );
  }
}
