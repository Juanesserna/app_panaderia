import 'package:flutter/material.dart';
import '../../data/models/modelo_orden.dart';
import '../widgets/common/tarjeta_kpi.dart';
import '../widgets/common/modal_exportar.dart';

class PantallaDashboard extends StatefulWidget {
  const PantallaDashboard({Key? key}) : super(key: key);

  @override
  State<PantallaDashboard> createState() => _PantallaDashboardState();
}

class _PantallaDashboardState extends State<PantallaDashboard> {
  DateTimeRange rangoFechaSeleccionado = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 6)),
    end: DateTime.now(),
  );

  final List<ModeloOrden> ordenesRecientes = [
    ModeloOrden(
      id: "#2851",
      cliente: "María López",
      productos: "Pan integral ×3, Croissant ×2",
      total: "\$285.00",
      estado: EstadoOrden.completado,
      hora: "09:42",
    ),
    ModeloOrden(
      id: "#2850",
      cliente: "Carlos Ruiz",
      productos: "Pastel de chocolate (1kg)",
      total: "\$520.00",
      estado: EstadoOrden.enProceso,
      hora: "09:35",
    ),
    ModeloOrden(
      id: "#2849",
      cliente: "Ana García",
      productos: "Galletas surtidas ×4",
      total: "\$160.00",
      estado: EstadoOrden.completado,
      hora: "09:18",
    ),
    ModeloOrden(
      id: "#2848",
      cliente: "Pedro Gomez",
      productos: "Baguette x2, Mermelada x1",
      total: "\$95.00",
      estado: EstadoOrden.pendiente,
      hora: "08:50",
    ),
  ];

  Color _obtenerColorEstado(EstadoOrden estado) {
    switch (estado) {
      case EstadoOrden.completado:
        return Colors.green;
      case EstadoOrden.enProceso:
        return Colors.orange;
      case EstadoOrden.pendiente:
        return Colors.blue;
      case EstadoOrden.cancelado:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Panel General"),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today, size: 20),
            onPressed: () async {
              final seleccion = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2025),
                lastDate: DateTime(2030),
                initialDateRange: rangoFechaSeleccionado,
              );
              if (seleccion != null) {
                setState(() => rangoFechaSeleccionado = seleccion);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.download, size: 20),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const ModalExportar(),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Expanded(
                  child: TarjetaKPI(
                    titulo: "Total ventas del mes",
                    valor: "\$319,330",
                    subtitulo: "Actualizado hace 2 min",
                    icono: Icons.trending_up,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: TarjetaKPI(
                    titulo: "Pedidos Activos",
                    valor: "127",
                    subtitulo: "34 listos para entrega",
                    icono: Icons.shopping_cart,
                    colorAcento: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: const [
                Expanded(
                  child: TarjetaKPI(
                    titulo: "Compras del período",
                    valor: "\$140,745",
                    subtitulo: "Periodo seleccionado",
                    icono: Icons.shopping_bag_outlined,
                    colorAcento: Colors.deepOrange,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: TarjetaKPI(
                    titulo: "Pedidos recientes",
                    valor: "6",
                    subtitulo: "Últimos registrados",
                    icono: Icons.receipt_long_outlined,
                    colorAcento: Colors.indigo,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Pedidos Recientes",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(onPressed: () {}, child: const Text("Ver todos")),
              ],
            ),
            const SizedBox(height: 8),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ordenesRecientes.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = ordenesRecientes[index];
                final color = _obtenerColorEstado(item.estado);

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 4),
                  title: Row(
                    children: [
                      Text(
                        item.id,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      Text(item.cliente),
                    ],
                  ),
                  subtitle: Text(
                    item.productos,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        item.total,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          ModeloOrden.obtenerEtiquetaEstado(item.estado),
                          style: TextStyle(
                            color: color,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
