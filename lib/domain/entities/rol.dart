import 'package:flutter/foundation.dart';
import '../../core/constants/app_modules.dart';

/// Estado de un rol: activo/inactivo (equivale al switch "ACTIVO" de la
/// tabla web).
enum EstadoRol { activo, inactivo }

extension EstadoRolLabel on EstadoRol {
  String get label => this == EstadoRol.activo ? 'Activo' : 'Inactivo';
}

/// Los 8 módulos que un rol puede tener marcados por defecto, en el
/// mismo orden (por columnas) que el formulario web: Dashboard/Usuarios,
/// Productos/Insumos, Proveedores/Compras, Producción/Ventas.
const List<AppModule> kModulosAsignablesRol = [
  AppModule.dashboard,
  AppModule.usuarios,
  AppModule.productos,
  AppModule.insumos,
  AppModule.proveedores,
  AppModule.compras,
  AppModule.produccion,
  AppModule.ventas,
];

/// Un rol del sistema (Gerente, Panadero, Cliente, Vendedor, ...) y los
/// módulos que ven por defecto los usuarios con ese rol.
@immutable
class Rol {
  final String id;
  final String nombre;
  final EstadoRol estado;
  final Set<AppModule> modulos;

  const Rol({
    required this.id,
    required this.nombre,
    required this.estado,
    required this.modulos,
  });

  int get totalPermisos => modulos.length;

  Rol copyWith({
    String? nombre,
    EstadoRol? estado,
    Set<AppModule>? modulos,
  }) {
    return Rol(
      id: id,
      nombre: nombre ?? this.nombre,
      estado: estado ?? this.estado,
      modulos: modulos ?? this.modulos,
    );
  }
}