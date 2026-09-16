import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Campos del formulario de producto, reutilizables entre "Editar" y "Nuevo".
///
/// Recibe los controladores y valores iniciales. Gestiona internamente
/// el estado del dropdown de categoría y del switch de estado.
class ProductoFormFields extends StatefulWidget {
  final TextEditingController nombreCtrl;
  final TextEditingController precioCtrl;
  final TextEditingController stockActualCtrl;
  final TextEditingController stockMinCtrl;
  final TextEditingController minProdCtrl;
  final TextEditingController maxProdCtrl;
  final TextEditingController imagenCtrl;
  final String initialCategoria;
  final bool initialActivo;

  const ProductoFormFields({
    super.key,
    required this.nombreCtrl,
    required this.precioCtrl,
    required this.stockActualCtrl,
    required this.stockMinCtrl,
    required this.minProdCtrl,
    required this.maxProdCtrl,
    required this.imagenCtrl,
    this.initialCategoria = 'Bollería',
    this.initialActivo = true,
  });

  @override
  State<ProductoFormFields> createState() => _ProductoFormFieldsState();
}

class _ProductoFormFieldsState extends State<ProductoFormFields> {
  String _categoria = 'Bollería';
  bool _activo = true;
  final _categorias = ['Bollería', 'Panes', 'Tortas'];

  @override
  void initState() {
    super.initState();
    _categoria = widget.initialCategoria;
    _activo = widget.initialActivo;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('NOMBRE', required: true, colors: colors),
        const SizedBox(height: 6),
        _buildTextField(
          widget.nombreCtrl,
          'Nombre del producto',
          colors,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildLabel('CATEGORÍA', colors: colors)),
            const SizedBox(width: 12),
            Expanded(child: _buildLabel('PRECIO VENTA', colors: colors)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _buildDropdown(colors)),
            const SizedBox(width: 12),
            Expanded(child: _buildTextField(widget.precioCtrl, '0.00', colors, keyboardType: const TextInputType.numberWithOptions(decimal: true), prefix: '\$')),
          ],
        ),
        const SizedBox(height: 16),
        _buildLabelRow('STOCK ACTUAL', 'STOCK MÍNIMO', colors),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _buildNumericField(widget.stockActualCtrl, '0', colors)),
            const SizedBox(width: 12),
            Expanded(child: _buildNumericField(widget.stockMinCtrl, '0', colors)),
          ],
        ),
        const SizedBox(height: 16),
        _buildLabelRow('CANT. MÍNIMA PRODUCCIÓN', 'CANT. MÁXIMA PRODUCCIÓN', colors),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _buildNumericField(widget.minProdCtrl, '0', colors)),
            const SizedBox(width: 12),
            Expanded(child: _buildNumericField(widget.maxProdCtrl, '0', colors)),
          ],
        ),
        const SizedBox(height: 16),
        _buildLabel('IMAGEN DEL PRODUCTO', colors: colors),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                widget.imagenCtrl,
                'https://ejemplo.com/imagen.jpg',
                colors,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(color: colors.mutedBg, borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.image_outlined, size: 22, color: colors.textMuted),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('ESTADO', style: AppTextStyles.captionBold.copyWith(color: colors.textMuted)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_activo ? 'Activo' : 'Inactivo', style: AppTextStyles.captionBold.copyWith(color: _activo ? colors.success : colors.danger)),
                const SizedBox(width: 8),
                Switch(value: _activo, onChanged: (v) => setState(() => _activo = v), activeThumbColor: colors.accent),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLabel(String text, {bool required = false, required AppColors colors}) {
    return Text(
      text + (required ? ' *' : ''),
      style: AppTextStyles.tiny.copyWith(color: required ? colors.danger : colors.textMuted, letterSpacing: 0.4),
    );
  }

  Widget _buildLabelRow(String label1, String label2, AppColors colors) {
    return Row(
      children: [
        Expanded(child: _buildLabel(label1, colors: colors)),
        const SizedBox(width: 12),
        Expanded(child: _buildLabel(label2, colors: colors)),
      ],
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String hintText, AppColors colors, {TextInputType? keyboardType, String? prefix}) {
    return Container(
      height: 42,
      padding: EdgeInsets.only(left: 12, right: prefix != null ? 52 : 12),
      decoration: BoxDecoration(color: colors.surface2, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          if (prefix != null) ...[
            Text(prefix, style: AppTextStyles.bodyRegular.copyWith(color: colors.textMuted, fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(width: 4),
          ],
          Expanded(
            child: TextField(
              controller: ctrl,
              keyboardType: keyboardType,
              style: AppTextStyles.bodyRegular.copyWith(color: colors.text),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: AppTextStyles.bodyRegular.copyWith(color: colors.textMuted),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: colors.accent), borderRadius: BorderRadius.circular(10)),
                enabledBorder: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(AppColors colors) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: colors.surface2, borderRadius: BorderRadius.circular(10)),
      child: DropdownButtonFormField<String>(
        value: _categoria,
        items: _categorias.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
        onChanged: (v) => setState(() => _categoria = v ?? _categoria),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildNumericField(TextEditingController ctrl, String hint, AppColors colors) {
    return _buildTextField(ctrl, hint, colors, keyboardType: const TextInputType.numberWithOptions(decimal: true));
  }
}
