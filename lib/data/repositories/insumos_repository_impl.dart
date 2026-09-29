import '../../domain/entities/insumo_inventario.dart';
import '../../domain/repositories/insumos_repository.dart';
import '../datasources/insumos_mock_datasource.dart';

/// Implementación en memoria de [InsumosRepository]. Simula persistencia
/// durante la sesión de la app (vive en una lista mutable); no sobrevive
/// a un reinicio. Cuando haya backend, se reemplaza por una
/// implementación que llame a la API/DB sin tocar providers ni UI.
class InsumosRepositoryImpl implements InsumosRepository {
  final InsumosMockDatasource _datasource;
  late final List<InsumoInventario> _insumos;

  InsumosRepositoryImpl({
    InsumosMockDatasource datasource = const InsumosMockDatasource(),
  }) : _datasource = datasource {
    _insumos = List.of(_datasource.insumosIniciales());
  }

  @override
  List<InsumoInventario> obtenerInsumos() => List.unmodifiable(_insumos);

  @override
  void registrarInsumo(InsumoInventario insumo) {
    _insumos.insert(0, insumo);
  }

  @override
  void actualizarInsumo(InsumoInventario insumo) {
    final i = _insumos.indexWhere((e) => e.id == insumo.id);
    if (i != -1) _insumos[i] = insumo;
  }

  @override
  void eliminarInsumo(String id) {
    _insumos.removeWhere((e) => e.id == id);
  }
}
