import 'package:flutter/material.dart';

/// Página de ejemplo del módulo Dashboard.
/// Patrón a seguir por todo el equipo: un widget simple que solo devuelve
/// el CONTENIDO de la pantalla. No incluye Scaffold, AppBar, BottomNav ni
/// lógica de navegación propia — todo eso ya lo provee AppShell.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Dashboard'));
  }
}
