import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_modules.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/rol.dart';
import '../../riverpod/roles_providers.dart';
import '../common/common_ui.dart';
import 'modulo_access_chip.dart';

/// Contenido del bottom sheet "Nuevo rol" / "Editar rol". Se abre con:
///   showAppBottomSheet(context, title: 'Nuevo rol',
///       builder: (_) => const RolFormSheet());
///   showAppBottomSheet(context, title: 'Editar rol',
///       builder: (_) => RolFormSheet(rolId: rol.id));
class RolFormSheet extends ConsumerStatefulWidget {
  /// `null` = modo "nuevo rol". Con un id existente = modo "editar".
  final String? rolId;
  const RolFormSheet({super.key, this.rolId});

  bool get esEdicion => rolId != null;

  @override
  ConsumerState<RolFormSheet> createState() => _RolFormSheetState();
}

class _RolFormSheetState extends ConsumerState<RolFormSheet> {
  late final String _formId;
  final _nombreCtrl = TextEditingController();
  EstadoRol _estado = EstadoRol.activo;
  final Set<AppModule> _modulos = {};

  @override
  void initState() {
    super.initState();
    if (widget.esEdicion) {
      final rol = ref
          .read(rolesProvider)
          .firstWhere((r) => r.id == widget.rolId);
      _formId = rol.id;
      _nombreCtrl.text = rol.nombre;
      _estado = rol.estado;
      _modulos.addAll(rol.modulos);
    } else {
      _formId = ref.read(rolesProvider.notifier).siguienteId();
    }
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    super.dispose();
  }

  void _toggleModulo(AppModule modulo) {
    setState(() {
      if (_modulos.contains(modulo)) {
        _modulos.remove(modulo);
      } else {
        _modulos.add(modulo);
      }
    });
  }

  void _confirmar() {
    if (_nombreCtrl.text.trim().isEmpty) return;

    final rol = Rol(
      id: _formId,
      nombre: _nombreCtrl.text.trim(),
      estado: _estado,
      modulos: Set.of(_modulos),
    );

    if (widget.esEdicion) {
      ref.read(rolesProvider.notifier).actualizarRol(rol);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Rol actualizado')));
    } else {
      ref.read(rolesProvider.notifier).crearRol(rol);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Rol creado')));
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _campoIdSoloLectura(colors),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 4,
                  child: _campoNombre(colors),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _campoEstado(colors),
            const SizedBox(height: 20),
            Text(
              'Módulos que verán por defecto los usuarios con este rol:',
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
                    checked: _modulos.contains(modulo),
                    onTap: () => _toggleModulo(modulo),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ActionBtn(
                    label: 'Cancelar',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ActionBtn(
                    label: widget.esEdicion ? 'Guardar cambios' : 'Crear rol',
                    icon: widget.esEdicion ? Icons.edit_outlined : Icons.add,
                    variant: ActionBtnVariant.accent,
                    onTap: _confirmar,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text, AppColors colors) => Text(
        text,
        style: AppTextStyles.tiny
            .copyWith(color: colors.textMuted, letterSpacing: 0.4),
      );

  Widget _campoIdSoloLectura(AppColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('ID', colors),
        const SizedBox(height: 6),
        Container(
          height: 42,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: colors.mutedBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '# $_formId',
            style: AppTextStyles.monoBody.copyWith(color: colors.textMuted),
          ),
        ),
      ],
    );
  }

  Widget _campoNombre(AppColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('NOMBRE DEL ROL', colors),
        const SizedBox(height: 6),
        Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: colors.surface2,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: _nombreCtrl,
            style: AppTextStyles.bodyRegular.copyWith(color: colors.text),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              hintText: 'Ej. Supervisor de turno',
              hintStyle:
                  AppTextStyles.bodyRegular.copyWith(color: colors.textMuted),
            ),
          ),
        ),
      ],
    );
  }

  Widget _campoEstado(AppColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('ESTADO', colors),
        const SizedBox(height: 6),
        Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: colors.surface2,
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<EstadoRol>(
              value: _estado,
              isExpanded: true,
              items: EstadoRol.values
                  .map((e) => DropdownMenuItem(value: e, child: Text(e.label)))
                  .toList(),
              onChanged: (v) => setState(() => _estado = v ?? _estado),
            ),
          ),
        ),
      ],
    );
  }
}