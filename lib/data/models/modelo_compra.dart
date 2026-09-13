enum EstadoCompra { pagado, pendiente, parcial, cancelado }

class ModeloCompra {
  final String id;
  final String proveedor;
  final String insumos;
  final double total;
  final EstadoCompra estado;
  final DateTime fecha;

  ModeloCompra({
    required this.id,
    required this.proveedor,
    required this.insumos,
    required this.total,
    required this.estado,
    required this.fecha,
  });

  static String obtenerEtiquetaEstado(EstadoCompra estado) {
    switch (estado) {
      case EstadoCompra.pagado:
        return 'Pagado';
      case EstadoCompra.pendiente:
        return 'Pendiente';
      case EstadoCompra.parcial:
        return 'Parcial';
      case EstadoCompra.cancelado:
        return 'Cancelado';
    }
  }
}
