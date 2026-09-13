import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/orden_produccion.dart';

/// Insignia de estado con los mismos colores que el diseño web
/// (completado=verde, en proceso=azul, pendiente=ámbar,
/// retrasado/cancelado=rojo).
class OrdenStatusBadge extends StatelessWidget {
  final EstadoOrden estado;
  const OrdenStatusBadge({super.key, required this.estado});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final Color color = switch (estado) {
      EstadoOrden.completado => colors.success,
      EstadoOrden.enProceso => colors.info,
      EstadoOrden.pendiente => colors.warning,
      EstadoOrden.retrasado => colors.danger,
      EstadoOrden.cancelado => colors.danger,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            estado.label,
            style: AppTextStyles.caption
                .copyWith(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
