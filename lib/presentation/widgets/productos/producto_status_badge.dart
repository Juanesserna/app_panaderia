import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

enum EstadoProducto { activo, agotado }

extension EstadoProductoLabel on EstadoProducto {
  String get label {
    switch (this) {
      case EstadoProducto.activo:
        return 'Activo';
      case EstadoProducto.agotado:
        return 'Agotado';
    }
  }
}

/// Insignia de estado del producto: Activo (verde) o Agotado (rojo).
class ProductoStatusBadge extends StatelessWidget {
  final EstadoProducto estado;
  const ProductoStatusBadge({super.key, required this.estado});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final Color color = switch (estado) {
      EstadoProducto.activo => colors.success,
      EstadoProducto.agotado => colors.danger,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
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
            style: AppTextStyles.caption.copyWith(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
