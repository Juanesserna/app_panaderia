import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../widgets/categorias/categoria_action_icon.dart';

/// Página de contenido del módulo Categorías.
class CategoriasScreen extends StatelessWidget {
  CategoriasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 96),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              _buildStatsRow(colors),
              const SizedBox(height: 20),
              _buildSearchField(colors),
              const SizedBox(height: 10),
              _buildFiltersRow(colors),
              const SizedBox(height: 16),
              _buildTitleRow(context, colors),
              const SizedBox(height: 12),
              ..._categorias.map((c) => _CategoryCard(category: c)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(AppColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _StatCard(label: 'Categorías de Producto', value: '7', icon: Icons.layers_outlined, iconBg: colors.mutedBg, iconColor: colors.textMuted)),
          const SizedBox(width: 12),
          Expanded(child: _StatCard(label: 'Categorías de Insumo', value: '7', icon: Icons.label_outline, iconBg: colors.warningBg, iconColor: colors.warning)),
          const SizedBox(width: 12),
          Expanded(child: _StatCard(label: 'Total Categorías', value: '8', icon: Icons.check_circle_outline, iconBg: colors.successBg, iconColor: colors.success)),
        ],
      ),
    );
  }

  Widget _buildSearchField(AppColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: colors.warningBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            Icon(Icons.search, size: 18, color: colors.textMuted),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                style: AppTextStyles.bodyRegular.copyWith(color: colors.text),
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: 'Buscar...',
                  hintStyle: AppTextStyles.bodyRegular.copyWith(color: colors.textMuted),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersRow(AppColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _buildFilterChip('Todos los tipos', Icons.arrow_drop_down, colors)),
          const SizedBox(width: 12),
          Expanded(child: _buildFilterChip('Todas', Icons.arrow_drop_down, colors)),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData arrowIcon, AppColors colors) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyRegular.copyWith(color: colors.textMuted)),
          Icon(arrowIcon, size: 18, color: colors.textMuted),
        ],
      ),
    );
  }

  Widget _buildTitleRow(BuildContext context, AppColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Categorías', style: AppTextStyles.titleMd),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Próximamente')));
            },
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: colors.accent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add, size: 15, color: Colors.white),
                    SizedBox(width: 6),
                    Text('Nueva categoría', style: AppTextStyles.captionBold.copyWith(color: colors.accentFg)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  final List<_CategoryData> _categorias = [
    _CategoryData(
      nombre: 'Panadería',
      tipo: 'Ambos',
      productos: 12,
      insumos: 8,
      activa: true,
      dotColor: const Color(0xFF6E8B3D),
    ),
    _CategoryData(
      nombre: 'Repostería',
      tipo: 'Ambos',
      productos: 18,
      insumos: 14,
      activa: true,
      dotColor: const Color(0xFF6E8B3D),
    ),
    _CategoryData(
      nombre: 'Snacks',
      tipo: 'Ambos',
      productos: 8,
      insumos: 6,
      activa: true,
      dotColor: const Color(0xFFF2A93C),
    ),
    _CategoryData(
      nombre: 'Café y bebidas',
      tipo: 'Ambos',
      productos: 10,
      insumos: 12,
      activa: true,
      dotColor: const Color(0xFF2E7D8C),
    ),
    _CategoryData(
      nombre: 'Combos',
      tipo: 'Producto',
      productos: 5,
      insumos: 0,
      activa: true,
      dotColor: const Color(0xFF7E57C2),
    ),
    _CategoryData(
      nombre: 'Temporada',
      tipo: 'Ambos',
      productos: 3,
      insumos: 4,
      activa: true,
      dotColor: const Color(0xFFE91E63),
    ),
  ];
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
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
                  style: AppTextStyles.caption.copyWith(
                    color: colors.textMuted,
                    fontSize: 11,
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

class _CategoryCard extends StatelessWidget {
  final _CategoryData category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: category.dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.nombre,
                    style: AppTextStyles.bodyBold.copyWith(color: colors.text, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E5F5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      category.tipo,
                      style: AppTextStyles.caption.copyWith(
                        color: const Color(0xFF7B1FA2),
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.productos > 0
                        ? '${category.productos} productos${category.insumos > 0 ? ' · ${category.insumos} insumos' : ''}'
                        : '${category.insumos} insumos',
                    style: AppTextStyles.caption.copyWith(color: colors.textMuted),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    color: category.activa ? colors.successBg : colors.dangerBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    category.activa ? 'Activa' : 'Inactiva',
                    style: AppTextStyles.caption.copyWith(
                      color: category.activa ? colors.success : colors.danger,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CategoriaActionIcon(
                      icon: Icons.power_settings_new,
                      color: colors.info,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Próximamente')));
                      },
                    ),
                    const SizedBox(width: 6),
                    CategoriaActionIcon(
                      icon: Icons.edit,
                      color: colors.accent,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Próximamente')));
                      },
                    ),
                    const SizedBox(width: 6),
                    CategoriaActionIcon(
                      icon: Icons.delete_outline,
                      color: colors.danger,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Próximamente')));
                      },
                    ),
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

class _CategoryData {
  final String nombre;
  final String tipo;
  final int productos;
  final int insumos;
  final bool activa;
  final Color dotColor;

  const _CategoryData({
    required this.nombre,
    required this.tipo,
    required this.productos,
    required this.insumos,
    required this.activa,
    required this.dotColor,
  });
}