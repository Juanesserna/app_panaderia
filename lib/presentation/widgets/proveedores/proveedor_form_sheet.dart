import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/proveedor.dart';
import '../../riverpod/proveedores_providers.dart';

enum _Tab { datos, descripcion }

/// Contenido del bottom sheet "Nuevo proveedor" / "Editar proveedor". Se
/// abre con:
///   showAppBottomSheet(context, title: 'Nuevo proveedor',
///       builder: (_) => const ProveedorFormSheet());
///   showAppBottomSheet(context, title: 'Editar proveedor',
///       builder: (_) => ProveedorFormSheet(proveedorId: id));
class ProveedorFormSheet extends ConsumerStatefulWidget {
  /// `null` = modo "nuevo proveedor". Con un id existente = modo "editar".
  final String? proveedorId;
  const ProveedorFormSheet({super.key, this.proveedorId});

  bool get esEdicion => proveedorId != null;

  @override
  ConsumerState<ProveedorFormSheet> createState() => _ProveedorFormSheetState();
}

class _ProveedorFormSheetState extends ConsumerState<ProveedorFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final String _formId;
  _Tab _tab = _Tab.datos;

  final _nombreEmpresaCtrl = TextEditingController();
  final _nitCtrl = TextEditingController();
  final _nombreContactoCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _correoCtrl = TextEditingController();
  final _direccionCtrl = TextEditingController();
  final _descripcionCtrl = TextEditingController();

  bool _activo = true;
  final Set<TipoProveedor> _tipos = {};

  @override
  void initState() {
    super.initState();
    if (widget.esEdicion) {
      final proveedores = ref.read(proveedoresProvider);
      final original = proveedores.firstWhere(
        (p) => p.id == widget.proveedorId,
      );
      _formId = original.id;
      _nombreEmpresaCtrl.text = original.nombreEmpresa;
      _nitCtrl.text = original.nit;
      _nombreContactoCtrl.text = original.nombreContacto;
      _telefonoCtrl.text = original.telefono;
      _correoCtrl.text = original.correo;
      _direccionCtrl.text = original.direccion;
      _descripcionCtrl.text = original.descripcion;
      _activo = original.activo;
      _tipos.addAll(original.tipos);
    } else {
      _formId = ref.read(proveedoresProvider.notifier).siguienteId();
    }
    _descripcionCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nombreEmpresaCtrl.dispose();
    _nitCtrl.dispose();
    _nombreContactoCtrl.dispose();
    _telefonoCtrl.dispose();
    _correoCtrl.dispose();
    _direccionCtrl.dispose();
    _descripcionCtrl.dispose();
    super.dispose();
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) {
      setState(() => _tab = _Tab.datos);
      return;
    }

    final proveedor = Proveedor(
      id: _formId,
      nombreEmpresa: _nombreEmpresaCtrl.text.trim(),
      nit: _nitCtrl.text.trim(),
      nombreContacto: _nombreContactoCtrl.text.trim(),
      telefono: _telefonoCtrl.text.trim(),
      correo: _correoCtrl.text.trim(),
      direccion: _direccionCtrl.text.trim(),
      tipos: _tipos.toList(),
      descripcion: _descripcionCtrl.text.trim(),
      activo: _activo,
    );

    final notifier = ref.read(proveedoresProvider.notifier);
    if (widget.esEdicion) {
      notifier.actualizarProveedor(proveedor);
    } else {
      notifier.registrarProveedor(proveedor);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
            child: Text(
              'Completa los datos y guarda el registro',
              style: AppTextStyles.caption.copyWith(
                color: Theme.of(context).extension<AppColors>()!.textMuted,
              ),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: _tab == _Tab.datos ? _buildDatos() : _buildDescripcion(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              children: [
                _TabSelector(
                  tab: _tab,
                  descripcionCount: _descripcionCtrl.text.length,
                  onChanged: (t) => setState(() => _tab = t),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _SecondaryButton(
                        label: 'Cancelar',
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _PrimaryButton(
                        label: widget.esEdicion
                            ? 'Guardar cambios'
                            : 'Guardar proveedor',
                        onTap: _guardar,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _Field(
                label: 'CÓDIGO',
                child: Container(
                  height: 42,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).extension<AppColors>()!.mutedBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _formId,
                    style: AppTextStyles.monoBody.copyWith(
                      color: Theme.of(
                        context,
                      ).extension<AppColors>()!.textMuted,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _Field(
                label: 'ESTADO',
                child: _Dropdown<bool>(
                  value: _activo,
                  items: const [true, false],
                  labelOf: (v) => v ? 'Activo' : 'Inactivo',
                  onChanged: (v) => setState(() => _activo = v),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _Field(
          label: 'NOMBRE EMPRESA',
          required: true,
          child: _TextField(
            controller: _nombreEmpresaCtrl,
            hint: 'Ej. Molinos El Trigal S.A.',
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'El nombre de la empresa es obligatorio'
                : null,
          ),
        ),
        const SizedBox(height: 16),
        _Field(
          label: 'NIT',
          required: true,
          child: _TextField(
            controller: _nitCtrl,
            hint: 'Ej. 900.123.456-7',
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'El NIT es obligatorio'
                : null,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _Field(
                label: 'NOMBRE CONTACTO',
                child: _TextField(
                  controller: _nombreContactoCtrl,
                  hint: 'Ej. Ana Martínez',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _Field(
                label: 'TELÉFONO',
                child: _TextField(
                  controller: _telefonoCtrl,
                  hint: 'Ej. 3001234567',
                  keyboardType: TextInputType.phone,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _Field(
          label: 'CORREO ELECTRÓNICO',
          child: _TextField(
            controller: _correoCtrl,
            hint: 'usuario@empresa.com',
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return null;
              final ok = RegExp(
                r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
              ).hasMatch(v.trim());
              return ok ? null : 'Correo inválido';
            },
          ),
        ),
        const SizedBox(height: 16),
        _Field(
          label: 'DIRECCIÓN',
          child: _TextField(
            controller: _direccionCtrl,
            hint: 'Calle, carrera, barrio...',
            maxLines: 2,
          ),
        ),
        const SizedBox(height: 16),
        _Field(
          label: 'TIPOS',
          child: _TiposSelector(
            seleccionados: _tipos,
            onToggle: (tipo) => setState(() {
              _tipos.contains(tipo) ? _tipos.remove(tipo) : _tipos.add(tipo);
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildDescripcion() {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _Field(
          label: 'DESCRIPCIÓN',
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: colors.surface2,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextFormField(
              controller: _descripcionCtrl,
              minLines: 6,
              maxLines: 10,
              maxLength: 300,
              style: AppTextStyles.bodyRegular.copyWith(color: colors.text),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                counterText: '',
                hintText:
                    'Notas adicionales sobre el proveedor: condiciones de pago, horarios de entrega, observaciones...',
                hintStyle: AppTextStyles.bodyRegular.copyWith(
                  color: colors.textMuted,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------- Helpers de UI internos del formulario ----------

class _TabSelector extends StatelessWidget {
  final _Tab tab;
  final int descripcionCount;
  final ValueChanged<_Tab> onChanged;
  const _TabSelector({
    required this.tab,
    required this.descripcionCount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      decoration: BoxDecoration(
        color: colors.mutedBg,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              icon: Icons.badge_outlined,
              label: 'Datos',
              selected: tab == _Tab.datos,
              onTap: () => onChanged(_Tab.datos),
            ),
          ),
          Expanded(
            child: _TabButton(
              label: 'Descripción ($descripcionCount)',
              selected: tab == _Tab.descripcion,
              onTap: () => onChanged(_Tab.descripcion),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final IconData? icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TabButton({
    this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Material(
      color: selected ? colors.surface : Colors.transparent,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        borderRadius: BorderRadius.circular(9),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 14,
                  color: selected ? colors.accent : colors.textMuted,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: AppTextStyles.captionBold.copyWith(
                  color: selected ? colors.accent : colors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TiposSelector extends StatelessWidget {
  final Set<TipoProveedor> seleccionados;
  final ValueChanged<TipoProveedor> onToggle;
  const _TiposSelector({required this.seleccionados, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: TipoProveedor.values.map((tipo) {
        final activo = seleccionados.contains(tipo);
        return InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () => onToggle(tipo),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: activo ? colors.accent : Colors.transparent,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: activo ? colors.accent : colors.border),
            ),
            child: Text(
              tipo.label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: activo ? colors.accentFg : colors.text,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final bool required;
  final Widget child;
  const _Field({
    required this.label,
    this.required = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label + (required ? ' *' : ''),
          style: AppTextStyles.tiny.copyWith(
            color: required ? colors.danger : colors.textMuted,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

class _TextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  const _TextField({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: colors.surface2,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: AppTextStyles.bodyRegular.copyWith(color: colors.text),
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          hintText: hint,
          hintStyle: AppTextStyles.bodyRegular.copyWith(
            color: colors.textMuted,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        validator: validator,
      ),
    );
  }
}

class _Dropdown<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final String Function(T) labelOf;
  final ValueChanged<T> onChanged;
  const _Dropdown({
    required this.value,
    required this.items,
    required this.labelOf,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: colors.surface2,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          style: AppTextStyles.bodyRegular.copyWith(color: colors.text),
          dropdownColor: colors.surface2,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(labelOf(e))))
              .toList(),
          onChanged: (v) => v != null ? onChanged(v) : null,
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.accent,
        foregroundColor: colors.accentFg,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodyBold.copyWith(color: colors.accentFg),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _SecondaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.text,
        side: BorderSide(color: colors.border),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodyBold.copyWith(color: colors.text),
      ),
    );
  }
}
