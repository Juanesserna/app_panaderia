import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/orden_produccion.dart';
import '../../riverpod/produccion_providers.dart';
import '../common/common_ui.dart';
import '../shell/app_bottom_sheet.dart';
import 'orden_form_sheet.dart';
import 'orden_status_badge.dart';

/// Contenido del bottom sheet de detalle de una orden de producción.
/// Alterna internamente entre la vista "info" y la de confirmación de
/// eliminación.
///
/// Se abre con:
///   showAppBottomSheet(context, title: 'Detalle Producción',
///       builder: (_) => DetalleOrdenSheet(ordenId: orden.id));
///
/// Recibe el `id` (no el objeto) para poder seguir mostrando los datos
/// actualizados si el usuario cambia el estado o edita la orden desde
/// una hoja apilada encima de esta.
class DetalleOrdenSheet extends ConsumerStatefulWidget {
  final String ordenId;
  const DetalleOrdenSheet({super.key, required this.ordenId});

  @override
  ConsumerState<DetalleOrdenSheet> createState() => _DetalleOrdenSheetState();
}

enum _Vista { info, confirmarEliminar }

class _DetalleOrdenSheetState extends ConsumerState<DetalleOrdenSheet> {
  _Vista _vista = _Vista.info;
  bool _insumosAbiertos = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final ordenes = ref.watch(ordenesProduccionProvider);
    final orden = ordenes.where((o) => o.id == widget.ordenId).firstOrNull;

