import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/modelo_compra.dart';

/// Contenido del bottom sheet "Nueva Compra".
///
/// Se abre con:
///   showAppBottomSheet(
///     context,
///     title: 'Nueva Compra',
///     builder: (_) => NuevaCompraSheet(onGuardar: (compra) { ... }),
///   );
///
/// El encabezado (drag handle + título + botón X) ya lo pone
/// `showAppBottomSheet`, así que este widget solo dibuja el formulario.
class NuevaCompraSheet extends StatefulWidget {
  final void Function(ModeloCompra) onGuardar;

  const NuevaCompraSheet({super.key, required this.onGuardar});

  @override
  State<NuevaCompraSheet> createState() => _NuevaCompraSheetState();
}

/// Controllers de un item de la sección "Productos solicitados".
class _ItemCompraForm {
  final insumoCtrl = TextEditingController();
  final cantidadCtrl = TextEditingController(text: '1');
  final unidadCtrl = TextEditingController(text: 'kg');
  final valorCtrl = TextEditingController(text: '0');
  final vencimientoCtrl = TextEditingController();
  final cantDisponibleCtrl = TextEditingController(text: '1');
  DateTime? fechaVencimiento;
  // Número de lote autogenerado al crear el item.
  final String numeroLote =
      'LOTE-MT${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}';

  void dispose() {
    insumoCtrl.dispose();
    cantidadCtrl.dispose();
    unidadCtrl.dispose();
    valorCtrl.dispose();
    vencimientoCtrl.dispose();
    cantDisponibleCtrl.dispose();
  }
}

class _NuevaCompraSheetState extends State<NuevaCompraSheet> {
  final _formKey = GlobalKey<FormState>();
  final _proveedorCtrl = TextEditingController();
  final _descuentoCtrl = TextEditingController();
  final DateTime _fecha = DateTime.now();
  EstadoCompra _estado = EstadoCompra.pendiente;
  final List<_ItemCompraForm> _items = [_ItemCompraForm()];

  // ID que se mostrará en el campo (de solo lectura) y que se usará al
  // guardar. Se genera una sola vez al abrir el formulario.
  late final String _idPreview =
      'COM-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';

  @override
  void dispose() {
    _proveedorCtrl.dispose();
    _descuentoCtrl.dispose();
    for (final item in _items) {
      item.dispose();
    }
    super.dispose();
  }

  // ---------- Utilidades ----------
  String _fmtFecha(DateTime f) =>
      "${f.day.toString().padLeft(2, '0')}/${f.month.toString().padLeft(2, '0')}/${f.year}";

  double _num(String s) => double.tryParse(s.replaceAll(',', '.')) ?? 0;

  double get _total {
    final subtotal = _items.fold<double>(
      0,
      (s, i) => s + _num(i.cantidadCtrl.text) * _num(i.valorCtrl.text),
    );
    final descuento = _num(_descuentoCtrl.text).clamp(0, 100);
    return subtotal * (1 - descuento / 100);
  }

