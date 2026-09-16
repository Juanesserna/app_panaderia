import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../widgets/common/common_ui.dart';
import '../../widgets/shell/app_bottom_sheet.dart';
import '../../widgets/productos/detalle_producto_sheet.dart';
import '../../widgets/productos/producto_tile.dart';
import '../../widgets/productos/producto_status_badge.dart';
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
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        label: 'AGOTADOS',
                        value: '1',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'CATÁLOGO',
                      style: AppTextStyles.titleMd.copyWith(
                        color: colors.accent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ..._productos.asMap().entries.map((entry) {
                final index = entry.key;
                final p = entry.value;
                return Column(
                  children: [
                    ProductoTile(
                      producto: p,
                      onTap: () {
                        showAppBottomSheet(
                          context,
                          title: 'Detalle Producto',
                          builder: (_) => DetalleProductoSheet(producto: p),
                        );
                      },
                    ),
                    if (index < _productos.length - 1)
                      const Divider(height: 1, indent: 16, endIndent: 16),
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
    codigo: 'PRD-001',
    nombre: 'Croissant de mantequilla',
    categoria: 'Bollería',
    precio: 6000,
    stock: 48,
    stockMin: 5,
    minProd: 1,
    maxProd: 50,
    estado: EstadoProducto.activo,
    imagenUrl: 'https://loremflickr.com/400/400/croissant,pastry',
  ),
  Producto(
    codigo: 'PRD-002',
    nombre: 'Pan de molde artesanal',
    categoria: 'Panes',
    precio: 14000,
    stock: 30,
    stockMin: 5,
    minProd: 1,
    maxProd: 50,
    estado: EstadoProducto.activo,
    imagenUrl: 'https://loremflickr.com/400/400/artisan,bread',
  ),
  Producto(
    codigo: 'PRD-003',
    nombre: 'Baguette tradicional',
    categoria: 'Panes',
    precio: 8500,
    stock: 0,
    stockMin: 5,
    minProd: 1,
    maxProd: 50,
    estado: EstadoProducto.agotado,
    imagenUrl: 'https://loremflickr.com/400/400/baguette,bread',
  ),
  Producto(
    codigo: 'PRD-004',
    nombre: 'Torta de chocolate',
    categoria: 'Tortas',
    precio: 65000,
    stock: 3,
    stockMin: 3,
    minProd: 1,
    maxProd: 20,
    estado: EstadoProducto.activo,
    imagenUrl: 'https://loremflickr.com/400/400/chocolate,cake',
  ),
  Producto(
    codigo: 'PRD-005',
    nombre: 'Muffin de arándanos',
    categoria: 'Bollería',
    precio: 4500,
    stock: 24,
    stockMin: 5,
    minProd: 1,
    maxProd: 50,
    estado: EstadoProducto.activo,
    imagenUrl: 'https://loremflickr.com/400/400/blueberry,muffin',
  ),
];

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

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({
    required this.label,
    required this.value,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: colors.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
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
        ],
      ),
    );
  }
}