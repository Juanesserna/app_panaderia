import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/categoria.dart';
import '../../riverpod/categorias_providers.dart';
import 'categoria_color.dart';

/// Tarjeta "Distribución": una barra horizontal por cada categoría
/// ACTIVA mostrando cuántos productos tiene, proporcional a la
/// categoría con más productos. Las categorías inactivas no se
/// muestran aquí (sí cuentan en el KPI "Productos" del encabezado).
class DistribucionCategorias extends ConsumerWidget {
  const DistribucionCategorias({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final categorias = ref.watch(categoriasActivasProvider);
    final maxCantidad = categorias.fold<int>(
      1,
      (max, c) => c.cantidadProductos > max ? c.cantidadProductos : max,
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
          if (categorias.isEmpty)
            Text(
              'No hay categorías activas.',
              style: AppTextStyles.bodyRegular.copyWith(
                color: colors.textMuted,
              ),
            )
          else
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

class _BarraCategoria extends StatelessWidget {
  final Categoria categoria;
  final int maxCantidad;
  const _BarraCategoria({required this.categoria, required this.maxCantidad});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final color = categoriaColor(categoria.colorIndex);
    final factor = maxCantidad == 0
        ? 0.0
        : categoria.cantidadProductos / maxCantidad;

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
              '${categoria.cantidadProductos} prods',
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
                child: Container(height: 6, color: color),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
