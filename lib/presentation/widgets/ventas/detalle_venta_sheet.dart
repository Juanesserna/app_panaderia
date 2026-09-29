import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/currency_format.dart';
import '../../../core/utils/date_format.dart';
import '../../../domain/entities/venta.dart';
import '../../riverpod/ventas_providers.dart';
import '../common/common_ui.dart';
import '../shell/app_bottom_sheet.dart';
import 'metodo_pago_icon.dart';
import 'venta_status_badge.dart';

class DetalleVentaSheet extends ConsumerStatefulWidget {
  final Venta venta;
  const DetalleVentaSheet({super.key, required this.venta});

  @override
  ConsumerState<DetalleVentaSheet> createState() => _DetalleVentaSheetState();
}

enum _Vista { info, pagos }

class _DetalleVentaSheetState extends ConsumerState<DetalleVentaSheet> {
  _Vista _vista = _Vista.info;

  bool _puedeVerComprobante(Venta v) => v.estado == EstadoVenta.completado || v.estado == EstadoVenta.cancelado;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final venta = widget.venta;
    final abonos = ref.watch(abonosProvider.select((a) => a.where((x) => x.idVenta == venta.id).toList()));

    if (_vista == _Vista.info) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(child: AppFieldDisplay(label: 'ID', value: Text(venta.id, style: AppTextStyles.monoBody))),
                Expanded(child: AppFieldDisplay(label: 'Fecha', value: Text('${venta.fecha} · ${venta.hora}', style: AppTextStyles.monoBody))),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: AppFieldDisplay(label: 'Cliente', value: Text(venta.cliente ?? venta.usuario))),
                Expanded(child: AppFieldDisplay(label: 'NIT', value: Text(venta.nit ?? '—', style: AppTextStyles.monoBody))),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: AppFieldDisplay(
                    label: 'Método',
                    value: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MetodoPagoIcon(metodo: venta.metodo),
                        const SizedBox(width: 6),
                        Text(venta.metodo?.label ?? '—'),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: AppFieldDisplay(
                    label: 'Total',
                    value: Text(formatCurrency(venta.total), style: AppTextStyles.monoBody.copyWith(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: AppFieldDisplay(label: 'Canal', value: Text(venta.canal.label))),
                Expanded(child: AppFieldDisplay(label: 'Productos', value: Text(venta.productosResumen))),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Text('Estado', style: AppTextStyles.caption.copyWith(color: colors.textMuted)),
                const SizedBox(width: 8),
                VentaStatusBadge(estado: venta.estado),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ActionBtn(
                    label: 'Comprobante',
                    onTap: _puedeVerComprobante(venta) ? () => _verComprobante(context, venta) : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ActionBtn(
                    label: abonos.isNotEmpty ? 'Pagos (${abonos.length}/${venta.pagosPermitidos})' : 'Pagos',
                    onTap: () => setState(() => _vista = _Vista.pagos),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ActionBtn(
                    label: 'Cambiar estado',
                    variant: ActionBtnVariant.accent,
                    onTap: venta.estado == EstadoVenta.cancelado ? null : () => _mostrarSelectorEstado(context, venta),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // ---------- Vista de Pagos (cupos fijos) ----------
    final cantidadPagos = venta.pagosPermitidos;
    final montoPorPago = venta.total / cantidadPagos;
    final totalAbonado = abonos.where((a) => a.slot <= cantidadPagos).length * montoPorPago;
    final saldoPendiente = (venta.total - totalAbonado).clamp(0, double.infinity).toDouble();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton.icon(
              onPressed: () => setState(() => _vista = _Vista.info),
              icon: Icon(Icons.arrow_back, size: 14, color: colors.accent),
              label: Text('Volver al detalle', style: AppTextStyles.captionBold.copyWith(color: colors.accent)),
              style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            ),
            const SizedBox(height: 4),
            Text('Venta ${venta.id} · ${venta.cliente ?? venta.usuario}',
                style: AppTextStyles.caption.copyWith(color: colors.textMuted)),
            const SizedBox(height: 12),

            // Resumen total / pagado / pendiente
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.surface2,
                border: Border.all(color: colors.border),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Expanded(child: _ResumenItem(label: 'Total', value: formatCurrency(venta.total))),
                  Expanded(child: _ResumenItem(label: 'Pagado', value: formatCurrency(totalAbonado))),
                  Expanded(
                    child: _ResumenItem(
                      label: 'Pendiente',
                      value: formatCurrency(saldoPendiente),
                      color: saldoPendiente <= 0 ? colors.success : null,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Text('COMPROBANTES DE PAGO', style: AppTextStyles.tiny.copyWith(color: colors.textMuted, letterSpacing: 0.4)),
            const SizedBox(height: 8),

            for (int slot = 1; slot <= cantidadPagos; slot++) ...[
              _CupoPagoCard(
                slot: slot,
                cantidadPagos: cantidadPagos,
                montoPorPago: montoPorPago,
                abono: abonos.where((a) => a.slot == slot).firstOrNull,
                onSubir: (path) => ref.read(abonosProvider.notifier).registrarOReemplazar(
                      venta: venta,
                      slot: slot,
                      urlComprobante: path,
                    ),
              ),
              if (slot < cantidadPagos) const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }

  void _verComprobante(BuildContext context, Venta venta) {
    showAppBottomSheet(
      context,
      title: 'Comprobante de venta',
      builder: (context) => _ComprobanteVenta(venta: venta),
    );
  }

  void _mostrarSelectorEstado(BuildContext context, Venta venta) {
    showAppBottomSheet(
      context,
      title: 'Cambiar estado',
      builder: (context) {
        final colors = Theme.of(context).extension<AppColors>()!;
        final opciones = EstadoTransiciones.opcionesPara(venta.estado);
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: opciones
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Material(
                      color: colors.surface2,
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          ref.read(ventasProvider.notifier).actualizarEstado(venta.id, e);
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: e == venta.estado ? colors.accent : colors.border),
                          ),
                          child: Transform.scale(scale: 1.15, child: VentaStatusBadge(estado: e)),
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
}

/// Tarjeta de un cupo de pago: sube o reemplaza su comprobante.
class _CupoPagoCard extends StatefulWidget {
  final int slot;
  final int cantidadPagos;
  final double montoPorPago;
  final Abono? abono;
  final ValueChanged<String> onSubir;

  const _CupoPagoCard({
    required this.slot,
    required this.cantidadPagos,
    required this.montoPorPago,
    required this.abono,
    required this.onSubir,
  });

  @override
  State<_CupoPagoCard> createState() => _CupoPagoCardState();
}

class _CupoPagoCardState extends State<_CupoPagoCard> {
  final _picker = ImagePicker();
  bool _cargando = false;

  Future<void> _seleccionarImagen() async {
    setState(() => _cargando = true);
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    setState(() => _cargando = false);
    if (file != null) widget.onSubir(file.path);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final porcentaje = (100 / widget.cantidadPagos).round();
    final abono = widget.abono;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface2,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$porcentaje% · ${formatCurrency(widget.montoPorPago)}',
              style: AppTextStyles.caption.copyWith(color: colors.textMuted)),
          const SizedBox(height: 8),
          if (abono != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(File(abono.urlComprobante), width: double.infinity, height: 130, fit: BoxFit.cover),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(abono.fecha, style: AppTextStyles.tiny.copyWith(color: colors.textMuted)),
                TextButton.icon(
                  onPressed: _cargando ? null : _seleccionarImagen,
                  icon: Icon(Icons.upload_outlined, size: 14, color: colors.accent),
                  label: Text('Reemplazar', style: AppTextStyles.captionBold.copyWith(color: colors.accent)),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                ),
              ],
            ),
          ] else
            InkWell(
              onTap: _cargando ? null : _seleccionarImagen,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  border: Border.all(color: colors.border),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _cargando
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : Icon(Icons.upload_outlined, color: colors.textMuted),
                    const SizedBox(height: 6),
                    Text('Subir comprobante', style: AppTextStyles.caption.copyWith(color: colors.textMuted)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ResumenItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  const _ResumenItem({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: AppTextStyles.tiny.copyWith(color: colors.textMuted, letterSpacing: 0.4)),
        const SizedBox(height: 2),
        Text(value, style: AppTextStyles.monoBody.copyWith(fontWeight: FontWeight.bold, color: color ?? colors.text)),
      ],
    );
  }
}

/// Recibo/comprobante de una venta, formato ticket. Solo se llega aquí si
/// la venta está en "Completado" o "Cancelado".
class _ComprobanteVenta extends StatelessWidget {
  final Venta venta;
  const _ComprobanteVenta({required this.venta});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final tieneItems = venta.items.isNotEmpty;
    final totalArticulos = tieneItems ? venta.cantidadProductos : null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('PANADERÍA', style: AppTextStyles.titleMd.copyWith(color: colors.text, fontWeight: FontWeight.bold, letterSpacing: 1)),
            const SizedBox(height: 4),
            Text('Comprobante de venta', style: AppTextStyles.caption.copyWith(color: colors.textMuted)),
            const SizedBox(height: 6),
            Text(venta.id, style: AppTextStyles.monoBody.copyWith(color: colors.textMuted)),
            const SizedBox(height: 16),
            _DashedDivider(color: colors.border),
            const SizedBox(height: 14),
            _ReciboFila(label: 'Cliente', value: venta.cliente ?? venta.usuario),
            const SizedBox(height: 8),
            _ReciboFila(label: 'Fecha', value: venta.hora.isNotEmpty ? '${venta.fecha} · ${venta.hora}' : venta.fecha),
            const SizedBox(height: 8),
            _ReciboFila(label: 'NIT/Cédula', value: venta.nit ?? '—'),
            const SizedBox(height: 8),
            _ReciboFila(label: 'Pago', value: venta.metodo?.label ?? '—'),
            const SizedBox(height: 14),
            _DashedDivider(color: colors.border),
            const SizedBox(height: 14),
            if (tieneItems)
              for (final item in venta.items) ...[
                _ReciboLineaProducto(label: '${item.cantidad}x ${item.nombre}', value: formatCurrency(item.subtotal)),
                const SizedBox(height: 8),
              ]
            else
              for (final linea in venta.productosResumen.split(','))
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(linea.trim(), style: AppTextStyles.monoBody.copyWith(color: colors.text)),
                  ),
                ),
            const SizedBox(height: 6),
            _DashedDivider(color: colors.border),
            const SizedBox(height: 14),
            if (totalArticulos != null) ...[
              _ReciboFila(label: 'Artículos', value: '$totalArticulos', muted: true),
              const SizedBox(height: 8),
            ],
            _ReciboFila(label: 'TOTAL', value: formatCurrency(venta.total), bold: true),
            const SizedBox(height: 14),
            _DashedDivider(color: colors.border),
            const SizedBox(height: 16),
            VentaStatusBadge(estado: venta.estado),
          ],
        ),
      ),
    );
  }
}

