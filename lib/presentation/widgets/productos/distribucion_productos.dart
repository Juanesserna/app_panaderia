import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class DistribucionProductos extends StatelessWidget {
  const DistribucionProductos({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    final categorias = [
      _CategoriaDistribucion(
        nombre: 'Panadería',
        cantidad: 3,
        color: const Color(0xFF6E8B3D),
      ),
      _CategoriaDistribucion(
        nombre: 'Repostería',
        cantidad: 2,
        color: const Color(0xFFF2A93C),
      ),
      _CategoriaDistribucion(
        nombre: 'Snacks',
        cantidad: 1,
        color: const Color(0xFF2E7D8C),
      ),
    ];

    final maxCantidad = categorias.fold<int>(
      1,
      (max, c) => c.cantidad > max ? c.cantidad : max,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
            'DISTRIBUCIÓN',
            style: AppTextStyles.tiny.copyWith(
              color: colors.textMuted,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 14),
          for (int i = 0; i < categorias.length; i++) ...[
            _BarraCategoria(
              categoria: categorias[i],
              maxCantidad: maxCantidad,
            ),
            if (i < categorias.length - 1) const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}

class _CategoriaDistribucion {
  final String nombre;
  final int cantidad;
  final Color color;

  const _CategoriaDistribucion({
    required this.nombre,
    required this.cantidad,
    required this.color,
  });
}

class _BarraCategoria extends StatelessWidget {
  final _CategoriaDistribucion categoria;
  final int maxCantidad;
  const _BarraCategoria({required this.categoria, required this.maxCantidad});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final factor = maxCantidad == 0
        ? 0.0
        : categoria.cantidad / maxCantidad;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              categoria.nombre,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.text,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${categoria.cantidad} prods',
              style: AppTextStyles.caption.copyWith(color: colors.textMuted),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: Stack(
            children: [
              Container(height: 6, color: colors.mutedBg),
              FractionallySizedBox(
                widthFactor: factor.clamp(0.0, 1.0),
                child: Container(height: 6, color: categoria.color),
              ),
            ],
          ),
        ),
      ],
    );
  }
}