import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_modules.dart';
import '../../../core/constants/app_roles.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../riverpod/auth_providers.dart';
import '../../riverpod/shell_providers.dart';
import 'app_drawer_sheet.dart';

// Mismos módulos ocultos siempre que en app_drawer_sheet.dart, para saber
// si al filtrar queda algo real que mostrar en "Más".
const _kModulosOcultos = {'Inventario', 'Reportes', 'Pedidos'};

/// Barra inferior fija con los módulos principales (filtrados por el rol
/// del usuario actual) + botón "Más" (solo si le queda algo que ver ahí).
class AppBottomNav extends ConsumerWidget {
  const AppBottomNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final current = ref.watch(currentModuleProvider);
    final usuario = ref.watch(authProvider);

    // Sin sesión (no debería pasar tras el login) se ven todos; con
    // sesión, solo los módulos permitidos por el rol.
    final tabs = usuario == null
        ? kBottomTabs
        : kBottomTabs.where((t) => usuario.rol.modulosPermitidos.contains(t.module)).toList();

    // Lo que le quedaría visible en el menú "Más" (kDrawerItems, no
    // kAllNavItems: los 4 tabs de abajo no cuentan aquí).
    final drawerVisible = kDrawerItems.where((i) {
      if (_kModulosOcultos.contains(i.label)) return false;
      if (usuario != null && !usuario.rol.modulosPermitidos.contains(i.module)) return false;
      return true;
    }).toList();
    final mostrarMas = drawerVisible.isNotEmpty;
    final isMoreActive = drawerVisible.any((i) => i.module == current);

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              ...tabs.map(
                (item) => _NavButton(
                  icon: item.icon,
                  label: item.label,
                  active: current == item.module,
                  onTap: () => ref.read(currentModuleProvider.notifier).setModule(item.module),
                ),
              ),
              if (mostrarMas)
                _NavButton(
                  icon: Icons.more_horiz,
                  label: 'Más',
                  active: isMoreActive,
                  onTap: () => showAppDrawerSheet(context, ref),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _NavButton({required this.icon, required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final color = active ? colors.accent : colors.textMuted;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 2),
            Text(label, style: AppTextStyles.tiny.copyWith(color: color)),
            const SizedBox(height: 2),
            if (active)
              Container(
                width: 16,
                height: 2,
                decoration: BoxDecoration(color: colors.accent, borderRadius: BorderRadius.circular(2)),
              ),
          ],
        ),
      ),
    );
  }
}