enum EstadoCompra { pagado, pendiente, parcial, cancelado }

/// Trazabilidad del lote de un insumo comprado.
class LoteCompra {
  final String numero; // generado automáticamente, no editable
  final DateTime? vencimiento; // opcional
  final double cantidadDisponible; // por defecto igual a lo comprado

  const LoteCompra({
    required this.numero,
    this.vencimiento,
    required this.cantidadDisponible,
  });
}

/// Un insumo dentro de una compra (antes esto era texto libre en
/// `ModeloCompra.insumos`; ahora cada insumo es un registro estructurado
/// con cantidad, unidad, valor y su propio lote).
class ItemCompra {
  final String insumo;
  final double cantidad;
  final String unidad;
  final double valorUnitario;
  final LoteCompra lote;

  const ItemCompra({
    required this.insumo,
    required this.cantidad,
    required this.unidad,
    required this.valorUnitario,
    required this.lote,
  });

  double get subtotal => cantidad * valorUnitario;
}

class ModeloCompra {
  final String id;
  final String proveedor;
  final List<ItemCompra> items;
  final double total;
  final EstadoCompra estado;
  final DateTime fecha;
  final double descuentoPorcentaje;

  ModeloCompra({
    required this.id,
    required this.proveedor,
    required this.items,
    required this.total,
    required this.estado,
    required this.fecha,
    this.descuentoPorcentaje = 0.0,
  });

  /// Resumen legible de los insumos, ej: "Harina de trigo x50kg, Levadura x10kg".
  /// Reemplaza al antiguo campo `insumos` (String) en los lugares donde solo
  /// se necesitaba mostrar o buscar texto (tarjeta, filtro de búsqueda).
  String get resumenInsumos => items
      .map((i) => '${i.insumo} x${_formatearCantidad(i.cantidad)}${i.unidad}')
      .join(', ');

  static String _formatearCantidad(double n) =>
      n == n.roundToDouble() ? n.toInt().toString() : n.toString();

  static String obtenerEtiquetaEstado(EstadoCompra estado) {
    switch (estado) {
      case EstadoCompra.pagado:
        return 'Pagado';
      case EstadoCompra.pendiente:
        return 'Pendiente';
      case EstadoCompra.parcial:
        return 'Parcial';
      case EstadoCompra.cancelado:
        return 'Cancelado';
    }
  }
}
