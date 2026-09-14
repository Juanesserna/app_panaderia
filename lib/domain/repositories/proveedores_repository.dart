import '../entities/proveedor.dart';

/// Contrato del módulo de Proveedores. Hoy lo implementa un repositorio en
/// memoria (ver `data/repositories/proveedores_repository_impl.dart`). El
/// día que exista backend, se crea otra implementación de esta misma
/// interfaz (ej. `ProveedoresRepositoryApi`) y no hay que tocar ni los
/// providers de Riverpod ni la UI.
abstract class ProveedoresRepository {
  List<Proveedor> obtenerProveedores();

  void registrarProveedor(Proveedor proveedor);

  /// Reemplaza el proveedor con el mismo `id` por [proveedor] (ya con los
  /// cambios aplicados).
  void actualizarProveedor(Proveedor proveedor);

  void eliminarProveedor(String id);
}