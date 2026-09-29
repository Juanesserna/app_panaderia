import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/proveedores_mock_datasource.dart';
import '../../data/repositories/proveedores_repository_impl.dart';
import '../../domain/entities/proveedor.dart';
import '../../domain/repositories/proveedores_repository.dart';

/// Repositorio del módulo de Proveedores. Hoy resuelve a la
/// implementación en memoria; el día que exista backend, cambiar esta
/// línea es lo único necesario (nada en la UI depende de la
/// implementación concreta).
final proveedoresRepositoryProvider = Provider<ProveedoresRepository>((ref) {
  return ProveedoresRepositoryImpl(
    datasource: const ProveedoresMockDatasource(),
  );
});

/// Lista de proveedores + acciones para registrar, editar o eliminar uno.
class ProveedoresNotifier extends Notifier<List<Proveedor>> {
  @override
  List<Proveedor> build() =>
      ref.watch(proveedoresRepositoryProvider).obtenerProveedores();

  /// Siguiente ID correlativo (PRV-005, PRV-006, ...).
  String siguienteId() {
    final maxNum = state.fold<int>(0, (max, p) {
      final n = int.tryParse(p.id.replaceAll('PRV-', '')) ?? 0;
      return n > max ? n : max;
    });
    return 'PRV-${(maxNum + 1).toString().padLeft(3, '0')}';
  }

  void registrarProveedor(Proveedor proveedor) {
    ref.read(proveedoresRepositoryProvider).registrarProveedor(proveedor);
    state = [proveedor, ...state];
  }

  void actualizarProveedor(Proveedor proveedor) {
    ref.read(proveedoresRepositoryProvider).actualizarProveedor(proveedor);
    state = [
      for (final p in state)
        if (p.id == proveedor.id) proveedor else p,
    ];
  }

  void cambiarEstado(String id, bool activo) {
    Proveedor? actualizado;
    state = [
      for (final p in state)
        if (p.id == id) actualizado = p.copyWith(activo: activo) else p,
    ];
    if (actualizado != null) {
      ref.read(proveedoresRepositoryProvider).actualizarProveedor(actualizado!);
    }
  }

  void eliminarProveedor(String id) {
    ref.read(proveedoresRepositoryProvider).eliminarProveedor(id);
    state = state.where((p) => p.id != id).toList();
  }
}

final proveedoresProvider =
    NotifierProvider<ProveedoresNotifier, List<Proveedor>>(
      ProveedoresNotifier.new,
    );

/// Estado del bottom sheet "Filtrar proveedores" + del texto de búsqueda
/// del header de la página. Se mantiene separado del
/// `ProveedoresNotifier` porque filtrar no modifica los datos, solo lo
/// que se muestra.
@immutable
class FiltrosProveedores {
  final String busqueda;
  final TipoProveedor? tipo;
  final bool? activo;

  const FiltrosProveedores({this.busqueda = '', this.tipo, this.activo});

  bool get sinFiltrosAplicados => tipo == null && activo == null;

  FiltrosProveedores copyWith({
    String? busqueda,
    TipoProveedor? tipo,
    bool? activo,
    bool limpiarTipo = false,
    bool limpiarActivo = false,
  }) {
    return FiltrosProveedores(
      busqueda: busqueda ?? this.busqueda,
      tipo: limpiarTipo ? null : (tipo ?? this.tipo),
      activo: limpiarActivo ? null : (activo ?? this.activo),
    );
  }
}

class FiltrosProveedoresNotifier extends Notifier<FiltrosProveedores> {
  @override
  FiltrosProveedores build() => const FiltrosProveedores();

  void setBusqueda(String texto) => state = state.copyWith(busqueda: texto);

  void setTipo(TipoProveedor? tipo) =>
      state = state.copyWith(tipo: tipo, limpiarTipo: tipo == null);

  void setActivo(bool? activo) =>
      state = state.copyWith(activo: activo, limpiarActivo: activo == null);

  void limpiar() => state = FiltrosProveedores(busqueda: state.busqueda);
}

final filtrosProveedoresProvider =
    NotifierProvider<FiltrosProveedoresNotifier, FiltrosProveedores>(
      FiltrosProveedoresNotifier.new,
    );

/// Lista de proveedores ya filtrada por búsqueda + filtros activos. Es lo
/// que la página realmente pinta en pantalla.
final proveedoresFiltradosProvider = Provider<List<Proveedor>>((ref) {
  final proveedores = ref.watch(proveedoresProvider);
  final filtros = ref.watch(filtrosProveedoresProvider);

  return proveedores.where((p) {
    if (filtros.busqueda.trim().isNotEmpty) {
      final q = filtros.busqueda.trim().toLowerCase();
      final coincide = p.nombreEmpresa.toLowerCase().contains(q) ||
          p.nombreContacto.toLowerCase().contains(q) ||
          p.nit.toLowerCase().contains(q);
      if (!coincide) return false;
    }
    if (filtros.tipo != null && !p.tipos.contains(filtros.tipo)) {
      return false;
    }
    if (filtros.activo != null && p.activo != filtros.activo) {
      return false;
    }
    return true;
  }).toList();
});