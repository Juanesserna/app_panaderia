import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../widgets/shell/app_bottom_sheet.dart';
import 'detalle_producto_sheet.dart';
import 'producto_status_badge.dart';

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
  final String imagenUrl;
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
    required this.imagenUrl,
  });
}

class ProductoTile extends StatelessWidget {
  final Producto producto;
  final VoidCallback? onTap;

  const ProductoTile({
    super.key,
    required this.producto,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return InkWell(
      onTap: onTap ?? () {
        showAppBottomSheet(
          context,
          title: 'Detalle Producto',
          builder: (_) => DetalleProductoSheet(producto: producto),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                producto.imagenUrl,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 64,
                  height: 64,
                  color: colors.mutedBg,
                  child: Icon(Icons.image_outlined, size: 24, color: colors.textMuted),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    producto.nombre,
                    style: AppTextStyles.bodyBold.copyWith(
                      color: colors.text,
                      fontSize: 15,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${producto.codigo} · ${producto.categoria}',
                    style: AppTextStyles.caption.copyWith(
                      color: colors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${producto.precio.toStringAsFixed(0).replaceAllMapped(
                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                        (Match m) => '${m[1]}.')}',
                    style: AppTextStyles.bodyBold.copyWith(
                      color: colors.accent,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ProductoStatusBadge(estado: producto.estado),
                const SizedBox(height: 8),
                Text(
                  'Stock: ${producto.stock}',
                  style: AppTextStyles.caption.copyWith(
                    color: colors.textMuted,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}