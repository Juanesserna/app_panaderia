import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/entities/rol.dart';
import '../riverpod/roles_providers.dart';
import '../widgets/common/common_ui.dart';
import '../widgets/roles/eliminar_rol_dialog.dart';
import '../widgets/roles/detalle_rol_sheet.dart';
import '../widgets/roles/rol_form_sheet.dart';
import '../widgets/roles/rol_tile.dart';
import '../widgets/shell/app_bottom_sheet.dart';

/// Página de contenido del módulo Roles. Sigue el patrón del resto del
/// equipo: solo devuelve el CONTENIDO (Scaffold/Header/BottomNav ya los
/// pone AppShell). Se registra en `module_registry.dart`.
class RolesPage extends ConsumerStatefulWidget {
  const RolesPage({super.key});

  @override
  ConsumerState<RolesPage> createState() => _RolesPageState();
}

class _RolesPageState extends ConsumerState<RolesPage> {
  String _busqueda = '';

   @override
  Widget build(BuildContext context) {
    final roles = ref.watch(rolesProvider);
    final filtrados = _busqueda.trim().isEmpty
        ? roles
        : roles
            .where((r) =>
                r.nombre.toLowerCase().contains(_busqueda.toLowerCase()))
            .toList();
    final activos = roles.where((r) => r.estado == EstadoRol.activo).length;

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.only(bottom: 96),
          children: [
            const SizedBox(height: 12),
            SizedBox(
              height: 96,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _KpiCard(
                    label: 'Total roles',
                    value: roles.length,
                    icon: Icons.shield_outlined,
                    color: (c) => c.accent,
                  ),
                  const SizedBox(width: 12),
                  _KpiCard(
                    label: 'Roles activos',
                    value: activos,
                    icon: Icons.verified_outlined,
                    color: (c) => c.success,
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  AppSearchField(
                    placeholder: 'Buscar rol por nombre...',
                    onChanged: (v) => setState(() => _busqueda = v),
                  ),
                ],
              ),
            ),
            const SectionHeader(title: 'Roles del sistema'),
            for (int i = 0; i < filtrados.length; i++) ...[
              RolTile(
                rol: filtrados[i],
                colorIndex: roles.indexOf(filtrados[i]),
                onToggleEstado: (_) => ref
                    .read(rolesProvider.notifier)
                    .alternarEstado(filtrados[i].id),
                onView: () => showAppBottomSheet(
                  context,
                  title: filtrados[i].nombre,
                  builder: (_) => DetalleRolSheet(
                    rol: filtrados[i],
                    colorIndex: roles.indexOf(filtrados[i]),
                  ),
                ),
                onEdit: () => showAppBottomSheet(
                  context,
                  title: 'Editar rol',
                  builder: (_) => RolFormSheet(rolId: filtrados[i].id),
                ),
                onDelete: () => showDialog(
                context: context,
                builder: (_) => EliminarRolDialog(
                rolNombre: filtrados[i].nombre,
                onConfirm: () => ref
                 .read(rolesProvider.notifier)
                 .eliminarRol(filtrados[i].id),
                  ),
                ),
              ),
              if (i < filtrados.length - 1) const AppDivider(indent: 16),
            ],
          ],
        ),
        Positioned(
          right: 16,
          bottom: 24,
          child: _NuevoRolFab(
            onTap: () => showAppBottomSheet(
              context,
              title: 'Nuevo rol',
              builder: (_) => const RolFormSheet(),
            ),
          ),
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final Color Function(AppColors) color;
  const _KpiCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final c = color(colors);
    return Container(
      width: 170,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.withOpacity(0.05),
        border: Border.all(color: c.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label.toUpperCase(),
                style: AppTextStyles.tiny
                    .copyWith(color: colors.textMuted, letterSpacing: 0.6),
              ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: c.withOpacity(0.1),
                  border: Border.all(color: c.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 14, color: c),
              ),
            ],
          ),
          Text(
            '$value',
            style: AppTextStyles.monoBody.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: colors.text,
            ),
          ),
        ],
      ),
    );
  }
}

class _NuevoRolFab extends StatelessWidget {
  final VoidCallback onTap;
  const _NuevoRolFab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Material(
      color: colors.accent,
      borderRadius: BorderRadius.circular(18),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, size: 18, color: colors.accentFg),
              const SizedBox(width: 8),
              Text(
                'Nuevo rol',
                style: TextStyle(
                  color: colors.accentFg,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}