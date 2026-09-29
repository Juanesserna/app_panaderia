import '../entities/insumo_inventario.dart';

/// Contrato del módulo de Insumos. Hoy lo implementa un repositorio en
/// memoria (ver `data/repositories/insumos_repository_impl.dart`). El día
/// que exista backend, se crea otra implementación de esta misma interfaz
/// (ej. `InsumosRepositoryApi`) y no hay que tocar ni los providers de
/// Riverpod ni la UI.
abstract class InsumosRepository {
  List<InsumoInventario> obtenerInsumos();

  void registrarInsumo(InsumoInventario insumo);

  /// Reemplaza el insumo con el mismo `id` por [insumo] (ya con los
  /// cambios aplicados).
  void actualizarInsumo(InsumoInventario insumo);

  void eliminarInsumo(String id);
}
