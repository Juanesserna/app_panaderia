import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/currency_format.dart';
import '../../../data/models/modelo_compra.dart';
import '../../widgets/shell/app_bottom_sheet.dart';
import '../../widgets/common/common_ui.dart';

class DetalleCompraSheet extends StatefulWidget {
  final ModeloCompra compra;
  final Function(ModeloCompra)? onActualizarEstado;

  const DetalleCompraSheet({
    super.key,
    required this.compra,
    this.onActualizarEstado,
  });

  @override
  State<DetalleCompraSheet> createState() => _DetalleCompraSheetState();
}

class _DetalleCompraSheetState extends State<DetalleCompraSheet> {
  late EstadoCompra _estadoActual;

  @override
  void initState() {
    super.initState();
    _estadoActual = widget.compra.estado;
  }

  Color _obtenerColorEstado(EstadoCompra estado) {
    switch (estado) {
      case EstadoCompra.pagado:
        return Colors.green;
      case EstadoCompra.pendiente:
        return Colors.orange;
      case EstadoCompra.parcial:
        return Colors.blue;
      case EstadoCompra.cancelado:
        return Colors.red;
    }
  }

  String _fmtFecha(DateTime f) =>
      "${f.day.toString().padLeft(2, '0')}/${f.month.toString().padLeft(2, '0')}/${f.year}";

  String _fmtCantidad(double n) =>
      n == n.roundToDouble() ? n.toInt().toString() : n.toString();

  void _mostrarSelectorEstado(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    showAppBottomSheet(
      context,
      title: 'Cambiar estado',
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: EstadoCompra.values
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Material(
                      color: colors.surface2,
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          setState(() => _estadoActual = e);
                          widget.onActualizarEstado?.call(
                            ModeloCompra(
                              id: widget.compra.id,
                              proveedor: widget.compra.proveedor,
                              items: widget.compra.items,
                              total: widget.compra.total,
                              estado: e,
                              fecha: widget.compra.fecha,
                              descuentoPorcentaje:
                                  widget.compra.descuentoPorcentaje,
                            ),
                          );
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: e == _estadoActual
                                  ? colors.accent
                                  : colors.border,
                            ),
                          ),
                          child: Text(
                            ModeloCompra.obtenerEtiquetaEstado(e),
                            style: AppTextStyles.bodyBold.copyWith(
                              color: e == _estadoActual
                                  ? colors.accent
                                  : colors.text,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final compra = widget.compra;
    final colorEstado = _obtenerColorEstado(_estadoActual);

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
                    value: Text(compra.id, style: AppTextStyles.monoBody),
                  ),
                ),
                Expanded(
                  child: AppFieldDisplay(
                    label: 'Fecha',
                    value: Text(
                      _fmtFecha(compra.fecha),
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
                    label: 'Proveedor',
                    value: Text(compra.proveedor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Antes: un único AppFieldDisplay con compra.insumos (String).
            // Ahora: la lista de items con su trazabilidad de lote.
            Text(
              'Insumos',
              style: AppTextStyles.caption.copyWith(color: colors.textMuted),
            ),
            const SizedBox(height: 8),
            ...compra.items.map(
              (item) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colors.surface2,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.insumo,
                            style: AppTextStyles.bodyBold.copyWith(
                              color: colors.text,
                            ),
                          ),
                        ),
                        Text(
                          '\$${formatCurrency(item.subtotal)}',
                          style: AppTextStyles.monoBody.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colors.text,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_fmtCantidad(item.cantidad)} ${item.unidad} · \$${formatCurrency(item.valorUnitario)} c/u',
                      style: AppTextStyles.caption.copyWith(
                        color: colors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Lote ${item.lote.numero} · Disponible: '
                      '${_fmtCantidad(item.lote.cantidadDisponible)} ${item.unidad}'
                      '${item.lote.vencimiento != null ? ' · Vence ${_fmtFecha(item.lote.vencimiento!)}' : ''}',
                      style: AppTextStyles.tiny.copyWith(
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),
            if (compra.descuentoPorcentaje > 0) ...[
              Text(
                'Descuento aplicado: ${compra.descuentoPorcentaje.toStringAsFixed(0)}%',
                style: AppTextStyles.caption.copyWith(color: colors.textMuted),
              ),
              const SizedBox(height: 8),
            ],

            Row(
              children: [
                Expanded(
                  child: AppFieldDisplay(
                    label: 'Total',
                    value: Text(
                      '\$${formatCurrency(compra.total)}',
                      style: AppTextStyles.monoBody.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Text(
                  'Estado',
                  style: AppTextStyles.caption.copyWith(
                    color: colors.textMuted,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colorEstado.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: colorEstado.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    ModeloCompra.obtenerEtiquetaEstado(_estadoActual),
                    style: AppTextStyles.captionBold.copyWith(
                      color: colorEstado,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ActionBtn(
                    label: 'Cambiar estado',
                    variant: ActionBtnVariant.accent,
                    onTap: () => _mostrarSelectorEstado(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
