import '../../domain/entities/insumo_inventario.dart';

/// Fuente de datos estática para el módulo de Insumos (solo diseño y
/// funcional, sin backend todavía). Cuando exista API/DB, este archivo se
/// reemplaza por un datasource remoto que devuelva la misma forma de
/// datos; nada más del módulo debería cambiar.
class InsumosMockDatasource {
  const InsumosMockDatasource();

  List<InsumoInventario> insumosIniciales() => const [
    InsumoInventario(
      id: 'INS-001',
      nombre: 'Harina de trigo',
      categoria: CategoriaInsumo.harinas,
      unidad: UnidadInsumo.kg,
      stockActual: 328,
      stockMinimo: 100,
      lotes: [
        LoteInsumo(id: 'L-001', cantidad: 200, fechaVencimiento: '20/12/2026'),
        LoteInsumo(id: 'L-002', cantidad: 128, fechaVencimiento: '15/01/2027'),
      ],
    ),
    InsumoInventario(
      id: 'INS-002',
      nombre: 'Mantequilla',
      categoria: CategoriaInsumo.lacteos,
      unidad: UnidadInsumo.kg,
      stockActual: 18,
      stockMinimo: 20,
      lotes: [
        LoteInsumo(id: 'L-003', cantidad: 18, fechaVencimiento: '30/09/2026'),
      ],
    ),
    InsumoInventario(
      id: 'INS-003',
      nombre: 'Azúcar refinada',
      categoria: CategoriaInsumo.endulzantes,
      unidad: UnidadInsumo.kg,
      stockActual: 145,
      stockMinimo: 50,
      lotes: [
        LoteInsumo(id: 'L-004', cantidad: 145, fechaVencimiento: '10/03/2027'),
      ],
    ),
    InsumoInventario(
      id: 'INS-004',
      nombre: 'Levadura seca',
      categoria: CategoriaInsumo.leudantes,
      unidad: UnidadInsumo.g,
      stockActual: 850,
      stockMinimo: 1000,
      lotes: [
        LoteInsumo(id: 'L-005', cantidad: 850, fechaVencimiento: '23/11/2026'),
      ],
    ),
    InsumoInventario(
      id: 'INS-005',
      nombre: 'Leche entera',
      categoria: CategoriaInsumo.lacteos,
      unidad: UnidadInsumo.lt,
      stockActual: 0,
      stockMinimo: 30,
      lotes: [],
    ),
    InsumoInventario(
      id: 'INS-006',
      nombre: 'Huevos',
      categoria: CategoriaInsumo.proteinas,
      unidad: UnidadInsumo.ud,
      stockActual: 240,
      stockMinimo: 40,
      lotes: [
        LoteInsumo(id: 'L-006', cantidad: 240, fechaVencimiento: '05/10/2026'),
      ],
    ),
  ];
}
