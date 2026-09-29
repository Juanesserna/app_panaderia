enum EstadoOrden { completado, enProceso, pendiente, cancelado }

class ModeloOrden {
  final String id;
  final String cliente;
  final String productos;
  final String total;
  final EstadoOrden estado;
  final String hora;

  ModeloOrden({
    required this.id,
    required this.cliente,
    required this.productos,
    required this.total,
    required this.estado,
    required this.hora,
  });

  static String obtenerEtiquetaEstado(EstadoOrden estado) {
    switch (estado) {
      case EstadoOrden.completado:
        return 'Completado';
      case EstadoOrden.enProceso:
        return 'En proceso';
      case EstadoOrden.pendiente:
        return 'Pendiente';
      case EstadoOrden.cancelado:
        return 'Cancelado';
    }
  }
}
