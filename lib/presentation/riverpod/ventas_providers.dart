import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../core/utils/date_format.dart';
import '../../data/datasources/ventas_mock_datasource.dart';
import '../../domain/entities/venta.dart';

const _datasource = VentasMockDatasource();

// ---------- Catálogos / usuario ----------

final usuarioActualProvider = Provider<String>(
  (ref) => _datasource.usuarioAutenticado(),
);

final clientesProvider = Provider<List<Cliente>>(
  (ref) => _datasource.catalogoClientes(),
);

final catalogoProductosProvider = Provider<List<ProductoCatalogo>>(
  (ref) => _datasource.catalogoPanaderia(),
);

// ---------- Búsqueda (listado) ----------

final ventasBusquedaProvider = StateProvider<String>((ref) => '');

// ---------- Filtros avanzados (FiltrosVentasSheet) ----------

final filtroEstadosProvider = StateProvider<Set<EstadoVenta>>((ref) => {});
final filtroMetodosProvider = StateProvider<Set<MetodoPago>>((ref) => {});
final filtroCanalesProvider = StateProvider<Set<CanalVenta>>((ref) => {});
final filtroIdProvider = StateProvider<String>((ref) => '');

/// true si hay algún filtro avanzado activo (para mostrar un badge, etc.)
final hayFiltrosActivosProvider = Provider<bool>((ref) {
  return ref.watch(filtroEstadosProvider).isNotEmpty ||
      ref.watch(filtroMetodosProvider).isNotEmpty ||
      ref.watch(filtroCanalesProvider).isNotEmpty ||
      ref.watch(filtroIdProvider).trim().isNotEmpty;
});

/// Ventas filtradas por el buscador (id, cliente o usuario) — el mismo
/// criterio que usa `filtered` en la web — combinado con los filtros
/// avanzados de FiltrosVentasSheet (estado, método de pago, canal, id).
final ventasFiltradasProvider = Provider<List<Venta>>((ref) {
  final ventas = ref.watch(ventasProvider);
  final busqueda = ref.watch(ventasBusquedaProvider).trim().toLowerCase();
  final estados = ref.watch(filtroEstadosProvider);
  final metodos = ref.watch(filtroMetodosProvider);
  final canales = ref.watch(filtroCanalesProvider);
  final idFiltro = ref.watch(filtroIdProvider).trim().toLowerCase();

  return ventas.where((v) {
    if (busqueda.isNotEmpty) {
      final cliente = (v.cliente ?? v.usuario).toLowerCase();
      final coincideBusqueda = v.id.toLowerCase().contains(busqueda) || cliente.contains(busqueda);
      if (!coincideBusqueda) return false;
    }
    if (idFiltro.isNotEmpty && !v.id.toLowerCase().contains(idFiltro)) return false;
    if (estados.isNotEmpty && !estados.contains(v.estado)) return false;
    if (metodos.isNotEmpty && (v.metodo == null || !metodos.contains(v.metodo))) return false;
    if (canales.isNotEmpty && !canales.contains(v.canal)) return false;
    return true;
  }).toList();
});

// ---------- Ventas ----------

final ventasProvider = StateNotifierProvider<VentasNotifier, List<Venta>>(
  (ref) => VentasNotifier(),
);

class VentasNotifier extends StateNotifier<List<Venta>> {
  VentasNotifier() : super(_datasource.ventasIniciales());

  String siguienteId() {
    final maxNum = state.fold<int>(0, (max, v) {
      final n = int.tryParse(v.id.replaceAll('#', '')) ?? 0;
      return n > max ? n : max;
    });
    return '#${maxNum + 1}';
  }

  void registrarVenta(Venta venta) => state = [venta, ...state];

  void actualizarEstado(String id, EstadoVenta nuevo) {
    state = [
      for (final v in state)
        if (v.id == id && EstadoTransiciones.esValida(v.estado, nuevo)) v.copyWith(estado: nuevo) else v,
    ];
  }
}

// ---------- Pagos (comprobantes por cupo) ----------

final abonosProvider = StateNotifierProvider<AbonosNotifier, List<Abono>>(
  (ref) => AbonosNotifier(ref),
);

class AbonosNotifier extends StateNotifier<List<Abono>> {
  AbonosNotifier(this._ref) : super([]);
  final Ref _ref;

  List<Abono> paraVenta(String idVenta) => state.where((a) => a.idVenta == idVenta).toList();

  Abono? deSlot(String idVenta, int slot) =>
      state.where((a) => a.idVenta == idVenta && a.slot == slot).firstOrNull;

  /// Sube o reemplaza el comprobante de un cupo. Si tras esta subida aún
  /// falta algún cupo por pagar, la venta pasa a "en proceso" — igual que
  /// `handleImagenAbonoSeleccionada` en la web (allí se llamaba "pago parcial").
  void registrarOReemplazar({required Venta venta, required int slot, required String urlComprobante}) {
    final fecha = fechaHoyFormateada();
    final existe = state.any((a) => a.idVenta == venta.id && a.slot == slot);

    state = existe
        ? [
            for (final a in state)
              if (a.idVenta == venta.id && a.slot == slot)
                a.copyWith(urlComprobante: urlComprobante, fecha: fecha)
              else
                a,
          ]
        : [
            ...state,
            Abono(
              id: 'AB-${venta.id.replaceAll('#', '')}-$slot',
              idVenta: venta.id,
              slot: slot,
              fecha: fecha,
              urlComprobante: urlComprobante,
            ),
          ];

    final otrosCupos = state.where((a) => a.idVenta == venta.id && a.slot != slot).length;
    final pagoCompleto = otrosCupos + 1 >= venta.pagosPermitidos;
    if (!pagoCompleto) {
      _ref.read(ventasProvider.notifier).actualizarEstado(venta.id, EstadoVenta.enProceso);
    }
  }
}