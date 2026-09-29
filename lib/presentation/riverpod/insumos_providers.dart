import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/insumos_mock_datasource.dart';
import '../../data/repositories/insumos_repository_impl.dart';
import '../../domain/entities/insumo_inventario.dart';
import '../../domain/repositories/insumos_repository.dart';

/// Repositorio del módulo de Insumos. Hoy resuelve a la implementación en
/// memoria; el día que exista backend, cambiar esta línea es lo único
/// necesario (nada en la UI depende de la implementación concreta).
final insumosRepositoryProvider = Provider<InsumosRepository>((ref) {
  return InsumosRepositoryImpl(datasource: const InsumosMockDatasource());
});

/// Lista de insumos + acciones para registrar, editar o eliminar uno.
class InsumosNotifier extends Notifier<List<InsumoInventario>> {
  @override
  
  List<InsumoInventario> build() =>
      ref.watch(insumosRepositoryProvider).obtenerInsumos();

  /// Siguiente ID correlativo (INS-007, INS-008, ...).
  String siguienteId() {
    final maxNum = state.fold<int>(0, (max, i) {
      final n = int.tryParse(i.id.replaceAll('INS-', '')) ?? 0;
      return n > max ? n : max;
    });
    return 'INS-${(maxNum + 1).toString().padLeft(3, '0')}';
  }

  void registrarInsumo(InsumoInventario insumo) {
    ref.read(insumosRepositoryProvider).registrarInsumo(insumo);
    state = [insumo, ...state];
  }

  void actualizarInsumo(InsumoInventario insumo) {
    ref.read(insumosRepositoryProvider).actualizarInsumo(insumo);
    state = [
      for (final i in state)
        if (i.id == insumo.id) insumo else i,
    ];
  }

  void cambiarEstado(String id, bool activo) {
    InsumoInventario? actualizado;
    state = [
      for (final i in state)
        if (i.id == id) actualizado = i.copyWith(activo: activo) else i,
    ];
    if (actualizado != null) {
      ref.read(insumosRepositoryProvider).actualizarInsumo(actualizado!);
    }
  }

  void eliminarInsumo(String id) {
    ref.read(insumosRepositoryProvider).eliminarInsumo(id);
    state = state.where((i) => i.id != id).toList();
  }
}

final insumosProvider =
    NotifierProvider<InsumosNotifier, List<InsumoInventario>>(
      InsumosNotifier.new,
    );

/// Estado del bottom sheet "Filtrar insumos" + del texto de búsqueda del
/// header de la página. Se mantiene separado del `InsumosNotifier` porque
/// filtrar no modifica los datos, solo lo que se muestra.
@immutable
class FiltrosInsumos {
  final String busqueda;
  final CategoriaInsumo? categoria;
  final bool? activo;
  final NivelStock? nivelStock;

  const FiltrosInsumos({
    this.busqueda = '',
    this.categoria,
    this.activo,
    this.nivelStock,
  });

  bool get sinFiltrosAplicados =>
      categoria == null && activo == null && nivelStock == null;

  FiltrosInsumos copyWith({
    String? busqueda,
    CategoriaInsumo? categoria,
    bool? activo,
    NivelStock? nivelStock,
    bool limpiarCategoria = false,
    bool limpiarActivo = false,
    bool limpiarNivelStock = false,
  }) {
    return FiltrosInsumos(
      busqueda: busqueda ?? this.busqueda,
      categoria: limpiarCategoria ? null : (categoria ?? this.categoria),
      activo: limpiarActivo ? null : (activo ?? this.activo),
      nivelStock: limpiarNivelStock ? null : (nivelStock ?? this.nivelStock),
    );
  }
}

class FiltrosInsumosNotifier extends Notifier<FiltrosInsumos> {
  @override
  FiltrosInsumos build() => const FiltrosInsumos();

  void setBusqueda(String texto) => state = state.copyWith(busqueda: texto);

  void setCategoria(CategoriaInsumo? categoria) => state = state.copyWith(
    categoria: categoria,
    limpiarCategoria: categoria == null,
  );

  void setActivo(bool? activo) =>
      state = state.copyWith(activo: activo, limpiarActivo: activo == null);

  void setNivelStock(NivelStock? nivel) => state = state.copyWith(
    nivelStock: nivel,
    limpiarNivelStock: nivel == null,
  );

  void limpiar() => state = FiltrosInsumos(busqueda: state.busqueda);
}

final filtrosInsumosProvider =
    NotifierProvider<FiltrosInsumosNotifier, FiltrosInsumos>(
      FiltrosInsumosNotifier.new,
    );

/// Lista de insumos ya filtrada por búsqueda + filtros activos. Es lo que
/// la página realmente pinta en pantalla.
final insumosFiltradosProvider = Provider<List<InsumoInventario>>((ref) {
  final insumos = ref.watch(insumosProvider);
  final filtros = ref.watch(filtrosInsumosProvider);

  return insumos.where((i) {
    if (filtros.busqueda.trim().isNotEmpty &&
        !i.nombre.toLowerCase().contains(
          filtros.busqueda.trim().toLowerCase(),
        )) {
      return false;
    }
    if (filtros.categoria != null && i.categoria != filtros.categoria) {
      return false;
    }
    if (filtros.activo != null && i.activo != filtros.activo) {
      return false;
    }
    if (filtros.nivelStock != null && i.nivelStock != filtros.nivelStock) {
      return false;
    }
    return true;
  }).toList();
});
