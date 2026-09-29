import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/categoria.dart';
import 'categoria_color.dart';
import 'categoria_status_badge.dart';

/// Una fila de la lista "Categorías": punto de color, nombre,
/// descripción, contadores de productos/insumos, estado y botón
/// "ver detalle" (el ojito).
class CategoriaTile extends StatelessWidget {
  final Categoria categoria;
  final VoidCallback? onTap;
  final VoidCallback? onView;
  const CategoriaTile({
    super.key,
    required this.categoria,
    this.onTap,
    this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final color = categoriaColor(categoria.colorIndex);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          categoria.nombre,
                          style: AppTextStyles.bodyBold.copyWith(
                            color: colors.text,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      CategoriaStatusBadge(activa: categoria.activa),
                    ],
                  ),
                  if (categoria.descripcion.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      categoria.descripcion,
                      style: AppTextStyles.caption.copyWith(
                        color: colors.textMuted,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    '${categoria.cantidadProductos} productos · ${categoria.cantidadInsumos} insumos',
                    style: AppTextStyles.caption.copyWith(
                      color: colors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            if (onView != null) ...[
              const SizedBox(width: 8),
              _EyeButton(onTap: onView!),
            ],
          ],
        ),
      ),
    );
  }
}

class _EyeButton extends StatelessWidget {
  final VoidCallback onTap;
  const _EyeButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Material(
      color: colors.surface2,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            Icons.visibility_outlined,
            size: 16,
            color: colors.accent,
          ),
        ),
      ),
    );
  }
}
