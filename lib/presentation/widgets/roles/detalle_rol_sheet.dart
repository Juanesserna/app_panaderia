import 'package:flutter/material.dart';
import '../../../core/constants/app_modules.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/rol.dart';
import '../common/common_ui.dart';
import 'modulo_access_chip.dart';
import 'rol_tile.dart' show rolAccentColor;

/// Contenido del bottom sheet de detalle de un rol (solo lectura).
///
/// Se abre con:
///   showAppBottomSheet(context, title: rol.nombre,
///       builder: (_) => DetalleRolSheet(rol: rol, colorIndex: i));
class DetalleRolSheet extends StatelessWidget {
  final Rol rol;
  final int colorIndex;
  const DetalleRolSheet({
    super.key,
    required this.rol,
    required this.colorIndex,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final accent = rolAccentColor(colors, colorIndex);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(rol.nombre,
              style: AppTextStyles.titleLg.copyWith(color: accent)),
          Text(rol.id,
              style: AppTextStyles.monoCaption.copyWith(color: colors.textMuted)),
          const SizedBox(height: 16),
          AppFieldDisplay(
            label: 'Estado',
            value: Text(
              rol.estado.label,
              style: AppTextStyles.bodyBold.copyWith(
                color: rol.estado == EstadoRol.activo
                    ? colors.success
                    : colors.textMuted,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Módulos que ven por defecto los usuarios con este rol '
            '(${rol.totalPermisos} de ${kModulosAsignablesRol.length}):',
            style: AppTextStyles.bodyMedium.copyWith(color: colors.text),
          ),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            childAspectRatio: 3.6,
            children: [
              for (final modulo in kModulosAsignablesRol)
                ModuloAccessChip(
                  label: modulo.label,
                  checked: rol.modulos.contains(modulo),
                ),
            ],
          ),
        ],
      ),
    );
  }
}