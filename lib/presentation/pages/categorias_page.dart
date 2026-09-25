import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../riverpod/categorias_providers.dart';
import '../widgets/common/common_ui.dart';
import '../widgets/shell/app_bottom_sheet.dart';
import '../widgets/categorias/categoria_form_sheet.dart';
import '../widgets/categorias/categoria_tile.dart';
import '../widgets/categorias/detalle_categoria_sheet.dart';
import '../widgets/categorias/filtros_categorias_sheet.dart';

/// Página de contenido del módulo Categorías. Sigue el patrón del resto
/// del equipo: solo devuelve el CONTENIDO (Scaffold/Header/BottomNav ya
/// los pone AppShell). Se registra en `module_registry.dart`.
class CategoriasPage extends ConsumerWidget {
  const CategoriasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categorias = ref.watch(categoriasFiltradasProvider);
    final stats = ref.watch(categoriasStatsProvider);
    final filtros = ref.watch(filtrosCategoriasProvider);
    final colors = Theme.of(context).extension<AppColors>()!;

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.only(bottom: 32),
          children: [
            const SizedBox(height: 12),
        SizedBox(
          height: 88,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _KpiCard(label: 'Total', value: stats.total),
              const SizedBox(width: 10),
              _KpiCard(label: 'Activas', value: stats.activas, highlight: true),
              const SizedBox(width: 10),
              _KpiCard(label: 'Inactivas', value: stats.inactivas),
              const SizedBox(width: 10),
              _KpiCard(label: 'Productos', value: stats.totalProductos),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              AppSearchField(
                placeholder: 'Buscar categoría...',
                onChanged: (v) =>
                    ref.read(filtrosCategoriasProvider.notifier).setBusqueda(v),
              ),
              const SizedBox(width: 8),
              ActionBtn(
                label: 'Filtros',
                icon: Icons.filter_list,
                onTap: () => showAppBottomSheet(
                  context,
                  title: 'Filtrar categorías',
                  builder: (_) => const FiltrosCategoriasSheet(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            children: [
              Row(
                children: [
                  Text(
                    'Categorías',
                    style: AppTextStyles.bodyBold.copyWith(color: colors.text),
                  ),
                  if (!filtros.sinFiltrosAplicados ||
                      filtros.busqueda.trim().isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Text(
                      '${categorias.length} resultado(s)',
                      style: AppTextStyles.caption.copyWith(
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        if (categorias.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(child: Text('No se encontraron categorías.')),
          )
        else
          for (final categoria in categorias)
            CategoriaTile(
              categoria: categoria,
              onTap: () => _abrirDetalle(context, categoria.id),
              onView: () => _abrirDetalle(context, categoria.id),
            ),
          ],
        ),
        Positioned(
          right: 16,
          bottom: 24,
          child: _NuevaCategoriaFab(
            onTap: () => showAppBottomSheet(
              context,
              title: 'Nueva categoría',
              builder: (_) => const CategoriaFormSheet(),
            ),
          ),
        ),
      ],
    );
  }

  void _abrirDetalle(BuildContext context, String categoriaId) {
    showAppBottomSheet(
      context,
      title: 'Detalle Categoría',
      builder: (_) => DetalleCategoriaSheet(categoriaId: categoriaId),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String label;
  final int value;
  final bool highlight;
  const _KpiCard({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final borderColor = highlight ? colors.success : colors.border;
    final bg = highlight ? colors.successBg : colors.surface;
    final labelColor = highlight ? colors.success : colors.textMuted;

    return Container(
      width: 108,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label.toUpperCase(),
            style: AppTextStyles.tiny.copyWith(
              color: labelColor,
              letterSpacing: 0.4,
            ),
          ),
          Text(
            '$value',
            style: AppTextStyles.monoBody.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colors.text,
            ),
          ),
        ],
      ),
    );
  }
}

class _NuevaCategoriaFab extends StatelessWidget {
  final VoidCallback onTap;
  const _NuevaCategoriaFab({required this.onTap});

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
                'Nueva categoría',
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
