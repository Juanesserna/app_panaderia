import 'package:flutter/material.dart';
import 'package:panaderia/presentation/screens/usuarios/usuarios_screen.dart';
import '../../core/constants/app_modules.dart';
import '../screens/productos/productos_screen.dart';
//import '../screens/cisas/cisas_screen.dart';
import 'pantalla_dashboard.dart';
import 'pantalla_compras.dart';
import 'ventas_page.dart';
import 'produccion_page.dart';
import 'insumos_page.dart';
import 'proveedores_page.dart';
import 'categorias_page.dart';
import 'roles_page.dart';
// ...cada compañero agrega aquí el import de su página

/// ÚNICO lugar del proyecto donde se conecta cada [AppModule] con su
/// pantalla real. Flujo para el equipo cuando terminan un módulo:
///   1. Crear la página en presentation/pages/<modulo_page.dart
///      (un widget simple, sin Scaffold/Header/BottomNav propios).
///   2. Importarla arriba.
///   3. Agregar/reemplazar su entrada en el mapa de abajo.
/// AppShell se encarga solo de mostrarla: no hay que tocar nada más
/// (ni Header, ni BottomNav, ni navegación).
final Map<AppModule, WidgetBuilder> moduleRegistry = {
  AppModule.dashboard: (context) => const PantallaDashboard(),
  AppModule.ventas: (context) => const VentasPage(),
  AppModule.produccion: (context) => const ProduccionPage(),
  AppModule.insumos: (context) => const InsumosPage(),
  AppModule.compras: (context) => const PantallaCompras(),
  AppModule.proveedores: (context) => const ProveedoresPage(),
  AppModule.categorias: (context) => const CategoriasPage(),
  // AppModule.cisas: (context) => CisasScreen(),
  AppModule.productos: (context) => const ProductosScreen(),
  AppModule.usuarios: (context) => const UsuariosScreen(),
  AppModule.roles: (context) => const RolesPage(),
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
