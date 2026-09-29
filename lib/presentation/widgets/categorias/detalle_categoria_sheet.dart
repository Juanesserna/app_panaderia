import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../riverpod/categorias_providers.dart';
import '../common/common_ui.dart';
import '../productos/confirmar_eliminar_dialog.dart';
import '../shell/app_bottom_sheet.dart';
import 'categoria_color.dart';
import 'categoria_form_sheet.dart';
import 'categoria_status_badge.dart';

/// Contenido del bottom sheet de detalle de una categoría (se abre con
/// el ojito de `CategoriaTile`).
///
///   showAppBottomSheet(context, title: 'Detalle Categoría',
///       builder: (_) => DetalleCategoriaSheet(categoriaId: categoria.id));
class DetalleCategoriaSheet extends ConsumerWidget {
  final String categoriaId;
  const DetalleCategoriaSheet({super.key, required this.categoriaId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categorias = ref.watch(categoriasProvider);
    final categoria = categorias.where((c) => c.id == categoriaId).firstOrNull;

    if (categoria == null) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Text('Esta categoría ya no existe.'),
      );
    }

    final colors = Theme.of(context).extension<AppColors>()!;
    final color = categoriaColor(categoria.colorIndex);

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
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    categoria.nombre,
                    style: AppTextStyles.titleMd.copyWith(color: colors.text),
                  ),
                ),
                CategoriaStatusBadge(activa: categoria.activa),
              ],
            ),
            const SizedBox(height: 4),
            AppFieldDisplay(
              label: 'Código',
              value: Text(
                categoria.id,
                style: AppTextStyles.monoBody.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            AppFieldDisplay(
              label: 'Descripción',
              value: Text(
                categoria.descripcion.isEmpty ? '—' : categoria.descripcion,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: AppFieldDisplay(
                    label: 'Productos',
                    value: Text('${categoria.cantidadProductos}'),
                  ),
                ),
                Expanded(
                  child: AppFieldDisplay(
                    label: 'Insumos',
                    value: Text('${categoria.cantidadInsumos}'),
                  ),
                ),
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
                        title: 'Editar categoría',
                        builder: (_) =>
                            CategoriaFormSheet(categoriaId: categoria.id),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ActionBtn(
                    label: categoria.activa
                        ? 'Cambiar a Inactivo'
                        : 'Cambiar a Activo',
                    variant: ActionBtnVariant.accent,
                    onTap: () => ref
                        .read(categoriasProvider.notifier)
                        .cambiarEstado(categoria.id, !categoria.activa),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ActionBtn(
                label: 'Eliminar categoría',
                icon: Icons.delete_outline,
                onTap: () {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (_) => ConfirmarEliminarDialog(
                      title: 'Eliminar categoría',
                      itemName: categoria.nombre,
                      warningText:
                          'Esta categoría será eliminada permanentemente del catálogo.',
                      onConfirm: () => ref
                          .read(categoriasProvider.notifier)
                          .eliminarCategoria(categoria.id),
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
