import '../../domain/entities/orden_produccion.dart';
import '../../domain/repositories/produccion_repository.dart';
import '../datasources/produccion_mock_datasource.dart';

/// Implementación en memoria de [ProduccionRepository]. Simula
/// persistencia durante la sesión de la app (vive en una lista mutable);
/// no sobrevive a un reinicio. Cuando haya backend, se reemplaza por una
/// implementación que llame a la API/DB sin tocar providers ni UI.
class ProduccionRepositoryImpl implements ProduccionRepository {
  final ProduccionMockDatasource _datasource;
  late final List<OrdenProduccion> _ordenes;

  ProduccionRepositoryImpl({
    ProduccionMockDatasource datasource = const ProduccionMockDatasource(),
  }) : _datasource = datasource {
    _ordenes = List.of(_datasource.ordenesIniciales());
  }

  @override
  List<OrdenProduccion> obtenerOrdenes() => List.unmodifiable(_ordenes);

  @override
  List<String> obtenerCatalogoProductos() => _datasource.catalogoProductos();

  @override
  Map<String, List<Insumo>> obtenerRecetas() => _datasource.recetasProductos();

  @override
  GeneradoPor obtenerUsuarioActual() => _datasource.usuarioAutenticado();

  @override
  void registrarOrden(OrdenProduccion orden) {
    _ordenes.insert(0, orden);
  }

  @override
  void actualizarOrden(OrdenProduccion orden) {
    final i = _ordenes.indexWhere((o) => o.id == orden.id);
    if (i != -1) _ordenes[i] = orden;
  }

  @override
  void eliminarOrden(String id) {
    _ordenes.removeWhere((o) => o.id == id);
  }
}
