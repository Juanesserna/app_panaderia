import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:panaderia/domain/entities/proveedor.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../riverpod/proveedores_providers.dart';
import '../common/common_ui.dart';
import '../productos/confirmar_eliminar_dialog.dart';
import '../shell/app_bottom_sheet.dart';
import 'proveedor_form_sheet.dart';
import 'proveedor_status_badge.dart';
import 'proveedor_tipo_chip.dart';

/// Contenido del bottom sheet de detalle de un proveedor.
///
/// Se abre con:
///   showAppBottomSheet(context, title: proveedor.nombreEmpresa,
///       builder: (_) => DetalleProveedorSheet(proveedorId: proveedor.id));
class DetalleProveedorSheet extends ConsumerWidget {
  final String proveedorId;
  const DetalleProveedorSheet({super.key, required this.proveedorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proveedores = ref.watch(proveedoresProvider);
    final proveedor = proveedores.where((p) => p.id == proveedorId).firstOrNull;

    if (proveedor == null) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Text('Este proveedor ya no existe.'),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppFieldDisplay(
                    label: 'Código',
                    value: Text(
                      proveedor.id,
                      style: AppTextStyles.monoBody.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: AppFieldDisplay(
                    label: 'NIT',
                    value: Text(proveedor.nit, style: AppTextStyles.monoBody),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppFieldDisplay(
                    label: 'Contacto',
                    value: Text(
                      proveedor.nombreContacto.isEmpty
                          ? '—'
                          : proveedor.nombreContacto,
                    ),
                  ),
                ),
                Expanded(
                  child: AppFieldDisplay(
                    label: 'Teléfono',
                    value: Text(
                      proveedor.telefono.isEmpty ? '—' : proveedor.telefono,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AppFieldDisplay(
              label: 'Correo',
              value: Text(proveedor.correo.isEmpty ? '—' : proveedor.correo),
            ),
            const SizedBox(height: 12),
            AppFieldDisplay(
              label: 'Dirección',
              value: Text(
                proveedor.direccion.isEmpty ? '—' : proveedor.direccion,
              ),
            ),
            if (proveedor.tipos.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'TIPOS',
                style: AppTextStyles.tiny.copyWith(
                  color: Theme.of(context).extension<AppColors>()!.textMuted,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final tipo in proveedor.tipos)
                    ProveedorTipoChip(label: tipo.label),
                ],
              ),
            ],
            if (proveedor.descripcion.isNotEmpty) ...[
              const SizedBox(height: 16),
              AppFieldDisplay(
                label: 'Descripción',
                value: Text(proveedor.descripcion),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Estado',
                  style: AppTextStyles.caption.copyWith(
                    color: Theme.of(context).extension<AppColors>()!.textMuted,
                  ),
                ),
                const SizedBox(width: 8),
                ProveedorStatusBadge(activo: proveedor.activo),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ActionBtn(
                    label: 'Editar',
                    icon: Icons.edit_outlined,
                    onTap: () {
                      Navigator.of(context).pop();
                      showAppBottomSheet(
                        context,
                        title: 'Editar proveedor',
                        builder: (_) =>
                            ProveedorFormSheet(proveedorId: proveedor.id),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ActionBtn(
                    label: proveedor.activo
                        ? 'Cambiar a Inactivo'
                        : 'Cambiar a Activo',
                    variant: ActionBtnVariant.accent,
                    onTap: () => ref
                        .read(proveedoresProvider.notifier)
                        .cambiarEstado(proveedor.id, !proveedor.activo),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ActionBtn(
                label: 'Eliminar proveedor',
                icon: Icons.delete_outline,
                onTap: () {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (_) => ConfirmarEliminarDialog(
                      title: 'Eliminar proveedor',
                      itemName: proveedor.nombreEmpresa,
                      warningText:
                          'Este proveedor será eliminado permanentemente del directorio.',
                      onConfirm: () => ref
                          .read(proveedoresProvider.notifier)
                          .eliminarProveedor(proveedor.id),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
