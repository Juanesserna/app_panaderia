import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../widgets/common/common_ui.dart';
import '../../widgets/shell/app_bottom_sheet.dart';
import '../../widgets/productos/detalle_producto_sheet.dart';
import '../../widgets/productos/producto_tile.dart';
import '../../widgets/productos/producto_status_badge.dart';
import '../../widgets/productos/confirmar_eliminar_dialog.dart';
import '../productos/editar_producto_screen.dart';
import '../productos/nuevo_producto_screen.dart';

/// Página de contenido del módulo Productos.
class ProductosScreen extends ConsumerWidget {
  const ProductosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 96),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: 'PRODUCTOS ACTIVOS',
                        value: '5',
                        trend: '+5.6% vs. mes anterior',
                        trendColor: colors.success,
                        iconColor: colors.success,
                        iconBg: colors.successBg,
                        icon: Icons.eco,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        label: 'Agotados',
                        value: '1',
                        trend: '+0% vs. mes anterior',
                        trendColor: colors.danger,
                        iconColor: colors.danger,
                        iconBg: colors.dangerBg,
                        icon: Icons.inventory_2_outlined,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Expanded(
                      child: AppSearchField(
                        placeholder: 'Buscar producto o código...',
                      ),
                    ),
                    const SizedBox(width: 10),
                    ActionBtn(
                      label: 'Filtros',
                      icon: Icons.filter_list,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Catálogo de productos',
                  style: AppTextStyles.titleMd,
                ),
              ),
              const SizedBox(height: 12),
              ..._productos.map((p) {
                final last = p == _productos.last;
                return Column(
                  children: [
                    ProductoTile(
                      producto: p,
                      onTap: () {},
                      onView: () {
                        showAppBottomSheet(
                          context,
                          title: 'Detalle Producto',
                          builder: (_) => DetalleProductoSheet(producto: p),
                        );
                      },
                      onEdit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditarProductoScreen(producto: p),
                          ),
                        );
                      },
                      onDelete: () {
                        showDialog(
                          context: context,
                          builder: (_) => ConfirmarEliminarDialog(
                            title: 'Eliminar producto',
                            itemName: p.nombre,
                            warningText:
                                'Este producto será eliminado permanentemente del sistema.',
                          ),
                        );
                      },
                    ),
                    if (!last) const SizedBox(height: 10),
                  ],
                );
              }),
            ],
          ),
        ),
        Positioned(
          right: 16,
          bottom: 24,
          child: _NuevoProductoFab(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NuevoProductoScreen()),
              );
            },
          ),
        ),
      ],
    );
  }
}

final _productos = [
  Producto(
    codigo: 'PA-001',
    nombre: 'Pan integral (pieza)',
    categoria: 'Panadería',
    precio: 18.00,
    stock: 85,
    stockMin: 5,
    minProd: 1,
    maxProd: 50,
    estado: EstadoProducto.activo,
  ),
  Producto(
    codigo: 'RE-001',
    nombre: 'Pastel de chocolate 1kg (pieza)',
    categoria: 'Repostería',
    precio: 520.00,
    stock: 12,
    stockMin: 3,
    minProd: 1,
    maxProd: 20,
    estado: EstadoProducto.activo,
  ),
  Producto(
    codigo: 'PA-002',
    nombre: 'Croissant mantequilla (pieza)',
    categoria: 'Panadería',
    precio: 28.00,
    stock: 45,
    stockMin: 5,
    minProd: 1,
    maxProd: 50,
    estado: EstadoProducto.activo,
  ),
  Producto(
    codigo: 'RE-002',
    nombre: 'Galletas de avena x12 (paquete)',
    categoria: 'Repostería',
    precio: 75.00,
    stock: 30,
    stockMin: 5,
    minProd: 1,
    maxProd: 20,
    estado: EstadoProducto.activo,
  ),
  Producto(
    codigo: 'PA-003',
    nombre: 'Baguette francesa (pieza)',
    categoria: 'Panadería',
    precio: 42.00,
    stock: 60,
    stockMin: 5,
    minProd: 1,
    maxProd: 50,
    estado: EstadoProducto.activo,
  ),
  Producto(
    codigo: 'SN-001',
    nombre: 'Empanada queso-jamón (pieza)',
    categoria: 'Snacks',
    precio: 22.00,
    stock: 0,
    stockMin: 2,
    minProd: 1,
    maxProd: 20,
    estado: EstadoProducto.agotado,
  ),
];

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String trend;
  final Color trendColor;
  final Color iconColor;
  final Color iconBg;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.trend,
    required this.trendColor,
    required this.iconColor,
    required this.iconBg,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.captionBold.copyWith(
                    color: colors.textMuted,
                    fontSize: 11,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_upward_rounded,
                      size: 14,
                      color: trendColor,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      trend,
                      style: AppTextStyles.captionBold.copyWith(
                        color: trendColor,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
        ],
      ),
    );
  }
}

class _NuevoProductoFab extends StatelessWidget {
  final VoidCallback onTap;
  const _NuevoProductoFab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Material(
      color: colors.accent,
      borderRadius: BorderRadius.circular(18),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, size: 18, color: colors.accentFg),
              const SizedBox(width: 8),
              Text(
                'Nuevo producto',
                style: TextStyle(
                  color: colors.accentFg,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
