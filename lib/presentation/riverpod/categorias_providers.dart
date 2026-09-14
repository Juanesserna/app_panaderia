import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/categorias_mock_datasource.dart';
import '../../data/repositories/categorias_repository_impl.dart';
import '../../domain/entities/categoria.dart';
import '../../domain/repositories/categorias_repository.dart';

/// Repositorio del módulo de Categorías. Hoy resuelve a la
/// implementación en memoria; el día que exista backend, cambiar esta
/// línea es lo único necesario (nada en la UI depende de la
/// implementación concreta).
final categoriasRepositoryProvider = Provider<CategoriasRepository>((ref) {
  return CategoriasRepositoryImpl(datasource: const CategoriasMockDatasource());
});

/// Lista de categorías + acciones para registrar, editar o eliminar una.
class CategoriasNotifier extends Notifier<List<Categoria>> {
  @override
  List<Categoria> build() =>
      ref.watch(categoriasRepositoryProvider).obtenerCategorias();

  /// Siguiente ID correlativo (CAT-006, CAT-007, ...).
  String siguienteId() {
    final maxNum = state.fold<int>(0, (max, c) {
      final n = int.tryParse(c.id.replaceAll('CAT-', '')) ?? 0;
      return n > max ? n : max;
    });
    return 'CAT-${(maxNum + 1).toString().padLeft(3, '0')}';
  }

  void registrarCategoria(Categoria categoria) {
    ref.read(categoriasRepositoryProvider).registrarCategoria(categoria);
    state = [categoria, ...state];
  }

  void actualizarCategoria(Categoria categoria) {
    ref.read(categoriasRepositoryProvider).actualizarCategoria(categoria);
    state = [
      for (final c in state)
        if (c.id == categoria.id) categoria else c,
    ];
  }

  void cambiarEstado(String id, bool activa) {
    Categoria? actualizada;
    state = [
      for (final c in state)
        if (c.id == id) actualizada = c.copyWith(activa: activa) else c,
    ];
    if (actualizada != null) {
      ref.read(categoriasRepositoryProvider).actualizarCategoria(actualizada!);
    }
  }

  void eliminarCategoria(String id) {
    ref.read(categoriasRepositoryProvider).eliminarCategoria(id);
    state = state.where((c) => c.id != id).toList();
  }
}

final categoriasProvider =
    NotifierProvider<CategoriasNotifier, List<Categoria>>(
      CategoriasNotifier.new,
    );

/// Estadísticas derivadas para las tarjetas KPI del encabezado
/// (Total / Activas / Inactivas / Productos).
@immutable
class CategoriasStats {
  final int total;
  final int activas;
  final int inactivas;
  final int totalProductos;

  const CategoriasStats({
    required this.total,
    required this.activas,
    required this.inactivas,
    required this.totalProductos,
  });
}

final categoriasStatsProvider = Provider<CategoriasStats>((ref) {
  final categorias = ref.watch(categoriasProvider);
  final activas = categorias.where((c) => c.activa).length;
  return CategoriasStats(
    total: categorias.length,
    activas: activas,
    inactivas: categorias.length - activas,
    totalProductos: categorias.fold<int>(
      0,
      (sum, c) => sum + c.cantidadProductos,
    ),
  );
});

/// Solo las categorías activas, para el gráfico de "Distribución"
/// (las inactivas no suman al catálogo visible).
final categoriasActivasProvider = Provider<List<Categoria>>((ref) {
  return ref.watch(categoriasProvider).where((c) => c.activa).toList();
});

/// Estado del bottom sheet "Filtrar categorías" + del texto de búsqueda
/// del header de la página. Se mantiene separado de [CategoriasNotifier]
/// porque filtrar no modifica los datos, solo lo que se muestra (mismo
/// patrón que `FiltrosInsumos` en insumos_providers.dart).
@immutable
class FiltrosCategorias {
  final String busqueda;
  final bool? activa;

  const FiltrosCategorias({this.busqueda = '', this.activa});

  bool get sinFiltrosAplicados => activa == null;

  FiltrosCategorias copyWith({
    String? busqueda,
    bool? activa,
    bool limpiarActiva = false,
  }) {
    return FiltrosCategorias(
      busqueda: busqueda ?? this.busqueda,
      activa: limpiarActiva ? null : (activa ?? this.activa),
    );
  }
}

class FiltrosCategoriasNotifier extends Notifier<FiltrosCategorias> {
  @override
  FiltrosCategorias build() => const FiltrosCategorias();

  void setBusqueda(String texto) => state = state.copyWith(busqueda: texto);

  void setActiva(bool? activa) =>
      state = state.copyWith(activa: activa, limpiarActiva: activa == null);

  /// Limpia los filtros del bottom sheet mantendiendo lo que haya escrito
  /// en el campo de búsqueda del header.
  void limpiar() => state = FiltrosCategorias(busqueda: state.busqueda);
}

final filtrosCategoriasProvider =
    NotifierProvider<FiltrosCategoriasNotifier, FiltrosCategorias>(
      FiltrosCategoriasNotifier.new,
    );

/// Lista de categorías ya filtrada por búsqueda (nombre/descripción) +
/// estado. Es lo que la página realmente pinta en pantalla; los KPI del
/// encabezado siguen usando [categoriasProvider] sin filtrar.
final categoriasFiltradasProvider = Provider<List<Categoria>>((ref) {
  final categorias = ref.watch(categoriasProvider);
  final filtros = ref.watch(filtrosCategoriasProvider);

  return categorias.where((c) {
    if (filtros.busqueda.trim().isNotEmpty) {
      final q = filtros.busqueda.trim().toLowerCase();
      final coincideNombre = c.nombre.toLowerCase().contains(q);
      final coincideDescripcion = c.descripcion.toLowerCase().contains(q);
      if (!coincideNombre && !coincideDescripcion) return false;
    }
    if (filtros.activa != null && c.activa != filtros.activa) {
      return false;
    }
    return true;
  }).toList();
});
