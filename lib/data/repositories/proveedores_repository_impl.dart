import '../../domain/entities/proveedor.dart';
import '../../domain/repositories/proveedores_repository.dart';
import '../datasources/proveedores_mock_datasource.dart';

/// Implementación en memoria de [ProveedoresRepository]. Simula
/// persistencia durante la sesión de la app (vive en una lista mutable);
/// no sobrevive a un reinicio. Cuando haya backend, se reemplaza por una
/// implementación que llame a la API/DB sin tocar providers ni UI.
class ProveedoresRepositoryImpl implements ProveedoresRepository {
  final ProveedoresMockDatasource _datasource;
  late final List<Proveedor> _proveedores;

  ProveedoresRepositoryImpl({
    ProveedoresMockDatasource datasource = const ProveedoresMockDatasource(),
  }) : _datasource = datasource {
    _proveedores = List.of(_datasource.proveedoresIniciales());
  }

  @override
  List<Proveedor> obtenerProveedores() => List.unmodifiable(_proveedores);

  @override
  void registrarProveedor(Proveedor proveedor) {
    _proveedores.insert(0, proveedor);
  }

  @override
  void actualizarProveedor(Proveedor proveedor) {
    final i = _proveedores.indexWhere((e) => e.id == proveedor.id);
    if (i != -1) _proveedores[i] = proveedor;
  }

  @override
  void eliminarProveedor(String id) {
    _proveedores.removeWhere((e) => e.id == id);
  }
}
