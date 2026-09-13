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

/// Contenido del bottom sheet de detalle de una venta. Alterna
/// internamente entre la vista "info" y la de "abonos" (igual que en el
/// diseño web, dentro de la misma hoja).
///
/// Se abre con:
///   showAppBottomSheet(context, title: 'Detalle Venta', builder: (_) => DetalleVentaSheet(venta: venta));
class DetalleVentaSheet extends ConsumerStatefulWidget {
  final Venta venta;
  const DetalleVentaSheet({super.key, required this.venta});

  @override
  ConsumerState<DetalleVentaSheet> createState() => _DetalleVentaSheetState();
}

enum _Vista { info, abonos }

class _DetalleVentaSheetState extends ConsumerState<DetalleVentaSheet> {
  _Vista _vista = _Vista.info;

  File? _comprobante;
  final _montoCtrl = TextEditingController();
  MetodoPago _metodo = MetodoPago.efectivo;
  String? _abonoAConfirmarEliminar;

  final _picker = ImagePicker();

  @override
  void dispose() {
    _montoCtrl.dispose();
    super.dispose();
  }

  void _resetNuevoAbono() {
    setState(() {
      _comprobante = null;
      _montoCtrl.clear();
      _metodo = MetodoPago.efectivo;
    });
  }

  Future<void> _cargarComprobante() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (file != null) setState(() => _comprobante = File(file.path));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final venta = widget.venta;
    final abonos = ref.watch(abonosProvider.select((a) => a.where((x) => x.idVenta == venta.id).toList()));

    final totalAbonado = abonos.fold<double>(0, (s, a) => s + a.monto);
    final saldoPendiente = (venta.total - totalAbonado).clamp(0, double.infinity).toDouble();

