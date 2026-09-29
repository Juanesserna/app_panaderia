import '../../domain/entities/orden_produccion.dart';

/// Fuente de datos estática para el módulo de Producción (solo diseño y
/// funcional, sin backend todavía). Cuando exista API/DB, este archivo
/// se reemplaza por un datasource remoto que devuelva la misma forma de
/// datos; nada más del módulo debería cambiar.
class ProduccionMockDatasource {
  const ProduccionMockDatasource();

  Map<String, List<Insumo>> recetasProductos() => const {
        'Jugo': [
          Insumo(nombre: 'Fruta (naranja)', cantidad: 0.3, unidad: 'kg'),
          Insumo(nombre: 'Azúcar', cantidad: 0.02, unidad: 'kg'),
          Insumo(nombre: 'Agua', cantidad: 0.15, unidad: 'l'),
        ],
        'Pan': [
          Insumo(nombre: 'Harina de trigo', cantidad: 0.1, unidad: 'kg'),
          Insumo(nombre: 'Levadura', cantidad: 0.005, unidad: 'kg'),
          Insumo(nombre: 'Sal', cantidad: 0.002, unidad: 'kg'),
          Insumo(nombre: 'Mantequilla', cantidad: 0.01, unidad: 'kg'),
        ],
        'Palito Q': [
          Insumo(nombre: 'Harina de maíz', cantidad: 0.08, unidad: 'kg'),
          Insumo(nombre: 'Queso en polvo', cantidad: 0.03, unidad: 'kg'),
          Insumo(nombre: 'Aceite vegetal', cantidad: 0.005, unidad: 'l'),
          Insumo(nombre: 'Sal', cantidad: 0.002, unidad: 'kg'),
        ],
        'Palito G': [
          Insumo(nombre: 'Harina de maíz', cantidad: 0.12, unidad: 'kg'),
          Insumo(nombre: 'Queso en polvo', cantidad: 0.04, unidad: 'kg'),
          Insumo(nombre: 'Aceite vegetal', cantidad: 0.008, unidad: 'l'),
          Insumo(nombre: 'Sal', cantidad: 0.003, unidad: 'kg'),
        ],
        'Pastel P': [
          Insumo(nombre: 'Harina de trigo', cantidad: 0.15, unidad: 'kg'),
          Insumo(nombre: 'Huevo', cantidad: 0.05, unidad: 'kg'),
          Insumo(nombre: 'Azúcar', cantidad: 0.08, unidad: 'kg'),
          Insumo(nombre: 'Mantequilla', cantidad: 0.06, unidad: 'kg'),
        ],
        'Pastel H': [
          Insumo(nombre: 'Harina de trigo', cantidad: 0.15, unidad: 'kg'),
          Insumo(nombre: 'Huevo', cantidad: 0.05, unidad: 'kg'),
          Insumo(nombre: 'Azúcar', cantidad: 0.08, unidad: 'kg'),
          Insumo(nombre: 'Chocolate', cantidad: 0.07, unidad: 'kg'),
          Insumo(nombre: 'Mantequilla', cantidad: 0.04, unidad: 'kg'),
        ],
        'Pastel A': [
          Insumo(nombre: 'Harina de trigo', cantidad: 0.15, unidad: 'kg'),
          Insumo(nombre: 'Huevo', cantidad: 0.05, unidad: 'kg'),
          Insumo(nombre: 'Arequipe', cantidad: 0.09, unidad: 'kg'),
          Insumo(nombre: 'Mantequilla', cantidad: 0.04, unidad: 'kg'),
        ],
        'Palito GQ': [
          Insumo(nombre: 'Harina de maíz', cantidad: 0.1, unidad: 'kg'),
          Insumo(nombre: 'Queso en polvo', cantidad: 0.05, unidad: 'kg'),
          Insumo(nombre: 'Aceite vegetal', cantidad: 0.006, unidad: 'l'),
          Insumo(nombre: 'Sal', cantidad: 0.002, unidad: 'kg'),
          Insumo(nombre: 'Ajo en polvo', cantidad: 0.001, unidad: 'kg'),
        ],
      };

  /// Catálogo de productos disponibles para armar una orden.
  List<String> catalogoProductos() => const [
        'Jugo',
        'Pan',
        'Palito Q',
        'Palito G',
        'Pastel P',
        'Pastel H',
        'Pastel A',
        'Palito GQ',
      ];

