import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'producto_action_icon.dart';
import 'producto_status_badge.dart';

/// Modelo de datos de un producto.
class Producto {
  final String codigo;
  final String nombre;
  final String categoria;
  final double precio;
  final int stock;
  final int stockMin;
  final int minProd;
  final int maxProd;
  final EstadoProducto estado;
  const Producto({
    required this.codigo,
    required this.nombre,
    required this.categoria,
    required this.precio,
    required this.stock,
    required this.stockMin,
    required this.minProd,
    required this.maxProd,
    required this.estado,
  });
}

/// Una fila de la lista de productos con íconos de acción (ojo, lápiz, basura).
class ProductoTile extends StatelessWidget {
  final Producto producto;
  final VoidCallback? onTap;
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  const ProductoTile({
    super.key,
    required this.producto,
    this.onTap,
    this.onView,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colors.mutedBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.inventory_2_outlined, size: 22, color: colors.textMuted),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    producto.codigo,
                    style: AppTextStyles.captionBold.copyWith(color: colors.accent),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    producto.nombre,
                    style: AppTextStyles.bodyBold.copyWith(color: colors.text),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    producto.categoria,
                    style: AppTextStyles.caption.copyWith(color: colors.textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '\$${producto.precio.toStringAsFixed(2)}',
                  style: AppTextStyles.monoBody.copyWith(fontWeight: FontWeight.bold, color: colors.text),
                ),
                const SizedBox(height: 4),
                ProductoStatusBadge(estado: producto.estado),
                const SizedBox(height: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (onView != null) ...[
                      ProductoActionIcon(
                        icon: Icons.visibility_outlined,
                        color: colors.accent,
                        onTap: onView!,
                      ),
                    ],
                    if (onView != null && (onEdit != null || onDelete != null))
                      const SizedBox(width: 4),
                    if (onEdit != null) ...[
                      ProductoActionIcon(
                        icon: Icons.edit_outlined,
                        color: colors.accent,
                        onTap: onEdit!,
                      ),
                    ],
                    if (onEdit != null && onDelete != null)
                      const SizedBox(width: 4),
                    if (onDelete != null) ...[
                      ProductoActionIcon(
                        icon: Icons.delete_outline,
                        color: colors.danger,
                        onTap: onDelete!,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
