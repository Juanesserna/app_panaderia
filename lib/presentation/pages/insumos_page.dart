import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../riverpod/insumos_providers.dart';
import '../widgets/common/common_ui.dart';
import '../widgets/shell/app_bottom_sheet.dart';
import '../widgets/insumos/detalle_insumo_sheet.dart';
import '../widgets/insumos/filtros_insumos_sheet.dart';
import '../widgets/insumos/insumos_form_sheet.dart';
import '../widgets/insumos/insumo_tile.dart';

/// Página de contenido del módulo Insumos. Sigue el patrón del resto del
/// equipo: solo devuelve el CONTENIDO (Scaffold/Header/BottomNav ya los
/// pone AppShell). Se registra en `module_registry.dart`.
class InsumosPage extends ConsumerWidget {
  const InsumosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insumos = ref.watch(insumosFiltradosProvider);
    final filtros = ref.watch(filtrosInsumosProvider);

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.only(bottom: 96),
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  AppSearchField(
                    placeholder: 'Buscar insumo...',
                    onChanged: (v) =>
                        ref.read(filtrosInsumosProvider.notifier).setBusqueda(v),
                  ),
                  const SizedBox(width: 8),
                  ActionBtn(
                    label: 'Filtros',
                    icon: Icons.filter_list,
                    onTap: () => showAppBottomSheet(
                      context,
                      title: 'Filtrar insumos',
                      builder: (_) => const FiltrosInsumosSheet(),
                    ),
                  ),
                ],
              ),
            ),
            SectionHeader(
              title: 'Inventario',
              trailing: filtros.sinFiltrosAplicados
                  ? null
                  : Text(
                      '${insumos.length} resultado(s)',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
            ),
            if (insumos.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: Text('No se encontraron insumos.')),
              )
            else
              for (int i = 0; i < insumos.length; i++) ...[
                InsumoTile(
                  insumo: insumos[i],
                  onTap: () => _abrirDetalle(context, insumos[i].id),
                  onView: () => _abrirDetalle(context, insumos[i].id),
                ),
                if (i < insumos.length - 1) const AppDivider(indent: 16),
              ],
          ],
        ),
        Positioned(
          right: 16,
          bottom: 24,
          child: _NuevoInsumoFab(
            onTap: () => showAppBottomSheet(
              context,
              title: 'Nuevo insumo',
              builder: (_) => const InsumoFormSheet(),
            ),
          ),
        ),
      ],
    );
  }

  void _abrirDetalle(BuildContext context, String insumoId) {
    showAppBottomSheet(
      context,
      title: 'Detalle Insumo',
      builder: (_) => DetalleInsumoSheet(insumoId: insumoId),
    );
  }
}

class _NuevoInsumoFab extends StatelessWidget {
  final VoidCallback onTap;
  const _NuevoInsumoFab({required this.onTap});

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
                'Nuevo insumo',
                style: TextStyle(color: colors.accentFg, fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

