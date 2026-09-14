import 'package:flutter/foundation.dart';

/// Categoría de un insumo. Se muestra tanto en el chip de la tarjeta
/// ("Harinas · kg") como en el filtro de "Filtrar insumos".
enum CategoriaInsumo { harinas, lacteos, endulzantes, leudantes, proteinas }

extension CategoriaInsumoLabel on CategoriaInsumo {
  String get label {
    switch (this) {
      case CategoriaInsumo.harinas:
        return 'Harinas';
      case CategoriaInsumo.lacteos:
        return 'Lácteos';
      case CategoriaInsumo.endulzantes:
        return 'Endulzantes';
      case CategoriaInsumo.leudantes:
        return 'Leudantes';
      case CategoriaInsumo.proteinas:
        return 'Proteínas';
    }
  }
}

/// Unidad de medida en la que se controla el stock de un insumo.
enum UnidadInsumo { kg, g, lt, ud }

extension UnidadInsumoLabel on UnidadInsumo {
  String get label {
    switch (this) {
      case UnidadInsumo.kg:
        return 'kg';
      case UnidadInsumo.g:
        return 'g';
      case UnidadInsumo.lt:
        return 'lt';
      case UnidadInsumo.ud:
        return 'ud';
    }
  }
}

/// Nivel de stock mostrado como badge en cada tarjeta. Es un valor
/// calculado (ver [InsumoInventario.nivelStock]), nunca se guarda suelto.
enum NivelStock { normal, stockBajo, agotado }

extension NivelStockLabel on NivelStock {
  String get label {
    switch (this) {
      case NivelStock.normal:
        return 'Normal';
      case NivelStock.stockBajo:
        return 'Stock bajo';
      case NivelStock.agotado:
        return 'Agotado';
    }
  }
}

/// Un lote físico de un insumo (por ejemplo, una compra recibida en una
/// fecha concreta). Sirve para el contador "N lote(s)" de cada tarjeta y,
/// más adelante, para alertas de vencimiento.
@immutable
class LoteInsumo {
  final String id;
  final double cantidad;

  /// Formato `dd/MM/yyyy`. Vacío si el insumo no maneja vencimiento.
  final String fechaVencimiento;

  const LoteInsumo({
    required this.id,
    required this.cantidad,
    this.fechaVencimiento = '',
  });
}

/// Un insumo del inventario de AlHorno (harinas, lácteos, endulzantes,
/// leudantes, proteínas, etc.).
///
/// Se llama `InsumoInventario` (y no simplemente `Insumo`) a propósito:
/// el módulo de Producción ya tiene su propia clase `Insumo` (más simple,
/// solo nombre/cantidad/unidad, usada para recetas) en
/// `domain/entities/orden_produccion.dart`. Son conceptos distintos que
/// conviven en la misma app, así que se mantienen separados para no
/// romper nada de ese módulo.
@immutable
class InsumoInventario {
  final String id;
  final String nombre;
  final CategoriaInsumo categoria;
  final UnidadInsumo unidad;
  final double stockActual;
  final double stockMinimo;
  final bool activo;
  final List<LoteInsumo> lotes;

  const InsumoInventario({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.unidad,
    required this.stockActual,
    required this.stockMinimo,
    this.activo = true,
    this.lotes = const [],
  });

  int get cantidadLotes => lotes.length;

  /// Nivel de stock calculado, igual a la regla usada en el diseño web:
  /// 0 = agotado, por debajo del mínimo = stock bajo, resto = normal.
  NivelStock get nivelStock {
    if (stockActual <= 0) return NivelStock.agotado;
    if (stockActual < stockMinimo) return NivelStock.stockBajo;
    return NivelStock.normal;
  }

  /// Proporción (0.0 a 1.0) usada para pintar la barra de progreso bajo
  /// el nombre del insumo.
  double get proporcionStock {
    if (stockMinimo <= 0) return stockActual > 0 ? 1.0 : 0.0;
    return (stockActual / stockMinimo).clamp(0.0, 1.0);
  }

  InsumoInventario copyWith({
    String? nombre,
    CategoriaInsumo? categoria,
    UnidadInsumo? unidad,
    double? stockActual,
    double? stockMinimo,
    bool? activo,
    List<LoteInsumo>? lotes,
  }) {
    return InsumoInventario(
      id: id,
      nombre: nombre ?? this.nombre,
      categoria: categoria ?? this.categoria,
      unidad: unidad ?? this.unidad,
      stockActual: stockActual ?? this.stockActual,
      stockMinimo: stockMinimo ?? this.stockMinimo,
      activo: activo ?? this.activo,
      lotes: lotes ?? this.lotes,
    );
  }
}
