import '../entities/rol.dart';

/// Contrato del módulo de Roles. Hoy lo implementa un repositorio en
/// memoria (ver `data/repositories/rol_repository_impl.dart`). El día
/// que exista backend, se crea otra implementación de esta misma
/// interfaz y no hay que tocar ni los providers de Riverpod ni la UI.
abstract class RolRepository {
  List<Rol> obtenerRoles();
  void crearRol(Rol rol);
  void actualizarRol(Rol rol);
  void eliminarRol(String id);
}