import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../widgets/common/common_ui.dart';
import '../../widgets/productos/producto_action_icon.dart';
import '../../widgets/productos/producto_status_badge.dart';
import '../../widgets/productos/confirmar_eliminar_dialog.dart';
import '../../widgets/productos/producto_tile.dart';
import '../../widgets/productos/producto_form_fields.dart';

/// Pantalla de formulario para editar un producto.
class EditarProductoScreen extends StatefulWidget {
  final Producto producto;
  const EditarProductoScreen({super.key, required this.producto});

  @override
  State<EditarProductoScreen> createState() => _EditarProductoScreenState();
}

class _EditarProductoScreenState extends State<EditarProductoScreen> {
  final _nombreCtrl = TextEditingController();
  final _precioCtrl = TextEditingController();
  final _stockActualCtrl = TextEditingController();
  final _stockMinCtrl = TextEditingController();
  final _minProdCtrl = TextEditingController();
  final _maxProdCtrl = TextEditingController();
  final _imagenCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nombreCtrl.text = widget.producto.nombre;
    _precioCtrl.text = widget.producto.precio.toStringAsFixed(2);
    _stockActualCtrl.text = widget.producto.stock.toString();
    _stockMinCtrl.text = widget.producto.stockMin.toString();
    _minProdCtrl.text = widget.producto.minProd.toString();
    _maxProdCtrl.text = widget.producto.maxProd.toString();
    _imagenCtrl.text = '';
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _precioCtrl.dispose();
    _stockActualCtrl.dispose();
    _stockMinCtrl.dispose();
    _minProdCtrl.dispose();
    _maxProdCtrl.dispose();
    _imagenCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(icon: const Icon(Icons.arrow_back, size: 22), onPressed: () => Navigator.pop(context)),
                Expanded(
                  child: Text('Editar Producto', style: AppTextStyles.titleMd.copyWith(color: colors.text)),
                ),
              ],
            ),
            Text('Modifica los campos del producto', style: AppTextStyles.caption.copyWith(color: colors.textMuted)),
            const SizedBox(height: 20),
            ProductoFormFields(
              nombreCtrl: _nombreCtrl,
              precioCtrl: _precioCtrl,
              stockActualCtrl: _stockActualCtrl,
              stockMinCtrl: _stockMinCtrl,
              minProdCtrl: _minProdCtrl,
              maxProdCtrl: _maxProdCtrl,
              imagenCtrl: _imagenCtrl,
              initialCategoria: widget.producto.categoria,
              initialActivo: widget.producto.estado == EstadoProducto.activo,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: ActionBtn(label: 'Cancelar', onTap: () => Navigator.pop(context))),
                const SizedBox(width: 8),
                Expanded(
                  child: ActionBtn(label: 'Guardar Cambios', variant: ActionBtnVariant.accent, onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Próximamente')));
                  }),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildRecipeSection(colors),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeSection(AppColors colors) {
    final insumos = [
      {'codigo': 'INS-001', 'nombre': 'Harina de trigo', 'cantidad': '500', 'unidad': 'Gramos'},
      {'codigo': 'INS-002', 'nombre': 'Mantequilla', 'cantidad': '200', 'unidad': 'Gramos'},
      {'codigo': 'INS-003', 'nombre': 'Sal', 'cantidad': '5', 'unidad': 'Gramos'},
      {'codigo': 'INS-004', 'nombre': 'Levadura', 'cantidad': '10', 'unidad': 'Gramos'},
      {'codigo': 'INS-005', 'nombre': 'Agua', 'cantidad': '250', 'unidad': 'Mililitros'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Receta del Producto', style: AppTextStyles.titleMd),
            ActionBtn(
              label: 'Agregar insumo',
              icon: Icons.add,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Próximamente')));
              },
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text('Insumos necesarios para la elaboración de este producto', style: AppTextStyles.caption.copyWith(color: colors.textMuted)),
        const SizedBox(height: 12),
        ...insumos.map((i) {
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: colors.border)),
            margin: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: '${i['codigo']} — ', style: AppTextStyles.bodyBold.copyWith(color: colors.accent, fontSize: 14)),
                            TextSpan(text: i['nombre'] as String, style: AppTextStyles.bodyBold.copyWith(color: colors.text, fontSize: 14)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text('${i['cantidad']} ${i['unidad']}', style: AppTextStyles.caption.copyWith(color: colors.textMuted)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ProductoActionIcon(icon: Icons.edit_outlined, color: colors.accent, onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Próximamente')));
                }),
                const SizedBox(width: 4),
                ProductoActionIcon(icon: Icons.delete_outline, color: colors.danger, onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => ConfirmarEliminarDialog(
                      title: 'Eliminar insumo',
                      itemName: i['nombre'] as String,
                      warningText: 'Este insumo será eliminado permanentemente del sistema.',
                    ),
                  );
                }),
              ],
            ),
          );
        }),
      ],
    );
  }
}
