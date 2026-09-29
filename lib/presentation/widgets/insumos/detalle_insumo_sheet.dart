import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/insumo_inventario.dart';
import '../../riverpod/insumos_providers.dart';
import '../common/common_ui.dart';
import '../productos/confirmar_eliminar_dialog.dart';
import '../shell/app_bottom_sheet.dart';
import 'insumos_form_sheet.dart';
import 'insumo_status_badge.dart';

/// Contenido del bottom sheet de detalle de un insumo.
///
/// Se abre con:
///   showAppBottomSheet(context, title: 'Detalle Insumo',
///       builder: (_) => DetalleInsumoSheet(insumoId: insumo.id));
class DetalleInsumoSheet extends ConsumerWidget {
  final String insumoId;
  const DetalleInsumoSheet({super.key, required this.insumoId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final insumos = ref.watch(insumosProvider);
    final insumo = insumos.where((i) => i.id == insumoId).firstOrNull;

    if (insumo == null) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Text('Este insumo ya no existe.'),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            _sectionHeader(
              context,
              Icons.label_outlined,
              'Información general',
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: AppFieldDisplay(
                    label: 'CÓDIGO',
                    value: Text(
                      insumo.id,
                      style: AppTextStyles.monoBody.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: AppFieldDisplay(
                    label: 'NOMBRE',
                    value: Text(insumo.nombre),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: AppFieldDisplay(
                    label: 'CATEGORÍA',
                    value: Text(insumo.categoria.label),
                  ),
                ),
                Expanded(
                  child: AppFieldDisplay(
                    label: 'UNIDAD',
                    value: Text(insumo.unidad.label),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _sectionHeader(
              context,
              Icons.inventory_2_outlined,
              'Información de stock',
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: AppFieldDisplay(
                    label: 'STOCK ACTUAL',
                    value: Text(
                      '${_formatNumero(insumo.stockActual)} ${insumo.unidad.label}',
                      style: AppTextStyles.monoBody.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: insumo.nivelStock == NivelStock.agotado
                            ? colors.danger
                            : colors.text,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: AppFieldDisplay(
                    label: 'STOCK MÍNIMO',
                    value: Text(
                      '${_formatNumero(insumo.stockMinimo)} ${insumo.unidad.label}',
                      style: AppTextStyles.monoBody.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'Nivel de stock',
                  style: AppTextStyles.caption.copyWith(
                    color: colors.textMuted,
                  ),
                ),
                const SizedBox(width: 8),
                InsumoStatusBadge(nivel: insumo.nivelStock),
                const Spacer(),
                Text(
                  'Estado',
                  style: AppTextStyles.caption.copyWith(
                    color: colors.textMuted,
                  ),
                ),
                const SizedBox(width: 8),
                _EstadoBadge(activo: insumo.activo),
              ],
            ),
            const SizedBox(height: 16),
            _sectionHeader(
              context,
              Icons.archive_outlined,
              'Lotes (${insumo.cantidadLotes})',
            ),
            const SizedBox(height: 8),
            if (insumo.lotes.isEmpty)
              Text(
                'Sin lotes registrados',
                style: AppTextStyles.caption.copyWith(color: colors.textMuted),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: colors.surface2,
                  border: Border.all(color: colors.border),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    for (int i = 0; i < insumo.lotes.length; i++) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 14,
                              color: colors.textMuted,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${_formatNumero(insumo.lotes[i].cantidad)} ${insumo.unidad.label}',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: colors.text,
                                ),
                              ),
                            ),
                            if (insumo.lotes[i].fechaVencimiento.isNotEmpty)
                              Text(
                                'Vence ${insumo.lotes[i].fechaVencimiento}',
                                style: AppTextStyles.caption.copyWith(
                                  color: colors.textMuted,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (i < insumo.lotes.length - 1) const AppDivider(),
                    ],
                  ],
                ),
              ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ActionBtn(
                    label: 'Editar',
                    icon: Icons.edit_outlined,
                    onTap: () {
                      Navigator.of(context).pop();
                      showAppBottomSheet(
                        context,
                        title: 'Editar insumo',
                        builder: (_) => InsumoFormSheet(insumoId: insumo.id),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ActionBtn(
                    label: insumo.activo ? 'Desactivar' : 'Activar',
                    variant: ActionBtnVariant.accent,
                    onTap: () => ref
                        .read(insumosProvider.notifier)
                        .cambiarEstado(insumo.id, !insumo.activo),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ActionBtn(
                label: 'Eliminar insumo',
                icon: Icons.delete_outline,
                onTap: () {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (_) => ConfirmarEliminarDialog(
                      title: 'Eliminar insumo',
                      itemName: insumo.nombre,
                      warningText:
                          'Este insumo será eliminado permanentemente del inventario.',
                      onConfirm: () => ref
                          .read(insumosProvider.notifier)
                          .eliminarInsumo(insumo.id),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumero(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toString();

  Widget _sectionHeader(BuildContext context, IconData icon, String title) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Row(
      children: [
        Icon(icon, size: 16, color: colors.textMuted),
        const SizedBox(width: 6),
        Text(title, style: AppTextStyles.bodyBold.copyWith(color: colors.text)),
      ],
    );
  }
}

class _EstadoBadge extends StatelessWidget {
  final bool activo;
  const _EstadoBadge({required this.activo});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final fg = activo ? colors.success : colors.mutedFg;
    final bg = activo ? colors.successBg : colors.mutedBg;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        activo ? 'Activo' : 'Inactivo',
        style: AppTextStyles.captionBold.copyWith(color: fg, fontSize: 11),
      ),
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
