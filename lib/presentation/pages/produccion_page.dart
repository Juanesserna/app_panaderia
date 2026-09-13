import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/entities/orden_produccion.dart';
import '../riverpod/produccion_providers.dart';
import '../widgets/common/common_ui.dart';
import '../widgets/shell/app_bottom_sheet.dart';
import '../widgets/produccion/detalle_orden_sheet.dart';
import '../widgets/produccion/filtros_produccion_sheet.dart';
import '../widgets/produccion/orden_form_sheet.dart';
import '../widgets/produccion/orden_tile.dart';

/// Página de contenido del módulo Producción. Sigue el patrón del resto
/// del equipo: solo devuelve el CONTENIDO (Scaffold/Header/BottomNav ya
/// los pone AppShell). Se registra en `module_registry.dart`.
class ProduccionPage extends ConsumerWidget {
  const ProduccionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordenes = ref.watch(ordenesProduccionProvider);

    final enProceso =
        ordenes.where((o) => o.estadoEfectivo == EstadoOrden.enProceso).length;
    final retrasadasCanceladas = ordenes
        .where((o) =>
            o.estadoEfectivo == EstadoOrden.retrasado ||
            o.estadoEfectivo == EstadoOrden.cancelado)
        .length;

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.only(bottom: 96),
          children: [
            const SizedBox(height: 12),
            SizedBox(
              height: 96,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _KpiCard(
                    label: 'En proceso',
                    value: enProceso,
                    icon: Icons.schedule,
                    color: (c) => c.info,
                  ),
                  const SizedBox(width: 12),
                  _KpiCard(
                    label: 'Retrasadas',
                    value: retrasadasCanceladas,
                    icon: Icons.warning_amber_rounded,
                    color: (c) => c.danger,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const AppSearchField(placeholder: 'Buscar orden...'),
                  const SizedBox(width: 8),
                  ActionBtn(
                    label: 'Filtros',
                    icon: Icons.filter_list,
                    onTap: () => showAppBottomSheet(
                      context,
                      title: 'Filtros',
                      builder: (_) => const FiltrosProduccionSheet(),
                    ),
                  ),
                ],
              ),
            ),
            const SectionHeader(title: 'Órdenes de producción'),
            for (int i = 0; i < ordenes.length; i++) ...[
              OrdenTile(
                orden: ordenes[i],
                onTap: () => showAppBottomSheet(
                  context,
                  title: 'Detalle Producción',
                  builder: (_) => DetalleOrdenSheet(ordenId: ordenes[i].id),
                ),
              ),
              if (i < ordenes.length - 1) const AppDivider(indent: 16),
            ],
          ],
        ),
        Positioned(
          right: 16,
          bottom: 24,
          child: _NuevaOrdenFab(
            onTap: () => showAppBottomSheet(
              context,
              title: 'Nueva orden',
              builder: (_) => const OrdenFormSheet(),
            ),
          ),
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final Color Function(AppColors) color;
  const _KpiCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final c = color(colors);
    return Container(
      width: 210,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.withOpacity(0.05),
        border: Border.all(color: c.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label.toUpperCase(),
                style: AppTextStyles.tiny.copyWith(color: colors.textMuted, letterSpacing: 0.6),
              ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: c.withOpacity(0.1),
                  border: Border.all(color: c.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 14, color: c),
              ),
            ],
          ),
          Text(
            '$value',
            style: AppTextStyles.monoBody.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: colors.text,
            ),
          ),
        ],
      ),
    );
  }
}

class _NuevaOrdenFab extends StatelessWidget {
  final VoidCallback onTap;
  const _NuevaOrdenFab({required this.onTap});

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
              Text('Nueva Orden',
                  style: TextStyle(color: colors.accentFg, fontWeight: FontWeight.w600, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
