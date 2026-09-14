import '../../domain/entities/proveedor.dart';

/// Fuente de datos estática para el módulo de Proveedores (solo diseño y
/// funcional, sin backend todavía). Cuando exista API/DB, este archivo se
/// reemplaza por un datasource remoto que devuelva la misma forma de
/// datos; nada más del módulo debería cambiar.
class ProveedoresMockDatasource {
  const ProveedoresMockDatasource();

  List<Proveedor> proveedoresIniciales() => const [
    Proveedor(
      id: 'PRV-001',
      nombreEmpresa: 'Harinera del Valle',
      nit: '900.123.456-7',
      nombreContacto: 'Roberto Ossa',
      telefono: '310 555 0100',
      correo: 'ventas@harineradelvalle.com',
      direccion: 'Cra 45 #12-30, Medellín',
      tipos: [TipoProveedor.harinas, TipoProveedor.cereales],
      activo: true,
    ),
    Proveedor(
      id: 'PRV-002',
      nombreEmpresa: 'Lácteos El Campo',
      nit: '901.234.567-1',
      nombreContacto: 'Gloria Hincapié',
      telefono: '311 555 0200',
      correo: 'pedidos@lacteoselcampo.com',
      direccion: 'Vía La Ceja Km 3, Antioquia',
      tipos: [TipoProveedor.lacteos, TipoProveedor.proteinas],
      activo: true,
    ),
    Proveedor(
      id: 'PRV-003',
      nombreEmpresa: 'Avícola El Rosario',
      nit: '890.654.321-0',
      nombreContacto: 'Hernán Duque',
      telefono: '315 555 0300',
      correo: 'pedidos@elrosario.com',
      direccion: 'Km 4 Vía Funza, Cundinamarca',
      tipos: [TipoProveedor.proteinas],
      activo: true,
    ),
    Proveedor(
      id: 'PRV-004',
      nombreEmpresa: 'Endulzantes Sur',
      nit: '902.345.678-2',
      nombreContacto: 'Paola Vega',
      telefono: '313 555 0400',
      correo: 'contacto@endulzantessur.com',
      direccion: 'Cl 10 #5-20, Cali',
      tipos: [TipoProveedor.endulzantes],
      activo: false,
    ),
  ];
}
