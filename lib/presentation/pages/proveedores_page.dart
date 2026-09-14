import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../riverpod/proveedores_providers.dart';
import '../widgets/common/common_ui.dart';
import '../widgets/shell/app_bottom_sheet.dart';
import '../widgets/proveedores/detalle_proveedor_sheet.dart';
import '../widgets/proveedores/filtros_proveedores_sheet.dart';
import '../widgets/proveedores/proveedor_form_sheet.dart';
import '../widgets/proveedores/proveedor_tile.dart';

/// Página de contenido del módulo Proveedores ("Directorio"). Sigue el
/// patrón del resto del equipo: solo devuelve el CONTENIDO
/// (Scaffold/Header/BottomNav ya los pone AppShell). Se registra en
/// `module_registry.dart`.
class ProveedoresPage extends ConsumerWidget {
  const ProveedoresPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proveedores = ref.watch(proveedoresFiltradosProvider);
    final filtros = ref.watch(filtrosProveedoresProvider);

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
                    placeholder: 'Buscar proveedor...',
                    onChanged: (v) => ref
                        .read(filtrosProveedoresProvider.notifier)
                        .setBusqueda(v),
                  ),
                  const SizedBox(width: 8),
                  ActionBtn(
                    label: 'Filtros',
                    icon: Icons.filter_list,
                    onTap: () => showAppBottomSheet(
                      context,
                      title: 'Filtrar proveedores',
                      builder: (_) => const FiltrosProveedoresSheet(),
                    ),
                  ),
                ],
              ),
            ),
            SectionHeader(
              title: 'Directorio',
              trailing: filtros.sinFiltrosAplicados
                  ? null
                  : Text(
                      '${proveedores.length} resultado(s)',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
            ),
            if (proveedores.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: Text('No se encontraron proveedores.')),
              )
            else
              for (int i = 0; i < proveedores.length; i++) ...[
                ProveedorTile(
                  proveedor: proveedores[i],
                  onTap: () => _abrirDetalle(context, proveedores[i].id),
                  onView: () => _abrirDetalle(context, proveedores[i].id),
                ),
                if (i < proveedores.length - 1) const AppDivider(indent: 16),
              ],
          ],
        ),
        Positioned(
          right: 16,
          bottom: 24,
          child: _NuevoProveedorFab(
            onTap: () => showAppBottomSheet(
              context,
              title: 'Nuevo proveedor',
              builder: (_) => const ProveedorFormSheet(),
            ),
          ),
        ),
      ],
    );
  }

  void _abrirDetalle(BuildContext context, String proveedorId) {
    showAppBottomSheet(
      context,
      title: 'Detalle Proveedor',
      builder: (_) => DetalleProveedorSheet(proveedorId: proveedorId),
    );
  }
}

class _NuevoProveedorFab extends StatelessWidget {
  final VoidCallback onTap;
  const _NuevoProveedorFab({required this.onTap});

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
                'Nuevo proveedor',
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
