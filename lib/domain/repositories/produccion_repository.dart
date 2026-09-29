import '../entities/orden_produccion.dart';

/// Contrato del módulo de Producción. Hoy lo implementa un repositorio en
/// memoria (ver `data/repositories/produccion_repository_impl.dart`). El
/// día que exista backend, se crea otra implementación de esta misma
/// interfaz (ej. `ProduccionRepositoryApi`) y no hay que tocar ni los
/// providers de Riverpod ni la UI.
abstract class ProduccionRepository {
  List<OrdenProduccion> obtenerOrdenes();
  List<String> obtenerCatalogoProductos();

  /// Receta de insumos por producto: cuánto de cada insumo se necesita
  /// por unidad producida.
  Map<String, List<Insumo>> obtenerRecetas();

  GeneradoPor obtenerUsuarioActual();

  void registrarOrden(OrdenProduccion orden);

  /// Reemplaza la orden con el mismo `id` por [orden] (ya con los
  /// cambios aplicados). Las reglas de negocio (bloqueo por estado
  /// final, fecha de fabricación automática, etc.) se resuelven antes,
  /// en el Notifier de Riverpod.
  void actualizarOrden(OrdenProduccion orden);

  void eliminarOrden(String id);
}