  Future<void> _elegirVencimiento(_ItemCompraForm item) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        item.fechaVencimiento = picked;
        item.vencimientoCtrl.text = _fmtFecha(picked);
      });
    }
  }

  void _agregarItem() => setState(() => _items.add(_ItemCompraForm()));

  void _quitarItem(int index) =>
      setState(() => _items.removeAt(index).dispose());

  void _generarCompra() {
    if (!_formKey.currentState!.validate()) return;

    if (_items.any((i) => i.insumoCtrl.text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese el nombre de cada insumo')),
      );
      return;
    }

    final items = _items
        .map(
          (i) => ItemCompra(
            insumo: i.insumoCtrl.text.trim(),
            cantidad: _num(i.cantidadCtrl.text),
            unidad: i.unidadCtrl.text.trim(),
            valorUnitario: _num(i.valorCtrl.text),
            lote: LoteCompra(
              numero: i.numeroLote,
              vencimiento: i.fechaVencimiento,
              cantidadDisponible: _num(i.cantDisponibleCtrl.text),
            ),
          ),
        )
        .toList();

    final compra = ModeloCompra(
      id: _idPreview,
      proveedor: _proveedorCtrl.text.trim(),
      items: items,
      total: _total,
      estado: _estado,
      fecha: _fecha,
      descuentoPorcentaje: _num(_descuentoCtrl.text),
    );

    widget.onGuardar(compra);
    Navigator.of(context).pop();
  }

  // ---------- Estilos reutilizados del tema de la app ----------
  InputDecoration _deco(AppColors colors, {String? hint, bool blanco = false}) {
    OutlineInputBorder borde(Color c) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: c),
    );
    return InputDecoration(
      hintText: hint,
      isDense: true,
      filled: true,
      fillColor: blanco ? colors.surface : colors.surface2,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      enabledBorder: borde(colors.border),
      focusedBorder: borde(colors.accent),
      errorBorder: borde(Colors.red),
      focusedErrorBorder: borde(Colors.red),
    );
  }

  Widget _campo(
    String etiqueta,
    Widget campo,
    AppColors colors, {
    String? ayuda,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          etiqueta,
          style: AppTextStyles.tiny.copyWith(
            color: colors.textMuted,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 6),
        campo,
        if (ayuda != null) ...[
          const SizedBox(height: 4),
          Text(
            ayuda,
            style: AppTextStyles.tiny.copyWith(color: colors.textMuted),
          ),
        ],
      ],
    );
  }

  // ============================================================
  // BUILD
  // ============================================================
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ID | FECHA
                    Row(
                      children: [
                        Expanded(
                          child: _campo(
                            'ID DE COMPRA',
                            TextFormField(
                              initialValue: '#$_idPreview',
                              readOnly: true,
                              style: AppTextStyles.monoBody.copyWith(
                                color: colors.accent,
                              ),
                              decoration: _deco(colors),
                            ),
                            colors,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _campo(
                            'FECHA',
                            TextFormField(
                              initialValue: _fmtFecha(_fecha),
                              readOnly: true,
                              style: AppTextStyles.monoBody,
                              decoration: _deco(colors),
                            ),
                            colors,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // ESTADO INICIAL | PROVEEDOR
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _campo(
                            'ESTADO INICIAL',
                            DropdownButtonFormField<EstadoCompra>(
                              value: _estado,
                              isExpanded: true,
                              decoration: _deco(colors),
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: colors.text,
                              ),
                              items: EstadoCompra.values
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(
                                        ModeloCompra.obtenerEtiquetaEstado(e),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) => setState(() => _estado = v!),
                            ),
                            colors,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _campo(
                            'PROVEEDOR',
                            TextFormField(
                              controller: _proveedorCtrl,
                              decoration: _deco(
                                colors,
                                hint: 'Buscar proveedor...',
                              ),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Ingrese el proveedor'
                                  : null,
                            ),
                            colors,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // DESCUENTO (ancho completo)
                    _campo(
                      'DESCUENTO ESPECIAL (%)',
                      TextFormField(
                        controller: _descuentoCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: _deco(colors, hint: 'Ej: 10'),
                        onChanged: (_) => setState(() {}),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty)
                            return null; // opcional
                          final n = double.tryParse(v.replaceAll(',', '.'));
                          if (n == null || n < 0 || n > 100)
                            return 'Valor entre 0 y 100';
                          return null;
                        },
                      ),
                      colors,
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'PRODUCTOS SOLICITADOS',
                      style: AppTextStyles.captionBold.copyWith(
                        color: colors.accent,
                      ),
                    ),
                    const SizedBox(height: 10),
                    for (int i = 0; i < _items.length; i++)
                      _panelItem(i, colors),
                    _botonAgregar(colors),
                  ],
                ),
              ),
            ),
          ),
          _pie(colors),
        ],
      ),
    );
  }

  // ---------- Panel repetible de insumo ----------
  Widget _panelItem(int index, AppColors colors) {
    final item = _items[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface2,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_items.length > 1)
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () => _quitarItem(index),
                child: const Icon(
                  Icons.delete_outline,
                  size: 18,
                  color: Colors.red,
                ),
              ),
            ),

          // INSUMO (texto libre; conecta aquí un catálogo real si lo tienes)
          _campo(
            'INSUMO',
            TextFormField(
              controller: item.insumoCtrl,
              decoration: _deco(
                colors,
                blanco: true,
                hint: 'Ej: Harina de trigo',
              ),
            ),
            colors,
          ),
          const SizedBox(height: 12),

          // CANTIDAD | UNIDAD | VALOR
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _campo(
                  'CANTIDAD',
                  TextFormField(
                    controller: item.cantidadCtrl,
                    textAlign: TextAlign.center,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: _deco(colors, blanco: true),
                    onChanged: (v) => setState(() {
                      // Cant. disponible = total comprado
                      item.cantDisponibleCtrl.text = v;
                    }),
                    validator: (v) => _num(v ?? '') <= 0 ? 'Inválido' : null,
                  ),
                  colors,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _campo(
                  'UNIDAD',
                  TextFormField(
                    controller: item.unidadCtrl,
                    textAlign: TextAlign.center,
                    decoration: _deco(colors, blanco: true),
                  ),
                  colors,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _campo(
                  'VALOR (\$)',
                  TextFormField(
                    controller: item.valorCtrl,
                    textAlign: TextAlign.right,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: _deco(colors, blanco: true),
                    onChanged: (_) => setState(() {}),
                  ),
                  colors,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // TRAZABILIDAD DEL LOTE
          Text(
            '# TRAZABILIDAD DEL LOTE',
            style: AppTextStyles.captionBold.copyWith(
              color: colors.text,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colors.border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _campo(
                    'N.º de Lote',
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 11,
                      ),
                      decoration: BoxDecoration(
                        color: colors.surface2,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '# ${item.numeroLote}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.monoCaption.copyWith(
                          color: colors.textMuted,
                        ),
                      ),
                    ),
                    colors,
                    ayuda: 'Automático / No editable',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _campo(
                    'Vencimiento',
                    TextFormField(
                      controller: item.vencimientoCtrl,
                      readOnly: true,
                      onTap: () => _elegirVencimiento(item),
                      decoration: _deco(colors, hint: 'mm/dd/aaaa'),
                    ),
                    colors,
                    ayuda: 'Opcional, si aplica',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _campo(
                    'Cant. Disponible',
                    TextFormField(
                      controller: item.cantDisponibleCtrl,
                      textAlign: TextAlign.center,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: _deco(colors),
                    ),
                    colors,
                    ayuda: 'Igual al total comprado',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Botón "+ Agregar Insumo" ----------
  Widget _botonAgregar(AppColors colors) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: _agregarItem,
        style: OutlinedButton.styleFrom(
          backgroundColor: colors.surface2,
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: BorderSide(color: colors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          '+  Agregar Insumo',
          style: AppTextStyles.bodyBold.copyWith(color: colors.text),
        ),
      ),
    );
  }

  // ---------- Pie: total y botones de acción ----------
  Widget _pie(AppColors colors) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total a pagar',
                style: AppTextStyles.tiny.copyWith(color: colors.textMuted),
              ),
              const SizedBox(height: 2),
              Text(
                '\$${_total.toStringAsFixed(0)}',
                style: AppTextStyles.monoBody.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colors.text,
                ),
              ),
            ],
          ),
          const Spacer(),
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              backgroundColor: colors.surface2,
              side: BorderSide(color: colors.border),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Cancelar',
              style: AppTextStyles.bodyBold.copyWith(color: colors.text),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: _generarCompra,
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.accent,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Generar Compra',
              style: AppTextStyles.bodyBold.copyWith(color: colors.accentFg),
            ),
          ),
        ],
      ),
    );
  }
}
