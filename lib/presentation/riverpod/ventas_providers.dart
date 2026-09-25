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

/// Ventas filtradas por el buscador (id, cliente o usuario) — el mismo
/// criterio que usa `filtered` en la web. Los filtros avanzados de
/// FiltrosVentasSheet se pueden combinar aquí más adelante.
final ventasFiltradasProvider = Provider<List<Venta>>((ref) {
  final ventas = ref.watch(ventasProvider);
  final busqueda = ref.watch(ventasBusquedaProvider).trim().toLowerCase();
  if (busqueda.isEmpty) return ventas;
  return ventas.where((v) {
    final cliente = (v.cliente ?? v.usuario).toLowerCase();
    return v.id.toLowerCase().contains(busqueda) || cliente.contains(busqueda);
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