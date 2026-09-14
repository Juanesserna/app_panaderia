import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/insumo_inventario.dart';
import 'insumo_status_badge.dart';

/// Una fila de la lista "Inventario" (pantalla Insumos), con nombre,
/// categoría, badge de nivel de stock, barra de progreso, mínimo,
/// cantidad de lotes y botón "ver detalle".
class InsumoTile extends StatelessWidget {
  final InsumoInventario insumo;
  final VoidCallback? onTap;
  final VoidCallback? onView;
  const InsumoTile({super.key, required this.insumo, this.onTap, this.onView});

  Color _colorBarra(AppColors colors) {
    switch (insumo.nivelStock) {
      case NivelStock.normal:
        return colors.success;
      case NivelStock.stockBajo:
        return colors.warning;
      case NivelStock.agotado:
        return colors.danger;
    }
  }

  String _formatCantidad(double v) {
    return v == v.roundToDouble() ? v.toInt().toString() : v.toString();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final unidad = insumo.unidad.label;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          insumo.nombre,
                          style: AppTextStyles.bodyBold.copyWith(
                            color: colors.text,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_formatCantidad(insumo.stockActual)} $unidad',
                        style: AppTextStyles.monoBody.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.text,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${insumo.categoria.label} · $unidad',
                          style: AppTextStyles.caption.copyWith(
                            color: colors.textMuted,
                          ),
                        ),
                      ),
                      InsumoStatusBadge(nivel: insumo.nivelStock),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: insumo.proporcionStock,
                      minHeight: 5,
                      backgroundColor: colors.mutedBg,
                      valueColor: AlwaysStoppedAnimation(_colorBarra(colors)),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Min: ${_formatCantidad(insumo.stockMinimo)} $unidad',
                          style: AppTextStyles.caption.copyWith(
                            color: colors.textMuted,
                          ),
                        ),
                      ),
                      Text(
                        '${insumo.cantidadLotes} lote(s)',
                        style: AppTextStyles.caption.copyWith(
                          color: colors.textMuted,
                        ),
                      ),
                    ],
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
