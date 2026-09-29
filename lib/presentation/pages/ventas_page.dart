import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/entities/venta.dart';
import '../riverpod/ventas_providers.dart';
import '../widgets/common/common_ui.dart';
import '../widgets/shell/app_bottom_sheet.dart';
import '../widgets/ventas/detalle_venta_sheet.dart';
import '../widgets/ventas/filtros_ventas_sheet.dart';
import '../widgets/ventas/nueva_venta_sheet.dart';
import '../widgets/ventas/venta_tile.dart';

class VentasPage extends ConsumerWidget {
  const VentasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ventas = ref.watch(ventasFiltradasProvider);
    final todas = ref.watch(ventasProvider);
    final enProceso = todas.where((v) => v.estado == EstadoVenta.enProceso).length;
    final cancelados = todas.where((v) => v.estado == EstadoVenta.cancelado).length;

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
                  Expanded(
                    child: _VentasKpiCard(
                      titulo: 'En proceso',
                      valor: '$enProceso',
                      icono: Icons.autorenew,
                      color: const Color(0xFFB7791F),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _VentasKpiCard(
                      titulo: 'Cancelados',
                      valor: '$cancelados',
                      icono: Icons.cancel_outlined,
                      color: const Color(0xFFC0392B),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: AppSearchField(
                      placeholder: 'Buscar venta o cliente...',
                      // Ajusta el nombre del parámetro si tu AppSearchField usa otro.
                      onChanged: (v) => ref.read(ventasBusquedaProvider.notifier).state = v,
                    ),
                  ),
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
            if (ventas.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text(
                    'Sin ventas encontradas',
                    style: AppTextStyles.caption.copyWith(
                      color: Theme.of(context).extension<AppColors>()!.textMuted,
                    ),
                  ),
                ),
              )
            else
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

class _VentasKpiCard extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icono;
  final Color color;
  const _VentasKpiCard({required this.titulo, required this.valor, required this.icono, required this.color});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        // Antes: colors.surface2 / colors.border (gris genérico del theme).
        // Ahora: tinte del mismo color que ya usa el icono de esta tarjeta.
        color: color.withOpacity(0.10),
        border: Border.all(color: color.withOpacity(0.35)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(color: color.withOpacity(0.18), borderRadius: BorderRadius.circular(10)),
            child: Icon(icono, size: 18, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: AppTextStyles.tiny.copyWith(color: colors.textMuted)),
                Text(valor, style: AppTextStyles.titleMd.copyWith(color: colors.text, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
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