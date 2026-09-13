import 'package:flutter/material.dart';

/// Ícono de acción sin fondo (ojo, lápiz, persona) para la fila de usuario.
/// A diferencia de ProductoActionIcon, este NO lleva caja de color detrás.
class UsuarioActionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const UsuarioActionIcon({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 20,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }
}