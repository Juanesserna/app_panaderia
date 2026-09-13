import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../common/common_ui.dart';
import 'usuario_tile.dart';
import 'usuario_status_badge.dart';

/// Contenido del bottom sheet "Nuevo usuario".
/// Solo interfaz: no crea nada real todavía, solo cierra el sheet.
class NuevoUsuarioSheet extends StatefulWidget {
  const NuevoUsuarioSheet({super.key});

  @override
  State<NuevoUsuarioSheet> createState() => _NuevoUsuarioSheetState();
}

class _NuevoUsuarioSheetState extends State<NuevoUsuarioSheet> {
  final _nitCtrl = TextEditingController();
  final _nombreCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _passConfirmCtrl = TextEditingController();

  RolUsuario? _rol;
  EstadoUsuario _estado = EstadoUsuario.activo;
  bool _mostrarPass = false;

  static const _rolesDisponibles = [
    RolUsuario.gerente,
    RolUsuario.panadero,
    RolUsuario.cliente,
    RolUsuario.vendedor,
  ];

  @override
  void dispose() {
    _nitCtrl.dispose();
    _nombreCtrl.dispose();
    _emailCtrl.dispose();
    _telefonoCtrl.dispose();
    _passCtrl.dispose();
    _passConfirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _field(colors, 'ID/NIT', _nitCtrl, 'Ej. 1234567890')),
                const SizedBox(width: 12),
                Expanded(child: _field(colors, 'Nombre completo', _nombreCtrl, 'Ej. Ana Martínez')),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: _field(colors, 'Email', _emailCtrl, 'usuario@alhorno.mx')),
                const SizedBox(width: 12),
                Expanded(child: _field(colors, 'Teléfono', _telefonoCtrl, 'Ej. 3001234567')),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: _dropdownRol(colors)),
                const SizedBox(width: 12),
                Expanded(child: _dropdownEstado(colors)),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: _passwordField(colors, 'Contraseña', _passCtrl, 'Mínimo 6 caracteres')),
                const SizedBox(width: 12),
                Expanded(
                  child: _field(
                    colors,
                    'Confirmar contraseña',
                    _passConfirmCtrl,
                    'Repetir contraseña',
                    obscure: !_mostrarPass,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: ActionBtn(label: 'Cancelar', onTap: () => Navigator.of(context).pop())),
                const SizedBox(width: 10),
                Expanded(
                  child: ActionBtn(
                    label: 'Crear usuario',
                    icon: Icons.add,
                    variant: ActionBtnVariant.accent,
                    onTap: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Próximamente')),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(AppColors colors, String text) => Text(
        text.toUpperCase(),
        style: AppTextStyles.tiny.copyWith(color: colors.textMuted, letterSpacing: 0.4),
      );

  // 👇 fondo blanco (colors.surface) + borde, y textAlignVertical.center para
  // que el texto quede centrado verticalmente en vez de pegado arriba.
  Widget _field(AppColors colors, String label, TextEditingController ctrl, String hint, {bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(colors, label),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: colors.border),
          ),
          child: TextField(
            controller: ctrl,
            obscureText: obscure,
            textAlignVertical: TextAlignVertical.center,
            style: AppTextStyles.bodyRegular.copyWith(color: colors.text),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: InputBorder.none,
              hintText: hint,
              hintStyle: AppTextStyles.bodyRegular.copyWith(color: colors.textMuted),
            ),
          ),
        ),
      ],
    );
  }

  Widget _passwordField(AppColors colors, String label, TextEditingController ctrl, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(colors, label),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: colors.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: ctrl,
                  obscureText: !_mostrarPass,
                  textAlignVertical: TextAlignVertical.center,
                  style: AppTextStyles.bodyRegular.copyWith(color: colors.text),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle: AppTextStyles.bodyRegular.copyWith(color: colors.textMuted),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => setState(() => _mostrarPass = !_mostrarPass),
                child: Text(
                  _mostrarPass ? 'Ocultar' : 'Mostrar',
                  style: AppTextStyles.captionBold.copyWith(color: colors.accent),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _dropdownRol(AppColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(colors, 'Rol'),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: colors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<RolUsuario?>(
              isExpanded: true,
              value: _rol,
              hint: Text('Seleccionar rol...', style: AppTextStyles.bodyRegular.copyWith(color: colors.textMuted)),
              items: _rolesDisponibles.map((r) => DropdownMenuItem(value: r, child: Text(r.label))).toList(),
              onChanged: (v) => setState(() => _rol = v),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dropdownEstado(AppColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(colors, 'Estado inicial'),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: colors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<EstadoUsuario>(
              isExpanded: true,
              value: _estado,
              items: EstadoUsuario.values.map((e) => DropdownMenuItem(value: e, child: Text(e.label))).toList(),
              onChanged: (v) => setState(() => _estado = v ?? _estado),
            ),
          ),
        ),
      ],
    );
  }
}