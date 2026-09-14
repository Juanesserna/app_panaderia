import 'package:flutter/foundation.dart';

/// Tipo de insumo que puede suministrar un proveedor. Se muestra como
/// chip tanto en la tarjeta del directorio como en el detalle
/// ("Harinas", "Cereales", etc.). Un proveedor puede tener varios tipos
/// a la vez (ej. "Harinera del Valle" => Harinas + Cereales).
enum TipoProveedor {
  harinas,
  cereales,
  lacteos,
  proteinas,
  endulzantes,
  leudantes,
}

extension TipoProveedorLabel on TipoProveedor {
  String get label {
    switch (this) {
      case TipoProveedor.harinas:
        return 'Harinas';
      case TipoProveedor.cereales:
        return 'Cereales';
      case TipoProveedor.lacteos:
        return 'Lácteos';
      case TipoProveedor.proteinas:
        return 'Proteínas';
      case TipoProveedor.endulzantes:
        return 'Endulzantes';
      case TipoProveedor.leudantes:
        return 'Leudantes';
    }
  }
}

/// Un proveedor del directorio de AlHorno (harinera, lácteos, avícola,
/// endulzantes, etc.).
@immutable
class Proveedor {
  final String id;
  final String nombreEmpresa;
  final String nit;
  final String nombreContacto;
  final String telefono;
  final String correo;
  final String direccion;
  final List<TipoProveedor> tipos;
  final String descripcion;
  final bool activo;

  const Proveedor({
    required this.id,
    required this.nombreEmpresa,
    required this.nit,
    this.nombreContacto = '',
    this.telefono = '',
    this.correo = '',
    this.direccion = '',
    this.tipos = const [],
    this.descripcion = '',
    this.activo = true,
  });

  /// Inicial mostrada en el avatar circular del directorio (primera letra
  /// del nombre de la empresa).
  String get inicial => nombreEmpresa.trim().isEmpty
      ? '?'
      : nombreEmpresa.trim()[0].toUpperCase();

  Proveedor copyWith({
    String? nombreEmpresa,
    String? nit,
    String? nombreContacto,
    String? telefono,
    String? correo,
    String? direccion,
    List<TipoProveedor>? tipos,
    String? descripcion,
    bool? activo,
  }) {
    return Proveedor(
      id: id,
      nombreEmpresa: nombreEmpresa ?? this.nombreEmpresa,
      nit: nit ?? this.nit,
      nombreContacto: nombreContacto ?? this.nombreContacto,
      telefono: telefono ?? this.telefono,
      correo: correo ?? this.correo,
      direccion: direccion ?? this.direccion,
      tipos: tipos ?? this.tipos,
      descripcion: descripcion ?? this.descripcion,
      activo: activo ?? this.activo,
    );
  }
}