    final montoIngresado = double.tryParse(_montoCtrl.text) ?? 0;
    final montoValido = montoIngresado > 0 && montoIngresado <= saldoPendiente + 0.001;

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
                Expanded(child: AppFieldDisplay(label: 'Fecha', value: Text(venta.fecha, style: AppTextStyles.monoBody))),
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
                        Text(venta.metodo?.label ?? 'Sin abonos'),
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
            AppFieldDisplay(label: 'Productos', value: Text(venta.productosResumen)),
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
                    onTap: venta.estado == EstadoVenta.completado
                        ? () => _verComprobante(context, venta)
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ActionBtn(
                    label: abonos.isNotEmpty ? 'Abonos (${abonos.length})' : 'Abonos',
                    onTap: () => setState(() => _vista = _Vista.abonos),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ActionBtn(
                    label: 'Cambiar estado',
                    variant: ActionBtnVariant.accent,
                    onTap: () => _mostrarSelectorEstado(context, venta),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // ---------- Vista de abonos ----------
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
            Text(
              'Venta ${venta.id} · ${venta.cliente ?? venta.usuario}',
              style: AppTextStyles.caption.copyWith(color: colors.textMuted),
            ),
            const SizedBox(height: 12),

            // Resumen total / abonado / pendiente
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
                  Expanded(child: _ResumenItem(label: 'Abonado', value: formatCurrency(totalAbonado))),
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

            Text(
              abonos.isNotEmpty ? 'HISTORIAL DE ABONOS (${abonos.length})' : 'HISTORIAL DE ABONOS',
              style: AppTextStyles.tiny.copyWith(color: colors.textMuted, letterSpacing: 0.4),
            ),
            const SizedBox(height: 8),
            if (abonos.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: colors.border, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  'Aún no hay abonos registrados para esta venta',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(color: colors.textMuted),
                ),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 220),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: abonos.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final a = abonos[i];
                    final confirmando = _abonoAConfirmarEliminar == a.id;
                    return Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: confirmando ? colors.danger.withOpacity(0.08) : colors.surface2,
                        border: Border.all(color: confirmando ? colors.danger.withOpacity(0.4) : colors.border),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(File(a.urlComprobante), width: 44, height: 44, fit: BoxFit.cover),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(a.id, style: AppTextStyles.monoCaption.copyWith(color: colors.textMuted)),
                                    Text(a.fecha, style: AppTextStyles.caption.copyWith(color: colors.textMuted)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(a.metodoPago.label, style: AppTextStyles.caption.copyWith(color: colors.textMuted)),
                                    Text(formatCurrency(a.monto), style: AppTextStyles.monoBody.copyWith(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              if (confirmando) {
                                ref.read(abonosProvider.notifier).eliminar(a.id);
                                setState(() => _abonoAConfirmarEliminar = null);
                              } else {
                                setState(() => _abonoAConfirmarEliminar = a.id);
                              }
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: confirmando ? colors.danger : null,
                              minimumSize: Size.zero,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            ),
                            child: Text(
                              confirmando ? 'Confirmar' : '✕',
                              style: AppTextStyles.tiny.copyWith(color: confirmando ? colors.accentFg : colors.textMuted),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            const AppDivider(),
            const SizedBox(height: 16),

            Text('NUEVO ABONO', style: AppTextStyles.tiny.copyWith(color: colors.textMuted, letterSpacing: 0.4)),
            const SizedBox(height: 8),

            if (saldoPendiente <= 0)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(border: Border.all(color: colors.border), borderRadius: BorderRadius.circular(14)),
                child: Text(
                  'Esta venta ya está completamente pagada.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(color: colors.success),
                ),
              )
            else if (_comprobante == null)
              InkWell(
                onTap: _cargarComprobante,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 28),
                  decoration: BoxDecoration(
                    border: Border.all(color: colors.border),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.upload_outlined, color: colors.textMuted),
                      const SizedBox(height: 6),
                      Text('Subir captura del comprobante', style: AppTextStyles.caption.copyWith(color: colors.textMuted)),
                    ],
                  ),
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('COMPROBANTE', style: AppTextStyles.tiny.copyWith(color: colors.textMuted, letterSpacing: 0.4)),
                      TextButton(
                        onPressed: _cargarComprobante,
                        style: TextButton.styleFrom(minimumSize: Size.zero, padding: EdgeInsets.zero),
                        child: Text('Reemplazar', style: AppTextStyles.tiny.copyWith(color: colors.accent)),
                      ),
                    ],
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.file(_comprobante!, width: double.infinity, height: 160, fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: AppFieldDisplay(label: 'ID abono', value: Text(ref.read(abonosProvider.notifier).siguienteId(), style: AppTextStyles.monoBody))),
                      const SizedBox(width: 12),
                      Expanded(child: AppFieldDisplay(label: 'ID venta', value: Text(venta.id, style: AppTextStyles.monoBody))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: AppFieldDisplay(label: 'Fecha abono', value: Text(fechaHoyFormateada()))),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('MÉTODO DE PAGO', style: AppTextStyles.tiny.copyWith(color: colors.textMuted, letterSpacing: 0.4)),
                            const SizedBox(height: 4),
                            Container(
                              decoration: BoxDecoration(
                                color: colors.surface2,
                                border: Border.all(color: colors.border),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<MetodoPago>(
                                  value: _metodo,
                                  isExpanded: true,
                                  dropdownColor: colors.surface2,
                                  style: AppTextStyles.bodyRegular.copyWith(color: colors.text),
                                  items: MetodoPago.values
                                      .map((m) => DropdownMenuItem(value: m, child: Text(m.label)))
                                      .toList(),
                                  onChanged: (v) => setState(() => _metodo = v ?? _metodo),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('MONTO', style: AppTextStyles.tiny.copyWith(color: colors.textMuted, letterSpacing: 0.4)),
                      Text('Máx: ${formatCurrency(saldoPendiente)}', style: AppTextStyles.tiny.copyWith(color: colors.textMuted)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    decoration: BoxDecoration(
                      color: colors.surface2,
                      border: Border.all(color: colors.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller: _montoCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: AppTextStyles.bodyRegular.copyWith(color: colors.text),
                      decoration: InputDecoration(isDense: true, border: InputBorder.none, hintText: r'$0.00'),
                      onChanged: (v) {
                        final n = double.tryParse(v);
                        if (n != null && n > saldoPendiente) {
                          _montoCtrl.text = saldoPendiente.toStringAsFixed(2);
                          _montoCtrl.selection = TextSelection.collapsed(offset: _montoCtrl.text.length);
                        }
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: !montoValido
                          ? null
                          : () {
                              ref.read(abonosProvider.notifier).registrar(
                                    Abono(
                                      id: ref.read(abonosProvider.notifier).siguienteId(),
                                      idVenta: venta.id,
                                      fecha: fechaHoyFormateada(),
                                      monto: montoIngresado,
                                      metodoPago: _metodo,
                                      urlComprobante: _comprobante!.path,
                                    ),
                                  );
                              _resetNuevoAbono();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.accent,
                        foregroundColor: colors.accentFg,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text('Registrar abono', style: AppTextStyles.bodyBold.copyWith(color: colors.accentFg)),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  /// Muestra el comprobante/recibo de esta venta (ticket con datos del
  /// negocio, cliente, items y total). Solo se invoca cuando la venta
  /// está en estado "Completado".
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
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: EstadoVenta.values
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
                            border: Border.all(
                              color: e == venta.estado ? colors.accent : colors.border,
                            ),
                          ),
                          child: Transform.scale(
                            scale: 1.15,
                            child: VentaStatusBadge(estado: e),
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

/// Recibo/comprobante de una venta, con el mismo formato que un ticket de
/// caja: encabezado del negocio, datos de la venta, items y total.
class _ComprobanteVenta extends StatelessWidget {
  final Venta venta;
  const _ComprobanteVenta({required this.venta});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final tieneItems = venta.items.isNotEmpty;
    final totalArticulos = tieneItems
        ? venta.items.fold<int>(0, (s, i) => s + i.cantidad)
        : null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'PANADERÍA',
              style: AppTextStyles.titleMd.copyWith(color: colors.text, fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
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
                    child: Text(
                      linea.trim(),
                      style: AppTextStyles.monoBody.copyWith(color: colors.text),
                    ),
                  ),
                ),
            const SizedBox(height: 6),
            _DashedDivider(color: colors.border),
            const SizedBox(height: 14),
            if (totalArticulos != null) ...[
              _ReciboFila(label: 'Artículos', value: '$totalArticulos', muted: true),
              const SizedBox(height: 8),
            ],
            _ReciboFila(
              label: 'TOTAL',
              value: formatCurrency(venta.total),
              bold: true,
            ),
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
    final labelStyle = bold
        ? AppTextStyles.bodyBold.copyWith(color: colors.text)
        : AppTextStyles.caption.copyWith(color: colors.textMuted);
    final valueStyle = bold
        ? AppTextStyles.titleMd.copyWith(color: colors.text, fontWeight: FontWeight.bold)
        : AppTextStyles.monoBody.copyWith(color: muted ? colors.textMuted : colors.text);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle),
        Text(value, style: valueStyle),
      ],
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
            child: Text(
              '.' * 200,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.clip,
              style: AppTextStyles.caption.copyWith(color: colors.border),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(value, style: AppTextStyles.monoBody.copyWith(color: colors.text)),
      ],
    );
  }
}

/// Línea horizontal punteada, como los separadores de un ticket impreso.
class _DashedDivider extends StatelessWidget {
  final Color color;
  const _DashedDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1,
      width: double.infinity,
      child: CustomPaint(
        painter: _DashedLinePainter(color: color),
      ),
    );
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