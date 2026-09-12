import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/currency_format.dart';
import '../../../domain/entities/venta.dart';
import 'venta_status_badge.dart';

/// Una fila de la lista "Ventas recientes".
class VentaTile extends StatelessWidget {
  final Venta venta;
  final VoidCallback onTap;
  const VentaTile({super.key, required this.venta, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(venta.id, style: AppTextStyles.captionBold.copyWith(color: colors.accent)),
                      Text(venta.hora, style: AppTextStyles.monoCaption.copyWith(color: colors.textMuted)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    venta.nit ?? venta.usuario,
                    style: AppTextStyles.bodyBold.copyWith(color: colors.text),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(venta.fecha, style: AppTextStyles.caption.copyWith(color: colors.textMuted)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatCurrency(venta.total),
                  style: AppTextStyles.monoBody.copyWith(fontWeight: FontWeight.bold, color: colors.text),
                ),
                const SizedBox(height: 6),
                VentaStatusBadge(estado: venta.estado),
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
