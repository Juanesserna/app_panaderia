import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/venta.dart';

/// Ícono del método de pago (equivale a `MetodoIcon` del diseño web).
/// Si la venta aún no tiene ningún abono registrado, muestra un guion.
class MetodoPagoIcon extends StatelessWidget {
  final MetodoPago? metodo;
  const MetodoPagoIcon({super.key, this.metodo});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    switch (metodo) {
      case MetodoPago.efectivo:
        return Icon(Icons.payments_outlined, size: 16, color: colors.success);
      case MetodoPago.tarjeta:
        return Icon(Icons.credit_card, size: 16, color: colors.info);
      case MetodoPago.transferencia:
        return Icon(Icons.swap_horiz, size: 16, color: colors.accent);
      case null:
        return Text(
          '—',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colors.textMuted),
        );
    }
  }
}