    // La orden ya no existe (se eliminó desde otra parte): cierra la hoja.
    if (orden == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      });
      return const SizedBox.shrink();
    }

    if (_vista == _Vista.confirmarEliminar) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                style: AppTextStyles.bodyRegular.copyWith(color: colors.textMuted),
                children: [
                  const TextSpan(text: '¿Seguro que deseas eliminar la orden '),
                  TextSpan(
                    text: orden.id,
                    style: AppTextStyles.monoBody.copyWith(color: colors.text),
                  ),
                  const TextSpan(text: '? Esta acción no se puede deshacer.'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ActionBtn(
                    label: 'Cancelar',
                    onTap: () => setState(() => _vista = _Vista.info),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ActionBtn(
                    label: 'Eliminar',
                    variant: ActionBtnVariant.accent,
                    onTap: () {
                      ref.read(ordenesProduccionProvider.notifier).eliminarOrden(orden.id);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    final insumos = calcularInsumos(orden.items, ref.watch(recetasProductosProvider));

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: AppFieldDisplay(
                    label: 'ID',
                    value: Text(orden.id, style: AppTextStyles.monoBody),
                  ),
                ),
                Expanded(
                  child: AppFieldDisplay(
                    label: 'Cantidad',
                    value: Text(
                      orden.unidad != 'piezas'
                          ? '${orden.totalCantidad} ${orden.unidad}'
                          : '${orden.totalCantidad}',
                      style: AppTextStyles.monoBody,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: AppFieldDisplay(
                    label: 'F. Solicitud',
                    value: Text(orden.fechaSolicitud),
                  ),
                ),
                Expanded(
                  child: AppFieldDisplay(
                    label: 'F. Fabricación',
                    value: Text(orden.fechaFabricacion.isNotEmpty
                        ? orden.fechaFabricacion
                        : 'Por definir'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: AppFieldDisplay(
                    label: 'Generado por',
                    value: Text(orden.generadoPor.nombre),
                  ),
                ),
                Expanded(
                  child: AppFieldDisplay(
                    label: 'NIT/Cédula',
                    value: Text(orden.generadoPor.documento, style: AppTextStyles.monoBody),
                  ),
                ),
              ],
            ),
            if (orden.origen == OrigenOrden.pagina && orden.ventaId != null) ...[
              const SizedBox(height: 14),
              AppFieldDisplay(
                label: 'Venta relacionada',
                value: Text(orden.ventaId!, style: AppTextStyles.monoBody),
              ),
            ],
            const SizedBox(height: 16),

            Text('PRODUCTOS ASOCIADOS',
                style: AppTextStyles.tiny.copyWith(color: colors.textMuted, letterSpacing: 0.4)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: colors.border),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Column(
                  children: [
                    for (int i = 0; i < orden.items.length; i++) ...[
                      if (i > 0) AppDivider(indent: 0),
                      Container(
                        color: colors.surface2,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(orden.items[i].nombre,
                                style: AppTextStyles.bodyRegular.copyWith(color: colors.text)),
                            Text(
                              orden.unidad != 'piezas'
                                  ? '${orden.items[i].cantidad} ${orden.unidad}'
                                  : '${orden.items[i].cantidad}',
                              style: AppTextStyles.bodyRegular.copyWith(color: colors.textMuted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            if (insumos.isNotEmpty) ...[
              const SizedBox(height: 16),
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => setState(() => _insumosAbiertos = !_insumosAbiertos),
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.surface2,
                    border: Border.all(color: colors.border),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'INSUMOS REQUERIDOS (${insumos.length})',
                        style: AppTextStyles.tiny
                            .copyWith(color: colors.textMuted, letterSpacing: 0.4),
                      ),
                      Icon(
                        _insumosAbiertos ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        size: 18,
                        color: colors.textMuted,
                      ),
                    ],
                  ),
                ),
              ),
              if (_insumosAbiertos) ...[
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: colors.border),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Column(
                      children: [
                        for (int i = 0; i < insumos.length; i++) ...[
                          if (i > 0) AppDivider(indent: 0),
                          Container(
                            color: colors.surface2,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(insumos[i].nombre,
                                    style: AppTextStyles.bodyRegular.copyWith(color: colors.text)),
                                Text(
                                  '${_formatearCantidad(insumos[i].cantidad)} ${insumos[i].unidad}',
                                  style: AppTextStyles.monoBody.copyWith(color: colors.textMuted),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ],

            const SizedBox(height: 16),
            Row(
              children: [
                Text('Estado', style: AppTextStyles.caption.copyWith(color: colors.textMuted)),
                const SizedBox(width: 8),
                OrdenStatusBadge(estado: orden.estadoEfectivo),
              ],
            ),
            const SizedBox(height: 16),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (!orden.esEstadoFinal)
                  ActionBtn(label: 'Editar', onTap: () => _editar(context, orden)),
                if (!orden.esEstadoFinal)
                  ActionBtn(
                    label: 'Cambiar estado',
                    variant: ActionBtnVariant.accent,
                    onTap: () => _mostrarSelectorEstado(context, orden),
                  ),
                ActionBtn(
                  label: 'Eliminar',
                  onTap: () => setState(() => _vista = _Vista.confirmarEliminar),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _editar(BuildContext context, OrdenProduccion orden) {
    showAppBottomSheet(
      context,
      title: 'Editar orden ${orden.id}',
      builder: (_) => OrdenFormSheet(ordenId: orden.id),
    );
  }

  void _mostrarSelectorEstado(BuildContext context, OrdenProduccion orden) {
    showAppBottomSheet(
      context,
      title: 'Cambiar estado ${orden.id}',
      builder: (context) => _SelectorEstadoSheet(orden: orden),
    );
  }
}

/// Contenido del bottom sheet para elegir el nuevo estado de una orden.
/// Vive apilado encima del detalle: al confirmar solo se cierra a sí
/// mismo, y el detalle debajo queda con el estado ya actualizado (porque
/// observa el provider por `id`, no un objeto capturado).
class _SelectorEstadoSheet extends ConsumerStatefulWidget {
  final OrdenProduccion orden;
  const _SelectorEstadoSheet({required this.orden});

  @override
  ConsumerState<_SelectorEstadoSheet> createState() => _SelectorEstadoSheetState();
}

class _SelectorEstadoSheetState extends ConsumerState<_SelectorEstadoSheet> {
  late EstadoOrden _seleccionado = widget.orden.estadoEfectivo;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Orden ${widget.orden.id} · ${widget.orden.origen.label}',
            style: AppTextStyles.caption.copyWith(color: colors.textMuted),
          ),
          const SizedBox(height: 12),
          for (final e in EstadoOrden.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Material(
                color: colors.surface2,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => setState(() => _seleccionado = e),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: e == _seleccionado ? colors.accent : colors.border,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OrdenStatusBadge(estado: e),
                        if (e == _seleccionado)
                          Icon(Icons.check_circle, size: 18, color: colors.accent),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          if (_seleccionado == EstadoOrden.retrasado)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'Nota: el estado "retrasado" también se aplica automáticamente '
                'cuando han pasado 2 días desde la fecha de solicitud.',
                style: AppTextStyles.caption.copyWith(color: colors.textMuted),
              ),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ActionBtn(label: 'Cancelar', onTap: () => Navigator.of(context).pop()),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ActionBtn(
                  label: 'Confirmar',
                  variant: ActionBtnVariant.accent,
                  onTap: () {
                    ref
                        .read(ordenesProduccionProvider.notifier)
                        .actualizarEstado(widget.orden.id, _seleccionado);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Formatea una cantidad de insumo quitando ceros/decimales innecesarios
/// (ej. `0.300` -> `0.3`, `2.000` -> `2`).
String _formatearCantidad(double cantidad) {
  if (cantidad % 1 == 0) return cantidad.toStringAsFixed(0);
  return cantidad.toStringAsFixed(3).replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
