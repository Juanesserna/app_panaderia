import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/date_format.dart';
import '../../data/datasources/produccion_mock_datasource.dart';
import '../../data/repositories/produccion_repository_impl.dart';
import '../../domain/entities/orden_produccion.dart';
import '../../domain/repositories/produccion_repository.dart';

/// Repositorio del módulo de Producción. Hoy resuelve a la
/// implementación en memoria; el día que exista backend, cambiar esta
/// línea es lo único necesario (nada en la UI depende de la
/// implementación concreta).
final produccionRepositoryProvider = Provider<ProduccionRepository>((ref) {
  return ProduccionRepositoryImpl(datasource: const ProduccionMockDatasource());
});

/// Catálogo de productos disponibles para armar una orden (estático por
/// ahora).
final catalogoProductosProduccionProvider = Provider<List<String>>((ref) {
  return ref.watch(produccionRepositoryProvider).obtenerCatalogoProductos();
});

/// Receta de insumos por producto.
final recetasProductosProvider = Provider<Map<String, List<Insumo>>>((ref) {
  return ref.watch(produccionRepositoryProvider).obtenerRecetas();
});

/// Usuario autenticado (estático hasta que exista un authProvider real).
final usuarioActualProduccionProvider = Provider<GeneradoPor>((ref) {
  return ref.watch(produccionRepositoryProvider).obtenerUsuarioActual();
});

/// Lista de órdenes + acciones para registrar, editar, cambiar de estado
/// o eliminar una orden.
class OrdenesProduccionNotifier extends Notifier<List<OrdenProduccion>> {
  @override
  List<OrdenProduccion> build() =>
      ref.watch(produccionRepositoryProvider).obtenerOrdenes();

  /// Siguiente ID correlativo (OP-009, OP-010, ...).
  String siguienteId() {
    final maxNum = state.fold<int>(0, (max, o) {
      final n = int.tryParse(o.id.replaceAll('OP-', '')) ?? 0;
      return n > max ? n : max;
    });
    return 'OP-${(maxNum + 1).toString().padLeft(3, '0')}';
  }

  void registrarOrden(OrdenProduccion orden) {
    ref.read(produccionRepositoryProvider).registrarOrden(orden);
    state = [orden, ...state];
  }

  /// Aplica el nuevo estado a una orden (bloqueada si ya está en un
  /// estado final) y, si pasa a "completado" y aún no tenía fecha de
  /// fabricación, la fija con la fecha/hora actual.
  OrdenProduccion _aplicarEstado(OrdenProduccion orden, EstadoOrden estado) {
    final nuevaFecha =
        estado == EstadoOrden.completado && orden.fechaFabricacion.isEmpty
            ? fechaHoraActualFormateada()
            : orden.fechaFabricacion;
    return orden.copyWith(estado: estado, fechaFabricacion: nuevaFecha);
  }

  void actualizarEstado(String id, EstadoOrden estado) {
    OrdenProduccion? actualizada;
    state = [
      for (final o in state)
        if (o.id == id && !o.esEstadoFinal)
          actualizada = _aplicarEstado(o, estado)
        else
          o,
    ];
    if (actualizada != null) {
      ref.read(produccionRepositoryProvider).actualizarOrden(actualizada);
    }
  }

  /// Usado por el formulario de edición: reemplaza los productos de la
  /// orden y aplica el estado seleccionado.
  void actualizarItemsYEstado(
    String id,
    List<ItemOrden> items,
    EstadoOrden estado,
  ) {
    OrdenProduccion? actualizada;
    state = [
      for (final o in state)
        if (o.id == id && !o.esEstadoFinal)
          actualizada = _aplicarEstado(o, estado).copyWith(items: items)
        else
          o,
    ];
    if (actualizada != null) {
      ref.read(produccionRepositoryProvider).actualizarOrden(actualizada);
    }
  }

  void eliminarOrden(String id) {
    ref.read(produccionRepositoryProvider).eliminarOrden(id);
    state = state.where((o) => o.id != id).toList();
  }
}

final ordenesProduccionProvider =
    NotifierProvider<OrdenesProduccionNotifier, List<OrdenProduccion>>(
  OrdenesProduccionNotifier.new,
);
