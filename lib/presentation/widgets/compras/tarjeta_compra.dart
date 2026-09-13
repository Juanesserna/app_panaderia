import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/currency_format.dart';
import '../../../data/models/modelo_compra.dart';

class TarjetaCompra extends StatelessWidget {
  final ModeloCompra compra;
  final VoidCallback? onTap;

  const TarjetaCompra({super.key, required this.compra, this.onTap});

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

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final colorEstado = _obtenerColorEstado(compra.estado);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(compra.id, style: AppTextStyles.captionBold.copyWith(color: colors.accent)),
                      Text(
                        "${compra.fecha.day.toString().padLeft(2, '0')}/${compra.fecha.month.toString().padLeft(2, '0')}/${compra.fecha.year}",
                        style: AppTextStyles.monoCaption.copyWith(color: colors.textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    compra.proveedor,
                    style: AppTextStyles.bodyBold.copyWith(color: colors.text),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    compra.insumos,
                    style: AppTextStyles.caption.copyWith(color: colors.textMuted),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${formatCurrency(compra.total)}',
                  style: AppTextStyles.monoBody.copyWith(fontWeight: FontWeight.bold, color: colors.text),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: colorEstado.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    ModeloCompra.obtenerEtiquetaEstado(compra.estado),
                    style: TextStyle(
                      color: colorEstado,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: colors.surface2,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colors.border),
              ),
              child: Icon(Icons.visibility_outlined, size: 16, color: colors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
