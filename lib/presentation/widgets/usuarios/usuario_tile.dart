import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'usuario_action_icon.dart';
import 'usuario_status_badge.dart';

/// Roles disponibles para un usuario del equipo.
enum RolUsuario { gerente, panadero, cliente, vendedor }

extension RolUsuarioLabel on RolUsuario {
  String get label {
    switch (this) {
      case RolUsuario.gerente:
        return 'Gerente';
      case RolUsuario.panadero:
        return 'Panadero';
      case RolUsuario.cliente:
        return 'Cliente';
      case RolUsuario.vendedor:
        return 'Vendedor';
    }
  }
}

/// Modelo de datos de un usuario del equipo.
class Usuario {
  final String nit;
  final String nombre;
  final String email;
  final String telefono;
  final RolUsuario rol;
  final EstadoUsuario estado;
  final List<String> permisos;

  const Usuario({
    required this.nit,
    required this.nombre,
    required this.email,
    required this.telefono,
    required this.rol,
    required this.estado,
    this.permisos = const [],
  });

  /// Copia el usuario cambiando solo los campos indicados.
  /// Se usa para el toggle de "inhabilitar / habilitar" (solo cambia estado).
  Usuario copyWith({EstadoUsuario? estado}) {
    return Usuario(
      nit: nit,
      nombre: nombre,
      email: email,
      telefono: telefono,
      rol: rol,
      estado: estado ?? this.estado,
      permisos: permisos,
    );
  }
}

/// Una fila de la lista de usuarios con íconos: ver, editar, inhabilitar.
class UsuarioTile extends StatelessWidget {
  final Usuario usuario;
  final VoidCallback? onTap;
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onToggleEstado;

  const UsuarioTile({
    super.key,
    required this.usuario,
    this.onTap,
    this.onView,
    this.onEdit,
    this.onToggleEstado,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final activo = usuario.estado == EstadoUsuario.activo;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(usuario.nombre, style: AppTextStyles.bodyBold.copyWith(color: colors.text)),
                  const SizedBox(height: 2),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: '${usuario.rol.label} · '),
                        TextSpan(
                          text: usuario.email,
                          style: AppTextStyles.caption.copyWith(color: colors.accent),
                        ),
                      ],
                    ),
                    style: AppTextStyles.caption.copyWith(color: colors.textMuted),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            UsuarioStatusBadge(estado: usuario.estado),
            const SizedBox(width: 6),
            if (onView != null)
              UsuarioActionIcon(icon: Icons.visibility_outlined, color: colors.accent, onTap: onView!),
            if (onEdit != null)
              UsuarioActionIcon(icon: Icons.edit, color: colors.accent, onTap: onEdit!),
            if (onToggleEstado != null)
              UsuarioActionIcon(
                // Sin la raya diagonal: person_off tiene una línea cruzando
                // todo el ícono; no_accounts es una personita con una "x"
                // pequeña al lado, que es justo lo que pediste.
                icon: activo ? Icons.no_accounts : Icons.person_outline,
                color: activo ? colors.danger : colors.success,
                onTap: onToggleEstado!,
              ),
          ],
        ),
      ),
    );
  }
}