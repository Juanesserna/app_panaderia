import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../common/common_ui.dart';
import 'producto_tile.dart';
import 'producto_status_badge.dart';

/// Contenido del bottom sheet de detalle de un producto.
///
/// Se abre con:
///   showAppBottomSheet(context, title: 'Detalle Producto', builder: (_) => DetalleProductoSheet(producto: producto));
class DetalleProductoSheet extends StatelessWidget {
  final Producto producto;
  const DetalleProductoSheet({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            _sectionHeader(context: context, icon: Icons.label_outlined, title: 'Información General'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: AppFieldDisplay(
                    label: 'CÓDIGO',
                    value: Text(
                      producto.codigo,
                      style: AppTextStyles.monoBody.copyWith(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: AppFieldDisplay(label: 'NOMBRE', value: Text(producto.nombre)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: AppFieldDisplay(label: 'CATEGORÍA', value: Text(producto.categoria)),
                ),
                Expanded(
                  child: AppFieldDisplay(
                    label: 'PRECIO VENTA',
                    value: Text(
                      '\$${producto.precio.toStringAsFixed(2)}',
                      style: AppTextStyles.monoBody.copyWith(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _sectionHeader(context: context, icon: Icons.inventory_2_outlined, title: 'Información de Stock'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: AppFieldDisplay(
                    label: 'STOCK ACTUAL',
                    value: Text(
                      '${producto.stock}',
                      style: AppTextStyles.monoBody.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: producto.stock == 0 ? colors.danger : colors.text,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: AppFieldDisplay(
                    label: 'STOCK MÍNIMO',
                    value: Text(
                      '${producto.stockMin}',
                      style: AppTextStyles.monoBody.copyWith(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: AppFieldDisplay(
                    label: 'CANT. MÍN. PRODUCCIÓN',
                    value: Text(
                      '${producto.minProd}',
                      style: AppTextStyles.monoBody.copyWith(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: AppFieldDisplay(
                    label: 'CANT. MÁX. PRODUCCIÓN',
                    value: Text(
                      '${producto.maxProd}',
                      style: AppTextStyles.monoBody.copyWith(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ExpansionTile(
              title: Text('Listar insumos receta', style: AppTextStyles.bodyBold.copyWith(color: colors.text)),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Text('Sin insumos registrados aún', style: AppTextStyles.caption.copyWith(color: colors.textMuted)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('Estado', style: AppTextStyles.caption.copyWith(color: colors.textMuted)),
                const SizedBox(width: 8),
                ProductoStatusBadge(estado: producto.estado),
              ],
            ),
            const SizedBox(height: 16),
            _sectionHeader(context: context, icon: Icons.access_time, title: 'Historial'),
            const SizedBox(height: 8),
            _timelineItem(context: context, title: 'Registro creado', subtitle: 'Admin AlHorno', dotColor: colors.success),
            const SizedBox(height: 8),
            _timelineItem(
              context: context,
              title: 'Estado: ${producto.estado.label}',
              subtitle: 'Admin AlHorno',
              dotColor: producto.estado == EstadoProducto.activo ? colors.success : colors.danger,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: ActionBtn(label: 'Editar', onTap: () {})),
                const SizedBox(width: 8),
                Expanded(
                  child: ActionBtn(label: 'Cambiar estado', variant: ActionBtnVariant.accent, onTap: () {}),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader({required BuildContext context, required IconData icon, required String title}) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Row(
      children: [
        Icon(icon, size: 16, color: colors.textMuted),
        const SizedBox(width: 6),
        Text(title, style: AppTextStyles.bodyBold.copyWith(color: colors.text)),
      ],
    );
  }

  Widget _timelineItem({
    required BuildContext context,
    required String title,
    required String subtitle,
    required Color dotColor,
  }) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.only(top: 5),
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: AppTextStyles.bodyBold.copyWith(color: colors.text)),
            Text(subtitle, style: AppTextStyles.caption.copyWith(color: colors.textMuted)),
          ],
        ),
      ],
    );
  }
}
