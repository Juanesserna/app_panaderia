import '../entities/venta.dart';

/// Contrato del módulo de Ventas. Hoy lo implementa un repositorio en
/// memoria (ver `data/repositories/ventas_repository_impl.dart`). El día
/// que exista backend, se crea otra implementación de esta misma
/// interfaz (ej. `VentasRepositoryApi`) y no hay que tocar ni los
/// providers de Riverpod ni la UI.
abstract class VentasRepository {
  List<Venta> obtenerVentas();
  List<Cliente> obtenerClientes();
  List<ProductoCatalogo> obtenerCatalogoProductos();
  String obtenerUsuarioActual();

  void registrarVenta(Venta venta);
  void actualizarEstado(String idVenta, EstadoVenta estado);

  List<Abono> obtenerAbonos(String idVenta);
  void registrarAbono(Abono abono);
  void eliminarAbono(String idAbono);
}
