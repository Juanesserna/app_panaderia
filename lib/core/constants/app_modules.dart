import 'package:flutter/material.dart';

/// Cada módulo/pantalla principal de la app.
/// Este enum es la ÚNICA fuente de verdad para navegar entre secciones:
/// nadie debe usar Strings sueltos ("ventas", "Ventas", etc.) para
/// identificar una pantalla.
enum AppModule {
  dashboard,
  ventas,
  produccion,
  insumos,
  compras,
  proveedores,
  categorias,
  productos,
  usuarios,
  roles,
  inventario,
  pedidos,
  reportes,
  configuracion,
}

extension AppModuleLabel on AppModule {
  /// Texto que se muestra bajo el logo en el Header (equivale a
  /// MODULE_LABELS del diseño web).
  String get label {
    switch (this) {
      case AppModule.dashboard:
        return 'Panel principal';
      case AppModule.ventas:
        return 'Ventas';
      case AppModule.produccion:
        return 'Producción';
      case AppModule.insumos:
        return 'Insumos';
      case AppModule.compras:
        return 'Compras';
      case AppModule.proveedores:
        return 'Proveedores';
      case AppModule.categorias:
        return 'Categorías';
      case AppModule.productos:
        return 'Productos';
      case AppModule.usuarios:
        return 'Usuarios';
      case AppModule.roles:
        return 'Roles';
      case AppModule.inventario:
        return 'Inventario';
      case AppModule.pedidos:
        return 'Pedidos';
      case AppModule.reportes:
        return 'Reportes';
      case AppModule.configuracion:
        return 'Configuración';
    }
  }
}

/// Un ítem navegable (bottom nav o menú "Más").
class NavItem {
  final AppModule module;
  final String label;
  final IconData icon;
  const NavItem(this.module, this.label, this.icon);
}

/// Los 4 tabs fijos del bottom nav. El 5to botón ("Más") no es un módulo:
/// abre el bottom sheet con el resto de opciones (ver kDrawerItems).
const List<NavItem> kBottomTabs = [
  NavItem(AppModule.dashboard, 'Inicio', Icons.home_outlined),
  NavItem(AppModule.ventas, 'Ventas', Icons.shopping_bag_outlined),
  NavItem(AppModule.produccion, 'Producción', Icons.wb_sunny_outlined),
  NavItem(AppModule.insumos, 'Insumos', Icons.inventory_2_outlined),
];

/// Todo lo demás, visible únicamente dentro del menú "Más".
const List<NavItem> kDrawerItems = [
  NavItem(AppModule.compras, 'Compras', Icons.shopping_cart_outlined),
  NavItem(AppModule.proveedores, 'Proveedores', Icons.local_shipping_outlined),
  NavItem(AppModule.usuarios, 'Usuarios', Icons.people_outline),
  NavItem(AppModule.productos, 'Productos', Icons.local_mall_outlined),
  NavItem(AppModule.categorias, 'Categorías', Icons.sell_outlined),
  NavItem(AppModule.inventario, 'Inventario', Icons.inventory_outlined),
  NavItem(AppModule.pedidos, 'Pedidos', Icons.receipt_long_outlined),
  NavItem(AppModule.reportes, 'Reportes', Icons.bar_chart_outlined),
  NavItem(AppModule.roles, 'Roles', Icons.grid_view_outlined),
  NavItem(AppModule.configuracion, 'Configuración', Icons.settings_outlined),
];

/// Todos los módulos navegables, en el mismo orden que en el diseño
/// (kBottomTabs + kDrawerItems).
List<NavItem> get kAllNavItems => [...kBottomTabs, ...kDrawerItems];