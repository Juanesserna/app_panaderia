import 'package:flutter/foundation.dart';

/// Método de pago con el que se registra un abono. Ya no se pide al
/// crear la venta manualmente: una venta puede pagarse con más de un
/// método a lo largo de varios abonos.
enum MetodoPago { efectivo, tarjeta, transferencia }

extension MetodoPagoLabel on MetodoPago {
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

/// Estado del ciclo de vida de una venta.
enum EstadoVenta { pendiente, enProceso, completado, cancelado }

extension EstadoVentaLabel on EstadoVenta {
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

/// Un cliente del catálogo (equivale a `catalogoClientes` del diseño web).
@immutable
class Cliente {
  final String nit;
  final String nombre;
  const Cliente({required this.nit, required this.nombre});
}

/// Un producto del catálogo de panadería.
@immutable
class ProductoCatalogo {
  final String nombre;
  final double precio;
  const ProductoCatalogo({required this.nombre, required this.precio});
}

/// Un producto dentro de una venta ya registrada (o dentro del formulario
/// de "Nueva venta" mientras se arma).
@immutable
class ItemVenta {
  final String nombre;
  final int cantidad;
  final double precio;
  const ItemVenta({
    required this.nombre,
    required this.cantidad,
    required this.precio,
  });

  double get subtotal => cantidad * precio;

  ItemVenta copyWith({int? cantidad}) => ItemVenta(
        nombre: nombre,
        cantidad: cantidad ?? this.cantidad,
        precio: precio,
      );
}

/// Una venta.
@immutable
class Venta {
  final String id;
  final String usuario;
  final String? cliente;
  final String? nit;
  final String productosResumen;
  final double total;
  final EstadoVenta estado;
  final String fecha;
  final String hora;
  final MetodoPago? metodo;
  final List<ItemVenta> items;

  const Venta({
    required this.id,
    required this.usuario,
    this.cliente,
    this.nit,
    required this.productosResumen,
    required this.total,
    required this.estado,
    required this.fecha,
    required this.hora,
    this.metodo,
    this.items = const [],
  });

  Venta copyWith({EstadoVenta? estado, MetodoPago? metodo}) {
    return Venta(
      id: id,
      usuario: usuario,
      cliente: cliente,
      nit: nit,
      productosResumen: productosResumen,
      total: total,
      estado: estado ?? this.estado,
      fecha: fecha,
      hora: hora,
      metodo: metodo ?? this.metodo,
      items: items,
    );
  }
}

/// Abono: pago parcial asociado a una venta.
/// PK: id, FK: idVenta -> Venta.id
@immutable
class Abono {
  final String id;
  final String idVenta;
  final String fecha;
  final double monto;
  final MetodoPago metodoPago;
  final String urlComprobante;

  const Abono({
    required this.id,
    required this.idVenta,
    required this.fecha,
    required this.monto,
    required this.metodoPago,
    required this.urlComprobante,
  });
}
