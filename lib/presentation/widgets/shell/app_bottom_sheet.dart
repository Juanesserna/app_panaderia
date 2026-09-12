import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Bottom sheet genérico reutilizable por todo el equipo (perfil,
/// notificaciones, menú "Más", y cualquier módulo: filtros, formularios,
/// detalle de un registro, etc.).
///
/// Uso:
///   showAppBottomSheet(
///     context,
///     title: 'Detalle Venta', // opcional
///     builder: (context) => MiContenido(),
///   );
///
/// El `builder` solo debe devolver el CONTENIDO (Column/Padding/etc.);
/// el encabezado (drag handle + título + botón cerrar) y el contenedor
/// con esquinas redondeadas ya los pone este widget.
Future<T?> showAppBottomSheet<T>(
  BuildContext context, {
  String? title,
  required WidgetBuilder builder,
  bool isScrollControlled = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    backgroundColor: Colors.transparent,
    builder: (context) {
      final colors = Theme.of(context).extension<AppColors>()!;
      return SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              if (title != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 12, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: AppTextStyles.titleMd.copyWith(color: colors.text),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: colors.textMuted),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                )
              else
                const SizedBox(height: 4),
              Flexible(child: builder(context)),
            ],
          ),
        ),
      );
    },
  );
}

/// Separador horizontal fino, consistente con `--ah-border` (equivale al
/// componente `Divider` de los diseños web).
class AppDivider extends StatelessWidget {
  final double indent;
  const AppDivider({super.key, this.indent = 0});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Divider(
      height: 1,
      thickness: 1,
      indent: indent,
      endIndent: indent,
      color: colors.border,
    );
  }
}
