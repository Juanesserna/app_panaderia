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

  const DetalleCompraSheet({super.key, required this.compra, this.onActualizarEstado});

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
                              insumos: widget.compra.insumos,
                              total: widget.compra.total,
                              estado: e,
                              fecha: widget.compra.fecha,
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
                              color: e == _estadoActual ? colors.accent : colors.border,
                            ),
                          ),
                          child: Text(
                            ModeloCompra.obtenerEtiquetaEstado(e),
                            style: AppTextStyles.bodyBold.copyWith(
                              color: e == _estadoActual ? colors.accent : colors.text,
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
                    "${compra.fecha.day.toString().padLeft(2, '0')}/${compra.fecha.month.toString().padLeft(2, '0')}/${compra.fecha.year}",
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
          Row(
            children: [
              Expanded(
                child: AppFieldDisplay(
                  label: 'Insumos',
                  value: Text(compra.insumos),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: AppFieldDisplay(
                  label: 'Total',
                  value: Text(
                    '\$${formatCurrency(compra.total)}',
                    style: AppTextStyles.monoBody.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Text('Estado', style: AppTextStyles.caption.copyWith(color: colors.textMuted)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colorEstado.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: colorEstado.withValues(alpha: 0.3)),
                ),
                child: Text(
                  ModeloCompra.obtenerEtiquetaEstado(_estadoActual),
                  style: AppTextStyles.captionBold.copyWith(color: colorEstado),
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
    );
  }
}