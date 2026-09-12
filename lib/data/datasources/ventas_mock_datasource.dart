import '../../domain/entities/venta.dart';

/// Fuente de datos estática para el módulo de Ventas (solo diseño y
/// funcional, sin backend todavía). Cuando exista API/DB, este archivo
/// se reemplaza por un datasource remoto que devuelva la misma forma de
/// datos; nada más del módulo debería cambiar.
class VentasMockDatasource {
  const VentasMockDatasource();

  List<Venta> ventasIniciales() => const [
        Venta(
          id: '#2851',
          usuario: 'María López',
          cliente: 'María López',
          nit: '1085822412',
          productosResumen: 'Pan de molde ×3, Croissant ×6',
          total: 285.0,
          estado: EstadoVenta.completado,
          fecha: '20/06/2026',
          hora: '',
          metodo: MetodoPago.tarjeta,
        ),
        Venta(
          id: '#2850',
          usuario: 'Carlos Ruiz',
          cliente: 'Carlos Ruiz',
          nit: '1014942603',
          productosResumen: 'Baguette ×2, Muffin ×4',
          total: 520.0,
          estado: EstadoVenta.enProceso,
          fecha: '20/06/2026',
          hora: '',
          metodo: MetodoPago.efectivo,
        ),
        Venta(
          id: '#2849',
          usuario: 'Ana García',
          cliente: 'Ana García',
          nit: '1003356886',
          productosResumen: 'Torta chocolate ×1',
          total: 160.0,
          estado: EstadoVenta.completado,
          fecha: '20/06/2026',
          hora: '',
          metodo: MetodoPago.tarjeta,
        ),
        Venta(
          id: '#2848',
          usuario: 'José Martínez',
          cliente: 'José Martínez',
          nit: '1099529223',
          productosResumen: 'Pan francés ×40',
          total: 340.0,
          estado: EstadoVenta.pendiente,
          fecha: '20/06/2026',
          hora: '',
          metodo: MetodoPago.transferencia,
        ),
        Venta(
          id: '#2847',
          usuario: 'Laura Sánchez',
          cliente: 'Laura Sánchez',
          nit: '1036913810',
          productosResumen: 'Croissant ×12, Muffin ×2',
          total: 185.0,
          estado: EstadoVenta.completado,
          fecha: '20/06/2026',
          hora: '',
          metodo: MetodoPago.efectivo,
        ),
        Venta(
          id: '#2846',
          usuario: 'Pedro Gómez',
          cliente: 'Pedro Gómez',
          nit: '1032868828',
          productosResumen: 'Torta de chocolate ×2',
          total: 210.0,
          estado: EstadoVenta.cancelado,
          fecha: '20/06/2026',
          hora: '',
          metodo: MetodoPago.tarjeta,
        ),
      ];

  List<Cliente> catalogoClientes() => const [
        Cliente(nit: '1085822412', nombre: 'María López'),
        Cliente(nit: '1014942603', nombre: 'Carlos Ruiz'),
        Cliente(nit: '1003356886', nombre: 'Ana García'),
        Cliente(nit: '1099529223', nombre: 'José Martínez'),
        Cliente(nit: '1036913810', nombre: 'Laura Sánchez'),
        Cliente(nit: 'NN', nombre: 'Cliente no identificado (NN)'),
      ];

  List<ProductoCatalogo> catalogoPanaderia() => const [
        ProductoCatalogo(nombre: 'Pan francés', precio: 8.5),
        ProductoCatalogo(nombre: 'Croissant', precio: 12.0),
        ProductoCatalogo(nombre: 'Pan integral', precio: 15.0),
        ProductoCatalogo(nombre: 'Torta de chocolate', precio: 45.0),
        ProductoCatalogo(nombre: 'Empanada de pollo', precio: 18.0),
        ProductoCatalogo(nombre: 'Muffin de arándano', precio: 14.0),
        ProductoCatalogo(nombre: 'Baguette', precio: 10.0),
        ProductoCatalogo(nombre: 'Donut glaseado', precio: 9.0),
        ProductoCatalogo(nombre: 'Pan dulce', precio: 7.5),
        ProductoCatalogo(nombre: 'Galletas de avena', precio: 6.0),
      ];

  /// Usuario autenticado (estático hasta que exista un authProvider real).
  String usuarioAutenticado() => 'Andrea Gómez';
}
