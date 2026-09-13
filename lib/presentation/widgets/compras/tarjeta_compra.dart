import 'package:flutter/material.dart';
import '../../../data/models/modelo_compra.dart';

class TarjetaCompra extends StatelessWidget {
  final ModeloCompra compra;
  final VoidCallback? onTap;

  const TarjetaCompra({Key? key, required this.compra, this.onTap})
    : super(key: key);

  Color _obtenerColorEstado(EstadoCompra estado) {
    switch (estado) {
      case EstadoCompra.pagado:
        return Colors.green;
      case EstadoCompra.pendiente:
        return Colors.orange;
      case EstadoCompra.parcial:
        return Colors.blue;
      case EstadoCompra.cancelado:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorEstado = _obtenerColorEstado(compra.estado);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "${compra.id} • ${compra.proveedor}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: colorEstado.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      ModeloCompra.obtenerEtiquetaEstado(compra.estado),
                      style: TextStyle(
                        color: colorEstado,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                compra.insumos,
                style: TextStyle(color: Colors.grey[700], fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${compra.fecha.day.toString().padLeft(2, '0')}/${compra.fecha.month.toString().padLeft(2, '0')}/${compra.fecha.year}",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    "\$${compra.total.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
