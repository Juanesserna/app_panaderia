import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/rol.dart';

/// Color de acento por rol, ciclando la misma paleta que ya usa el resto
/// de la app — igual que en el diseño web, donde cada rol tiene su
/// propio color de nombre (Gerente, Panadero, Cliente, Vendedor...).
Color rolAccentColor(AppColors colors, int index) {
  switch (index % 4) {
    case 0:
      return colors.accent;
    case 1:
      return colors.info;
    case 2:
      return colors.success;
    default:
      return colors.warning;
  }
}

/// Ícono de acción sin fondo (ojo, lápiz, basura) para la fila de rol.
/// Mismo estilo que `UsuarioActionIcon` (sin caja de color detrás), para
/// que Roles y Usuarios se vean consistentes.
class _RolActionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _RolActionIcon({
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

/// Una fila de la lista "Roles del sistema": nombre + ID, switch para
/// activar/desactivar y acciones ver/editar/eliminar, todo en una misma
/// fila — igual que la tabla web.
class RolTile extends StatelessWidget {
  final Rol rol;
  final int colorIndex;
  final ValueChanged<bool> onToggleEstado;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const RolTile({
    super.key,
    required this.rol,
    required this.colorIndex,
    required this.onToggleEstado,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final accent = rolAccentColor(colors, colorIndex);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rol.nombre,
                  style: AppTextStyles.bodyBold.copyWith(color: accent),
                ),
                Text(
                  rol.id,
                  style: AppTextStyles.monoCaption
                      .copyWith(color: colors.textMuted),
                ),
                Text(
                  '${rol.totalPermisos} permisos',
                  style: AppTextStyles.caption
                      .copyWith(color: colors.textMuted),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.85,
            child: Switch(
              value: rol.estado == EstadoRol.activo,
              activeColor: colors.accent,
              onChanged: onToggleEstado,
            ),
          ),
          _RolActionIcon(
            icon: Icons.visibility_outlined,
            color: colors.accent,
            onTap: onView,
          ),
          _RolActionIcon(
            icon: Icons.edit_outlined,
            color: colors.accent,
            onTap: onEdit,
          ),
          _RolActionIcon(
            icon: Icons.delete_outline,
            color: colors.danger,
            onTap: onDelete,
          ),
        ],
      ),
    );
  }
}