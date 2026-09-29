import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/proveedor.dart';
import 'proveedor_status_badge.dart';
import 'proveedor_tipo_chip.dart';

/// Una fila de la lista "Directorio" (pantalla Proveedores): avatar con
/// inicial, nombre de empresa, contacto/teléfono, estado, chips de tipo
/// y botón "ver detalle".
class ProveedorTile extends StatelessWidget {
  final Proveedor proveedor;
  final VoidCallback? onTap;
  final VoidCallback? onView;
  const ProveedorTile({
    super.key,
    required this.proveedor,
    this.onTap,
    this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Avatar(inicial: proveedor.inicial),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          proveedor.nombreEmpresa,
                          style: AppTextStyles.bodyBold.copyWith(
                            color: colors.text,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ProveedorStatusBadge(activo: proveedor.activo),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${proveedor.nombreContacto} · ${proveedor.telefono}',
                    style: AppTextStyles.caption.copyWith(
                      color: colors.textMuted,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (proveedor.tipos.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final tipo in proveedor.tipos)
                          ProveedorTipoChip(label: tipo.label),
                      ],
                    ),
                  ],
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

class _Avatar extends StatelessWidget {
  final String inicial;
  const _Avatar({required this.inicial});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: colors.accent, shape: BoxShape.circle),
      child: Text(
        inicial,
        style: AppTextStyles.bodyBold.copyWith(color: colors.accentFg),
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
