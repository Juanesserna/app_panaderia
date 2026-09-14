import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Flechita para regresar de "Crear cuenta" a "Iniciar sesión" sin cerrar
/// el modal.
class BackArrowButton extends StatelessWidget {
  final VoidCallback onTap;
  const BackArrowButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Icon(Icons.arrow_back_rounded, size: 24, color: colors.text),
      ),
    );
  }
}