  /// Usuario actualmente autenticado (operador que registra la orden
  /// manualmente).
  GeneradoPor usuarioAutenticado() =>
      const GeneradoPor(nombre: 'Andrea Gómez', documento: '1020304050');

  List<OrdenProduccion> ordenesIniciales() => const [
        OrdenProduccion(
          id: 'OP-001',
          origen: OrigenOrden.manual,
          items: [
            ItemOrden(nombre: 'Pan', cantidad: 3),
            ItemOrden(nombre: 'Palito G', cantidad: 2),
          ],
          fechaSolicitud: '20/06/2026 05:30',
          fechaFabricacion: '20/06/2026 06:15',
          estado: EstadoOrden.completado,
          generadoPor: GeneradoPor(nombre: 'Andrea Gómez', documento: '1020304050'),
        ),
        OrdenProduccion(
          id: 'OP-002',
          origen: OrigenOrden.pagina,
          items: [
            ItemOrden(nombre: 'Pastel A', cantidad: 20),
            ItemOrden(nombre: 'Pastel P', cantidad: 10),
          ],
          fechaSolicitud: '20/06/2026 06:00',
          fechaFabricacion: '20/06/2026 07:30',
          estado: EstadoOrden.completado,
          generadoPor: GeneradoPor(nombre: 'Camila Restrepo', documento: '1098765432'),
          ventaId: '#2210',
        ),
        OrdenProduccion(
          id: 'OP-003',
          origen: OrigenOrden.manual,
          items: [ItemOrden(nombre: 'Palito G', cantidad: 15)],
          fechaSolicitud: '20/06/2026 07:00',
          estado: EstadoOrden.enProceso,
          generadoPor: GeneradoPor(nombre: 'Andrea Gómez', documento: '1020304050'),
        ),
        OrdenProduccion(
          id: 'OP-004',
          origen: OrigenOrden.manual,
          items: [
            ItemOrden(nombre: 'Jugo', cantidad: 10),
            ItemOrden(nombre: 'Palito Q', cantidad: 10),
          ],
          fechaSolicitud: '20/06/2026 08:30',
          estado: EstadoOrden.enProceso,
          generadoPor:
              GeneradoPor(nombre: 'Juan Pablo Restrepo', documento: '1015223344'),
        ),
        OrdenProduccion(
          id: 'OP-005',
          origen: OrigenOrden.pagina,
          items: [
            ItemOrden(nombre: 'Pastel H', cantidad: 40),
            ItemOrden(nombre: 'Palito GQ', cantidad: 20),
          ],
          fechaSolicitud: '20/06/2026 09:00',
          estado: EstadoOrden.pendiente,
          generadoPor: GeneradoPor(nombre: 'Laura Jiménez', documento: '43215678'),
          ventaId: '#2210',
        ),
        OrdenProduccion(
          id: 'OP-006',
          origen: OrigenOrden.manual,
          items: [ItemOrden(nombre: 'Palito Q', cantidad: 30)],
          fechaSolicitud: '20/06/2026 09:30',
          fechaFabricacion: '20/06/2026 12:00',
          estado: EstadoOrden.retrasado,
          generadoPor: GeneradoPor(nombre: 'Andrea Gómez', documento: '1020304050'),
        ),
        OrdenProduccion(
          id: 'OP-007',
          origen: OrigenOrden.pagina,
          items: [
            ItemOrden(nombre: 'Palito GQ', cantidad: 20),
            ItemOrden(nombre: 'Pastel H', cantidad: 20),
          ],
          fechaSolicitud: '20/06/2026 10:00',
          estado: EstadoOrden.pendiente,
          generadoPor: GeneradoPor(nombre: 'Mateo Salazar', documento: '71234567'),
          ventaId: '#2210',
        ),
        OrdenProduccion(
          id: 'OP-008',
          origen: OrigenOrden.manual,
          items: [
            ItemOrden(nombre: 'Jugo', cantidad: 6),
            ItemOrden(nombre: 'Palito Q', cantidad: 4),
          ],
          fechaSolicitud: '20/06/2026 11:00',
          estado: EstadoOrden.pendiente,
          generadoPor: GeneradoPor(nombre: 'Andrea Gómez', documento: '1020304050'),
        ),
      ];
}
