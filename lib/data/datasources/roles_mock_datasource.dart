import '../../core/constants/app_modules.dart';
import '../../domain/entities/rol.dart';

/// Fuente de datos estática para el módulo de Roles (solo diseño y
/// funcional, sin backend todavía). Cuando exista API/DB, este archivo
/// se reemplaza por un datasource remoto que devuelva la misma forma de
/// datos; nada más del módulo debería cambiar.
class RolesMockDatasource {
  const RolesMockDatasource();

  List<Rol> rolesIniciales() => const [
        Rol(
          id: '01R',
          nombre: 'Gerente',
          estado: EstadoRol.inactivo,
          modulos: {
            AppModule.dashboard,
            AppModule.productos,
            AppModule.insumos,
            AppModule.proveedores,
            AppModule.compras,
            AppModule.produccion,
            AppModule.ventas,
            // Usuarios queda fuera a propósito (7 de 8 módulos).
          },
        ),
        Rol(
          id: '02R',
          nombre: 'Panadero',
          estado: EstadoRol.activo,
          modulos: {
            AppModule.dashboard,
            AppModule.produccion,
            AppModule.insumos,
            AppModule.compras,
          },
        ),
        Rol(
          id: '03R',
          nombre: 'Cliente',
          estado: EstadoRol.activo,
          modulos: {AppModule.dashboard, AppModule.ventas},
        ),
        Rol(
          id: '04R',
          nombre: 'Vendedor',
          estado: EstadoRol.activo,
          modulos: {AppModule.dashboard, AppModule.ventas, AppModule.productos},
        ),
      ];
}