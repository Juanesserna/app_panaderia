import '../../domain/entities/categoria.dart';

/// Fuente de datos estática para el módulo de Categorías (solo diseño y
/// funcional, sin backend todavía). Cuando exista API/DB, este archivo se
/// reemplaza por un datasource remoto que devuelva la misma forma de
/// datos; nada más del módulo debería cambiar.
class CategoriasMockDatasource {
  const CategoriasMockDatasource();

  List<Categoria> categoriasIniciales() => const [
    Categoria(
      id: 'CAT-001',
      nombre: 'Panes',
      descripcion: 'Variedades de pan artesanal',
      colorIndex: 0,
      cantidadProductos: 8,
      cantidadInsumos: 6,
      activa: true,
    ),
    Categoria(
      id: 'CAT-002',
      nombre: 'Bollería',
      descripcion: 'Croissants, caracoles y pasteles',
      colorIndex: 1,
      cantidadProductos: 5,
      cantidadInsumos: 8,
      activa: true,
    ),
    Categoria(
      id: 'CAT-003',
      nombre: 'Tortas',
      descripcion: 'Tortas decoradas y de encargo',
      colorIndex: 2,
      cantidadProductos: 4,
      cantidadInsumos: 12,
      activa: true,
    ),
    Categoria(
      id: 'CAT-004',
      nombre: 'Galletas',
      descripcion: 'Galletas artesanales',
      colorIndex: 3,
      cantidadProductos: 6,
      cantidadInsumos: 5,
      activa: true,
    ),
    Categoria(
      id: 'CAT-005',
      nombre: 'Postres',
      descripcion: 'Postres individuales y de vitrina',
      colorIndex: 4,
      cantidadProductos: 2,
      cantidadInsumos: 3,
      activa: false,
    ),
  ];
}
