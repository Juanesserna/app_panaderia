import 'package:flutter/foundation.dart';

/// Una categoría del catálogo de AlHorno (ej. Panes, Bollería, Tortas,
/// Galletas). Agrupa productos e insumos para el directorio de
/// Categorías y para el gráfico de distribución.
@immutable
class Categoria {
  final String id;
  final String nombre;
  final String descripcion;

  /// Índice de color usado para el punto y la barra de la categoría.
  /// Ver `kCategoriaPalette` en `presentation/widgets/categorias/categoria_color.dart`.
  final int colorIndex;

  final int cantidadProductos;
  final int cantidadInsumos;
  final bool activa;

  const Categoria({
    required this.id,
    required this.nombre,
    this.descripcion = '',
    this.colorIndex = 0,
    this.cantidadProductos = 0,
    this.cantidadInsumos = 0,
    this.activa = true,
  });

  Categoria copyWith({
    String? nombre,
    String? descripcion,
    int? colorIndex,
    int? cantidadProductos,
    int? cantidadInsumos,
    bool? activa,
  }) {
    return Categoria(
      id: id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      colorIndex: colorIndex ?? this.colorIndex,
      cantidadProductos: cantidadProductos ?? this.cantidadProductos,
      cantidadInsumos: cantidadInsumos ?? this.cantidadInsumos,
      activa: activa ?? this.activa,
    );
  }
}
