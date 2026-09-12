import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/ventas_mock_datasource.dart';
import '../../data/repositories/ventas_repository_impl.dart';
import '../../domain/entities/venta.dart';
import '../../domain/repositories/ventas_repository.dart';

/// Repositorio del módulo de Ventas. Hoy resuelve a la implementación en
/// memoria; el día que exista backend, cambiar esta línea es lo único
/// necesario (nada en la UI depende de la implementación concreta).
final ventasRepositoryProvider = Provider<VentasRepository>((ref) {
  return VentasRepositoryImpl(datasource: const VentasMockDatasource());
});

/// Catálogo de clientes (estático por ahora).
final clientesProvider = Provider<List<Cliente>>((ref) {
  return ref.watch(ventasRepositoryProvider).obtenerClientes();
});

/// Catálogo de productos de panadería (estático por ahora).
final catalogoProductosProvider = Provider<List<ProductoCatalogo>>((ref) {
  return ref.watch(ventasRepositoryProvider).obtenerCatalogoProductos();
});

/// Nombre del usuario autenticado (estático hasta que exista authProvider).
final usuarioActualProvider = Provider<String>((ref) {
  return ref.watch(ventasRepositoryProvider).obtenerUsuarioActual();
});

/// Lista de ventas + acciones para registrar una venta nueva o cambiar
/// el estado de una existente.
class VentasNotifier extends Notifier<List<Venta>> {
  @override
  List<Venta> build() => ref.watch(ventasRepositoryProvider).obtenerVentas();

  /// Siguiente ID correlativo (#2852, #2853, ...), igual que en el diseño web.
  String siguienteId() {
    final maxNum = state.fold<int>(0, (max, v) {
      final n = int.tryParse(v.id.replaceAll('#', '')) ?? 0;
      return n > max ? n : max;
    });
    return '#${maxNum + 1}';
  }

  void registrarVenta(Venta venta) {
    ref.read(ventasRepositoryProvider).registrarVenta(venta);
    state = [venta, ...state];
  }

  void actualizarEstado(String idVenta, EstadoVenta estado) {
    ref.read(ventasRepositoryProvider).actualizarEstado(idVenta, estado);
    state = [
      for (final v in state)
        if (v.id == idVenta) v.copyWith(estado: estado) else v,
    ];
  }
}

final ventasProvider =
    NotifierProvider<VentasNotifier, List<Venta>>(VentasNotifier.new);

/// Todos los abonos registrados (de todas las ventas); la UI filtra por
/// `idVenta` según qué venta esté abierta en el detalle.
class AbonosNotifier extends Notifier<List<Abono>> {
  @override
  List<Abono> build() => [];

  String siguienteId() {
    final maxNum = state.fold<int>(0, (max, a) {
      final n = int.tryParse(a.id.replaceAll('AB-', '')) ?? 0;
      return n > max ? n : max;
    });
    return 'AB-${(maxNum + 1).toString().padLeft(3, '0')}';
  }

  void registrar(Abono abono) {
    state = [abono, ...state];
  }

  void eliminar(String idAbono) {
    state = state.where((a) => a.id != idAbono).toList();
  }

  List<Abono> deVenta(String idVenta) =>
      state.where((a) => a.idVenta == idVenta).toList();
}

final abonosProvider =
    NotifierProvider<AbonosNotifier, List<Abono>>(AbonosNotifier.new);
