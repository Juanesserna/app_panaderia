// ---------- Enums ----------

enum EstadoVenta {
  pendiente,
  enProceso,
  completado,
  cancelado;

  String get label {
    switch (this) {
      case EstadoVenta.pendiente:
        return 'Pendiente';
      case EstadoVenta.enProceso:
        return 'En proceso';
      case EstadoVenta.completado:
        return 'Completado';
      case EstadoVenta.cancelado:
        return 'Cancelado';
    }
  }
}

enum MetodoPago {
  efectivo,
  tarjeta,
  transferencia;

  String get label {
    switch (this) {
      case MetodoPago.efectivo:
        return 'Efectivo';
      case MetodoPago.tarjeta:
        return 'Tarjeta';
      case MetodoPago.transferencia:
        return 'Transferencia';
    }
  }
}

enum CanalVenta {
  pagina,
  encargo,
  presencial;

  String get label {
    switch (this) {
      case CanalVenta.pagina:
        return 'Página';
      case CanalVenta.encargo:
        return 'Encargo';
      case CanalVenta.presencial:
        return 'Presencial';
    }
  }
}

/// Reglas de transición de estado. "cancelado" es terminal y "completado"
/// no retrocede — mismo criterio que usa el listado web (bloqueado cuando
/// estado == cancelado).
class EstadoTransiciones {
  static const Map<EstadoVenta, List<EstadoVenta>> _permitidas = {
    EstadoVenta.pendiente: [
      EstadoVenta.pendiente,
      EstadoVenta.enProceso,
      EstadoVenta.completado,
      EstadoVenta.cancelado,
    ],
    EstadoVenta.enProceso: [
      EstadoVenta.enProceso,
      EstadoVenta.completado,
      EstadoVenta.cancelado,
    ],
    EstadoVenta.completado: [EstadoVenta.completado],
    EstadoVenta.cancelado: [EstadoVenta.cancelado],
  };

  static bool esValida(EstadoVenta actual, EstadoVenta nuevo) =>
      _permitidas[actual]?.contains(nuevo) ?? false;

  static List<EstadoVenta> opcionesPara(EstadoVenta actual) =>
      _permitidas[actual] ?? [actual];
}

// ---------- Entidades ----------

class ItemVenta {
  final String nombre;
  final int cantidad;
  final double precio;

  const ItemVenta({required this.nombre, required this.cantidad, required this.precio});

  double get subtotal => cantidad * precio;

  ItemVenta copyWith({int? cantidad}) =>
      ItemVenta(nombre: nombre, cantidad: cantidad ?? this.cantidad, precio: precio);
}

class Cliente {
  final String nit;
  final String nombre;
  const Cliente({required this.nit, required this.nombre});
}

class ProductoCatalogo {
  final String nombre;
  final double precio;
  final String? imagen;
  final int? stock; // null = sin control de stock explícito

  const ProductoCatalogo({required this.nombre, required this.precio, this.imagen, this.stock});

  bool get sinStock => stock != null && stock! <= 0;
}

/// Comprobante de pago por "cupo": si `pagoUnico` es true hay 1 cupo (100%),
/// si es false hay 2 cupos (50% cada uno) — igual que `pagosPermitidos` en la web.
class Abono {
  final String id;
  final String idVenta;
  final int slot; // 1 ó 2
  final String fecha;
  final String urlComprobante; // path local de la imagen

  const Abono({
    required this.id,
    required this.idVenta,
    required this.slot,
    required this.fecha,
    required this.urlComprobante,
  });

  Abono copyWith({String? urlComprobante, String? fecha}) => Abono(
        id: id,
        idVenta: idVenta,
        slot: slot,
        fecha: fecha ?? this.fecha,
        urlComprobante: urlComprobante ?? this.urlComprobante,
      );
}

class Venta {
  final String id;
  final String usuario;
  final String? cliente;
  final String? nit;
  final String productosResumen;
  final List<ItemVenta> items;
  final double total;
  final EstadoVenta estado;
  final MetodoPago? metodo;
  final CanalVenta canal;
  final bool pagoUnico; // true = 1 comprobante 100% · false = 2 comprobantes 50%
  final String fecha;
  final String hora;

  const Venta({
    required this.id,
    required this.usuario,
    this.cliente,
    this.nit,
    required this.productosResumen,
    this.items = const [],
    required this.total,
    required this.estado,
    this.metodo,
    this.canal = CanalVenta.presencial,
    this.pagoUnico = true,
    required this.fecha,
    required this.hora,
  });

  int get pagosPermitidos => pagoUnico ? 1 : 2;

  int get cantidadProductos => items.fold(0, (s, i) => s + i.cantidad);

  Venta copyWith({EstadoVenta? estado}) => Venta(
        id: id,
        usuario: usuario,
        cliente: cliente,
        nit: nit,
        productosResumen: productosResumen,
        items: items,
        total: total,
        estado: estado ?? this.estado,
        metodo: metodo,
        canal: canal,
        pagoUnico: pagoUnico,
        fecha: fecha,
        hora: hora,
      );
}

extension FirstOrNullExt<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}