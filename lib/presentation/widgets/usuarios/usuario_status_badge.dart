import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

enum EstadoUsuario { activo, inactivo }

extension EstadoUsuarioLabel on EstadoUsuario {
  String get label => this == EstadoUsuario.activo ? 'Activo' : 'Inactivo';
}

/// Insignia de estado del usuario: Activo (verde) o Inactivo (gris).
class UsuarioStatusBadge extends StatelessWidget {
  final EstadoUsuario estado;
  const UsuarioStatusBadge({super.key, required this.estado});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final activo = estado == EstadoUsuario.activo;
    final color = activo ? colors.success : colors.mutedFg;
    final bg = activo ? colors.successBg : colors.mutedBg;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(estado.label, style: AppTextStyles.caption.copyWith(color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}