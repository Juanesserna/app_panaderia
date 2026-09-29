import '../../domain/entities/venta.dart';
import '../../domain/repositories/ventas_repository.dart';
import '../datasources/ventas_mock_datasource.dart';

/// Implementación en memoria de [VentasRepository]. Simula persistencia
/// durante la sesión de la app (vive en listas mutables); no sobrevive a
/// un reinicio. Cuando haya backend, se reemplaza por una implementación
/// que llame a la API/DB sin tocar providers ni UI.
class VentasRepositoryImpl implements VentasRepository {
  final VentasMockDatasource _datasource;
  late final List<Venta> _ventas;
  final List<Abono> _abonos = [];

  VentasRepositoryImpl({
    VentasMockDatasource datasource = const VentasMockDatasource(),
  }) : _datasource = datasource {
    _ventas = List.of(_datasource.ventasIniciales());
  }

  @override
  List<Venta> obtenerVentas() => List.unmodifiable(_ventas);

  @override
  List<Cliente> obtenerClientes() => _datasource.catalogoClientes();

  @override
  List<ProductoCatalogo> obtenerCatalogoProductos() =>
      _datasource.catalogoPanaderia();

  @override
  String obtenerUsuarioActual() => _datasource.usuarioAutenticado();

  @override
  void registrarVenta(Venta venta) {
    _ventas.insert(0, venta);
  }

  @override
  void actualizarEstado(String idVenta, EstadoVenta estado) {
    final i = _ventas.indexWhere((v) => v.id == idVenta);
    if (i != -1) _ventas[i] = _ventas[i].copyWith(estado: estado);
  }

  @override
  List<Abono> obtenerAbonos(String idVenta) =>
      _abonos.where((a) => a.idVenta == idVenta).toList();

  @override
  void registrarAbono(Abono abono) {
    _abonos.insert(0, abono);
  }

  @override
  void eliminarAbono(String idAbono) {
    _abonos.removeWhere((a) => a.id == idAbono);
  }
}
