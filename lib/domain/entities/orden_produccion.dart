import 'package:flutter/foundation.dart';

/// Estado del ciclo de vida de una orden de producción.
enum EstadoOrden { pendiente, enProceso, completado, retrasado, cancelado }

extension EstadoOrdenLabel on EstadoOrden {
  String get label {
    switch (this) {
      case EstadoOrden.pendiente:
        return 'Pendiente';
      case EstadoOrden.enProceso:
        return 'En proceso';
      case EstadoOrden.completado:
        return 'Completado';
      case EstadoOrden.retrasado:
        return 'Retrasado';
      case EstadoOrden.cancelado:
        return 'Cancelado';
    }
  }
}

/// Origen de una orden de producción.
enum OrigenOrden { manual, pagina }

extension OrigenOrdenLabel on OrigenOrden {
  String get label => this == OrigenOrden.manual ? 'Manual' : 'Página';
}

/// Un producto (y su cantidad) dentro de una orden de producción, o
/// dentro del formulario de "Nueva orden" / "Editar" mientras se arma.
@immutable
class ItemOrden {
  final String nombre;
  final int cantidad;
  const ItemOrden({required this.nombre, required this.cantidad});

  ItemOrden copyWith({int? cantidad}) =>
      ItemOrden(nombre: nombre, cantidad: cantidad ?? this.cantidad);
}

/// Quién generó la orden. El significado depende del origen:
/// - [OrigenOrden.manual]: operador interno que la creó desde este panel
///   (se toma de la sesión activa, ver `usuarioActualProduccionProvider`).
/// - [OrigenOrden.pagina]: cliente que solicitó la compra desde el sitio
///   web (en una integración real llegaría junto con el pedido online).
@immutable
class GeneradoPor {
  final String nombre;
  final String documento;
  const GeneradoPor({required this.nombre, required this.documento});
}

/// Un insumo dentro de una receta de producto, o ya consolidado como el
/// total requerido para fabricar una orden completa (ver
/// `calcularInsumos`).
@immutable
class Insumo {
  final String nombre;
  final double cantidad;
  final String unidad;
  const Insumo({
    required this.nombre,
    required this.cantidad,
    required this.unidad,
  });
}

/// Una orden de producción.
@immutable
class OrdenProduccion {
  final String id;
  final OrigenOrden origen;
  final List<ItemOrden> items;
  final String unidad;

  /// Fecha (y hora) en que se solicitó la orden. Formato `dd/MM/yyyy HH:mm`.
  final String fechaSolicitud;

  /// Fecha en que se fabricó / está programada la fabricación.
  /// Vacío = aún no definida.
  final String fechaFabricacion;

  final EstadoOrden estado;
  final GeneradoPor generadoPor;

  /// Solo presente en órdenes de origen [OrigenOrden.pagina]: venta que
  /// originó esta orden.
  final String? ventaId;

  const OrdenProduccion({
    required this.id,
    required this.origen,
    required this.items,
    this.unidad = 'piezas',
    required this.fechaSolicitud,
    this.fechaFabricacion = '',
    required this.estado,
    required this.generadoPor,
    this.ventaId,
  });

  int get totalCantidad => items.fold(0, (s, i) => s + i.cantidad);

  /// "completado" y "cancelado" son estados finales: la orden completa
  /// queda bloqueada y ya no se puede editar ni cambiar de estado.
  bool get esEstadoFinal =>
      estado == EstadoOrden.completado || estado == EstadoOrden.cancelado;

  /// Fecha de solicitud parseada, asumiendo el formato `dd/MM/yyyy HH:mm`
  /// usado en toda la app.
  DateTime get fechaSolicitudDateTime {
    final partes = fechaSolicitud.split(' ');
    final f = partes[0].split('/').map(int.parse).toList();
    final h =
        partes.length > 1 ? partes[1].split(':').map(int.parse).toList() : [0, 0];
    return DateTime(f[2], f[1], f[0], h[0], h[1]);
  }

  static const _dosDias = Duration(days: 2);

  /// Estado mostrado en pantalla: si la orden lleva 2 días o más desde su
  /// solicitud y no llegó a un estado final, se considera "retrasado"
  /// automáticamente (sin mutar `estado`), igual que en el diseño web.
  EstadoOrden get estadoEfectivo {
    if (esEstadoFinal) return estado;
    final transcurrido = DateTime.now().difference(fechaSolicitudDateTime);
    if (transcurrido >= _dosDias) return EstadoOrden.retrasado;
    return estado;
  }

  OrdenProduccion copyWith({
    List<ItemOrden>? items,
    String? fechaFabricacion,
    EstadoOrden? estado,
  }) {
    return OrdenProduccion(
      id: id,
      origen: origen,
      items: items ?? this.items,
      unidad: unidad,
      fechaSolicitud: fechaSolicitud,
      fechaFabricacion: fechaFabricacion ?? this.fechaFabricacion,
      estado: estado ?? this.estado,
      generadoPor: generadoPor,
      ventaId: ventaId,
    );
  }
}

/// Calcula el total consolidado de insumos para todos los ítems de una
/// orden, sumando insumos iguales entre productos distintos, a partir del
/// mapa de recetas del catálogo (`ProduccionRepository.obtenerRecetas`).
List<Insumo> calcularInsumos(
  List<ItemOrden> items,
  Map<String, List<Insumo>> recetas,
) {
  final acumulado = <String, Insumo>{};
  for (final item in items) {
    final receta = recetas[item.nombre];
    if (receta == null) continue;
    for (final insumo in receta) {
      final total = insumo.cantidad * item.cantidad;
      final actual = acumulado[insumo.nombre];
      acumulado[insumo.nombre] = Insumo(
        nombre: insumo.nombre,
        cantidad: (actual?.cantidad ?? 0) + total,
        unidad: insumo.unidad,
      );
    }
  }
  return acumulado.values.toList();
}
