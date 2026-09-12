import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../pages/module_registry.dart';
import '../../riverpod/shell_providers.dart';
import 'app_bottom_nav.dart';
import 'app_header.dart';

/// Estructura fija de toda la app: Header arriba, contenido del módulo
/// activo en el medio, BottomNav abajo. Es el equivalente de App.tsx del
/// diseño web.
///
/// REGLA DE ORO para el equipo: las páginas de cada módulo NUNCA deben
/// traer su propio Scaffold, Header o BottomNav. Solo se registran en
/// module_registry.dart y AppShell se encarga del resto.
class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final module = ref.watch(currentModuleProvider);
    final pageBuilder = moduleRegistry[module] ?? (context) => placeholderPage(module);

    return Scaffold(
      appBar: const AppHeader(),
      body: SafeArea(
        top: false,
        bottom: false,
        child: pageBuilder(context),
      ),
      bottomNavigationBar: const AppBottomNav(),
    );
  }
}
