import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../common/common_ui.dart';
import 'usuario_tile.dart';
import 'usuario_status_badge.dart';

class EditarUsuarioSheet extends StatefulWidget {
  final Usuario usuario;
  const EditarUsuarioSheet({super.key, required this.usuario});

  @override
  State<EditarUsuarioSheet> createState() => _EditarUsuarioSheetState();
}

class _EditarUsuarioSheetState extends State<EditarUsuarioSheet> {
  late final TextEditingController _nitCtrl;
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _telefonoCtrl;
  late RolUsuario _rol;
  late EstadoUsuario _estado;

  @override
  void initState() {
    super.initState();
    _nitCtrl = TextEditingController(text: widget.usuario.nit);
    _nombreCtrl = TextEditingController(text: widget.usuario.nombre);
    _emailCtrl = TextEditingController(text: widget.usuario.email);
    _telefonoCtrl = TextEditingController(text: widget.usuario.telefono);
    _rol = widget.usuario.rol;
    _estado = widget.usuario.estado;
  }

  @override
  void dispose() {
    _nitCtrl.dispose();
    _nombreCtrl.dispose();
    _emailCtrl.dispose();
    _telefonoCtrl.dispose();
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
                Expanded(child: _field(colors, 'NIT / Cédula', _nitCtrl)),
                const SizedBox(width: 12),
                Expanded(child: _field(colors, 'Nombre completo', _nombreCtrl)),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: _field(colors, 'Email', _emailCtrl)),
                const SizedBox(width: 12),
                Expanded(child: _field(colors, 'Teléfono', _telefonoCtrl)),
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
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: ActionBtn(label: 'Cancelar', onTap: () => Navigator.of(context).pop())),
                const SizedBox(width: 10),
                Expanded(
                  child: ActionBtn(
                    label: 'Guardar cambios',
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

  Widget _field(AppColors colors, String label, TextEditingController ctrl) {
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
            textAlignVertical: TextAlignVertical.center,
            style: AppTextStyles.bodyRegular.copyWith(color: colors.text),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: InputBorder.none,
            ),
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
            child: DropdownButton<RolUsuario>(
              isExpanded: true,
              value: _rol,
              items: RolUsuario.values.map((r) => DropdownMenuItem(value: r, child: Text(r.label))).toList(),
              onChanged: (v) => setState(() => _rol = v ?? _rol),
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
        _label(colors, 'Estado'),
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