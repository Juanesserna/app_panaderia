import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'usuario_tile.dart';
import 'usuario_status_badge.dart';

/// Panel de filtros inline (NO es bottom sheet) que se muestra/oculta
/// bajo la barra de búsqueda al tocar el ícono de filtro.
class FiltrosUsuariosPanel extends StatelessWidget {
  final RolUsuario? rolSeleccionado;
  final EstadoUsuario? estadoSeleccionado;
  final ValueChanged<RolUsuario?> onRolChanged;
  final ValueChanged<EstadoUsuario?> onEstadoChanged;
  final VoidCallback onLimpiar;

  const FiltrosUsuariosPanel({
    super.key,
    required this.rolSeleccionado,
    required this.estadoSeleccionado,
    required this.onRolChanged,
    required this.onEstadoChanged,
    required this.onLimpiar,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _dropdownCampo(
                  colors: colors,
                  label: 'Rol',
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<RolUsuario?>(
                      isExpanded: true,
                      value: rolSeleccionado,
                      hint: Text('Todos los roles', style: AppTextStyles.bodyRegular.copyWith(color: colors.text)),
                      items: [
                        const DropdownMenuItem<RolUsuario?>(value: null, child: Text('Todos los roles')),
                        ...RolUsuario.values.map((r) => DropdownMenuItem<RolUsuario?>(value: r, child: Text(r.label))),
                      ],
                      onChanged: onRolChanged,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _dropdownCampo(
                  colors: colors,
                  label: 'Estado',
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<EstadoUsuario?>(
                      isExpanded: true,
                      value: estadoSeleccionado,
                      hint: Text('Todos', style: AppTextStyles.bodyRegular.copyWith(color: colors.text)),
                      items: [
                        const DropdownMenuItem<EstadoUsuario?>(value: null, child: Text('Todos')),
                        ...EstadoUsuario.values.map((e) => DropdownMenuItem<EstadoUsuario?>(value: e, child: Text(e.label))),
                      ],
                      onChanged: onEstadoChanged,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onLimpiar,
            child: Text('Limpiar filtros', style: AppTextStyles.captionBold.copyWith(color: colors.accent)),
          ),
        ],
      ),
    );
  }

  // 👇 Único cambio real: fondo blanco (colors.surface) + borde, en vez de colors.surface2.
  Widget _dropdownCampo({required AppColors colors, required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: AppTextStyles.tiny.copyWith(color: colors.textMuted, letterSpacing: 0.4)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: colors.border),
          ),
          child: child,
        ),
      ],
    );
  }
}