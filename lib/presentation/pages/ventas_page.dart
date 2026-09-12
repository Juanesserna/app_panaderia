import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../riverpod/ventas_providers.dart';
import '../widgets/common/common_ui.dart';
import '../widgets/shell/app_bottom_sheet.dart';
import '../widgets/ventas/detalle_venta_sheet.dart';
import '../widgets/ventas/filtros_ventas_sheet.dart';
import '../widgets/ventas/nueva_venta_sheet.dart';
import '../widgets/ventas/venta_tile.dart';

/// Página de contenido del módulo Ventas. Sigue el patrón del resto del
/// equipo: solo devuelve el CONTENIDO (Scaffold/Header/BottomNav ya los
/// pone AppShell). Se registra en `module_registry.dart`.
class VentasPage extends ConsumerWidget {
  const VentasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ventas = ref.watch(ventasProvider);

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
                  const AppSearchField(placeholder: 'Buscar venta...'),
                  const SizedBox(width: 8),
                  ActionBtn(
                    label: 'Filtros',
                    icon: Icons.filter_list,
                    onTap: () => showAppBottomSheet(
                      context,
                      title: 'Filtros',
                      builder: (_) => const FiltrosVentasSheet(),
                    ),
                  ),
                ],
              ),
            ),
            const SectionHeader(title: 'Ventas recientes'),
            for (int i = 0; i < ventas.length; i++) ...[
              VentaTile(
                venta: ventas[i],
                onTap: () => showAppBottomSheet(
                  context,
                  title: 'Detalle Venta',
                  builder: (_) => DetalleVentaSheet(venta: ventas[i]),
                ),
              ),
              if (i < ventas.length - 1) const AppDivider(indent: 16),
            ],
          ],
        ),
        Positioned(
          right: 16,
          bottom: 24,
          child: _NuevaVentaFab(
            onTap: () => showAppBottomSheet(
              context,
              title: 'Nueva venta',
              builder: (_) => const NuevaVentaSheet(),
            ),
          ),
        ),
      ],
    );
  }
}

class _NuevaVentaFab extends StatelessWidget {
  final VoidCallback onTap;
  const _NuevaVentaFab({required this.onTap});

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
              Text('Nueva Venta', style: TextStyle(color: colors.accentFg, fontWeight: FontWeight.w600, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
