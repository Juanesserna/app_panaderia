import 'app_modules.dart';

/// Roles de acceso de la app (distinto del módulo "Roles" de
/// administración, que gestiona permisos configurables desde la UI).
/// Este enum es solo para controlar qué ve cada usuario autenticado.
///
/// El acceso es acumulativo por diseño: Vendedor ve todo lo de Panadero
/// + lo suyo, Gerente ve todo lo de Vendedor + lo suyo.
enum AppRole { panadero, vendedor, gerente }

extension AppRoleAccess on AppRole {
  String get label {
    switch (this) {
      case AppRole.panadero:
        return 'Panadero';
      case AppRole.vendedor:
        return 'Vendedor';
      case AppRole.gerente:
        return 'Gerente';
    }
  }

  /// Módulos a los que este rol tiene acceso. Cada nivel incluye los
  /// módulos del rol anterior, tal como se definió: Panadero → Vendedor
  /// (+ Dashboard, Ventas) → Gerente (+ Categoría, Roles, Usuarios,
  /// Proveedores, Compras, Insumos, Producto).
  Set<AppModule> get modulosPermitidos {
    switch (this) {
      case AppRole.panadero:
        return const {AppModule.produccion};
      case AppRole.vendedor:
        return const {
          AppModule.produccion,
          AppModule.dashboard,
          AppModule.ventas,
        };
      case AppRole.gerente:
        return const {
          AppModule.produccion,
          AppModule.dashboard,
          AppModule.ventas,
          AppModule.categorias,
          AppModule.roles,
          AppModule.usuarios,
          AppModule.proveedores,
          AppModule.compras,
          AppModule.insumos,
          AppModule.productos,
        };
    }
  }

  /// Módulo al que se entra justo después de iniciar sesión.
  AppModule get moduloInicial {
    switch (this) {
      case AppRole.panadero:
        return AppModule.produccion;
      case AppRole.vendedor:
      case AppRole.gerente:
        return AppModule.dashboard;
    }
  }
}