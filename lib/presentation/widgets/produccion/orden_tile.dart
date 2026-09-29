import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/orden_produccion.dart';
import 'orden_status_badge.dart';

/// Una fila de la lista "Órdenes de producción".
class OrdenTile extends StatelessWidget {
  final OrdenProduccion orden;
  final VoidCallback onTap;
  const OrdenTile({super.key, required this.orden, required this.onTap});

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
                  Text(orden.id,
                      style: AppTextStyles.captionBold.copyWith(color: colors.accent)),
                  const SizedBox(height: 2),
                  Text(
                    orden.generadoPor.documento,
                    style: AppTextStyles.bodyBold.copyWith(color: colors.text),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(orden.fechaSolicitud,
                      style: AppTextStyles.monoCaption.copyWith(color: colors.textMuted)),
                ],
              ),
            ),
            const SizedBox(width: 10),
            OrdenStatusBadge(estado: orden.estadoEfectivo),
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