class _ReciboFila extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final bool muted;
  const _ReciboFila({required this.label, required this.value, this.bold = false, this.muted = false});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final labelStyle = bold ? AppTextStyles.bodyBold.copyWith(color: colors.text) : AppTextStyles.caption.copyWith(color: colors.textMuted);
    final valueStyle = bold
        ? AppTextStyles.titleMd.copyWith(color: colors.text, fontWeight: FontWeight.bold)
        : AppTextStyles.monoBody.copyWith(color: muted ? colors.textMuted : colors.text);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(label, style: labelStyle), Text(value, style: valueStyle)],
    );
  }
}

class _ReciboLineaProducto extends StatelessWidget {
  final String label;
  final String value;
  const _ReciboLineaProducto({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: AppTextStyles.monoBody.copyWith(color: colors.text)),
        const SizedBox(width: 6),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Text('.' * 200,
                maxLines: 1, softWrap: false, overflow: TextOverflow.clip, style: AppTextStyles.caption.copyWith(color: colors.border)),
          ),
        ),
        const SizedBox(width: 6),
        Text(value, style: AppTextStyles.monoBody.copyWith(color: colors.text)),
      ],
    );
  }
}

class _DashedDivider extends StatelessWidget {
  final Color color;
  const _DashedDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 1, width: double.infinity, child: CustomPaint(painter: _DashedLinePainter(color: color)));
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 5.0;
    const dashSpace = 4.0;
    final paint = Paint()..color = color..strokeWidth = 1;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + dashWidth, 0), paint);
      x += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) => oldDelegate.color != color;
}