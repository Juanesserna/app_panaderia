import 'package:flutter/material.dart';
import '../../core/constants/app_modules.dart';
import '../screens/productos/productos_screen.dart';
import 'dashboard_page.dart';
import 'ventas_page.dart';
// import 'produccion_page.dart';
// ...cada compañero agrega aquí el import de su página

/// ÚNICO lugar del proyecto donde se conecta cada [AppModule] con su
/// pantalla real. Flujo para el equipo cuando terminan un módulo:
///   1. Crear la página en presentation/pages/<modulo>_page.dart
///      (un widget simple, sin Scaffold/Header/BottomNav propios).
///   2. Importarla arriba.
///   3. Agregar/reemplazar su entrada en el mapa de abajo.
/// AppShell se encarga solo de mostrarla: no hay que tocar nada más
/// (ni Header, ni BottomNav, ni navegación).
final Map<AppModule, WidgetBuilder> moduleRegistry = {
  AppModule.dashboard: (context) => const DashboardPage(),
  AppModule.ventas: (context) => const VentasPage(),
  // AppModule.produccion: (context) => const ProduccionPage(),
  // AppModule.insumos: (context) => const InsumosPage(),
  // AppModule.compras: (context) => const ComprasPage(),
  // AppModule.proveedores: (context) => const ProveedoresPage(),
  // AppModule.categorias: (context) => const CategoriasPage(),
  AppModule.productos: (context) => const ProductosScreen(),
  // AppModule.usuarios: (context) => const UsuariosPage(),
  // AppModule.roles: (context) => const RolesPage(),
  // AppModule.inventario: (context) => const InventarioPage(),
  // AppModule.pedidos: (context) => const PedidosPage(),
  // AppModule.reportes: (context) => const ReportesPage(),
  // AppModule.configuracion: (context) => const ConfiguracionPage(),
};

/// Se muestra automáticamente para cualquier módulo que aún no tenga
/// página registrada, para que la app nunca truene mientras el equipo
/// va terminando cada sección.
Widget placeholderPage(AppModule module) => Center(
  child: Text(
    '${module.label}\n(en construcción)',
    textAlign: TextAlign.center,
  ),
);
