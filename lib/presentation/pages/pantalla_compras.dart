import 'package:flutter/material.dart';
import '../../data/models/modelo_compra.dart';
import '../widgets/compras/nueva_compra_sheet.dart';

class PantallaCompras extends StatefulWidget {
  const PantallaCompras({Key? key}) : super(key: key);

  @override
  State<PantallaCompras> createState() => _PantallaComprasState();
}

class _PantallaComprasState extends State<PantallaCompras> {
  String consultaBusqueda = "";
  EstadoCompra? estadoSeleccionado;

  final List<ModeloCompra> compras = [
    ModeloCompra(
      id: "COM-001",
      proveedor: "Distribuidora Riogrande SAS",
      insumos: "Harina de trigo x50kg, Levadura x10kg",
      total: 450000.0,
      estado: EstadoCompra.pagado,
      fecha: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ModeloCompra(
      id: "COM-002",
      proveedor: "Industria Nacional de Gaseosas",
      insumos: "Bebidas variadas x5 cajas",
      total: 180000.0,
      estado: EstadoCompra.pendiente,
      fecha: DateTime.now(),
    ),
    ModeloCompra(
      id: "COM-003",
      proveedor: "Lácteos del Norte",
      insumos: "Mantequilla sin sal x20kg, Leche x50L",
      total: 320000.0,
      estado: EstadoCompra.parcial,
      fecha: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

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
    final listaFiltrada = compras.where((item) {
      final coincideBusqueda =
          item.proveedor.toLowerCase().contains(
            consultaBusqueda.toLowerCase(),
          ) ||
          item.insumos.toLowerCase().contains(consultaBusqueda.toLowerCase()) ||
          item.id.toLowerCase().contains(consultaBusqueda.toLowerCase());
      final coincideEstado =
          estadoSeleccionado == null || item.estado == estadoSeleccionado;
      return coincideBusqueda && coincideEstado;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestión de Compras"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => NuevaCompraSheet(
                  onGuardar: (nuevaCompra) {
                    setState(() {
                      compras.insert(0, nuevaCompra);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Compra ${nuevaCompra.id} registrada"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Buscar por proveedor o insumos...",
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (val) => setState(() => consultaBusqueda = val),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: const Text("Todos"),
                    selected: estadoSeleccionado == null,
                    onSelected: (_) =>
                        setState(() => estadoSeleccionado = null),
                  ),
                  const SizedBox(width: 8),
                  ...EstadoCompra.values.map((estado) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: Text(ModeloCompra.obtenerEtiquetaEstado(estado)),
                        selected: estadoSeleccionado == estado,
                        onSelected: (seleccionado) {
                          setState(() {
                            estadoSeleccionado = seleccionado ? estado : null;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: listaFiltrada.isEmpty
                  ? const Center(child: Text("No se encontraron registros."))
                  : ListView.builder(
                      itemCount: listaFiltrada.length,
                      itemBuilder: (context, index) {
                        final item = listaFiltrada[index];
                        final color = _obtenerColorEstado(item.estado);

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${item.id} • ${item.proveedor}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: color.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        ModeloCompra.obtenerEtiquetaEstado(
                                          item.estado,
                                        ),
                                        style: TextStyle(
                                          color: color,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item.insumos,
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 13,
                                  ),
                                ),
                                const Divider(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${item.fecha.day}/${item.fecha.month}/${item.fecha.year}",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      "\$${item.total.toStringAsFixed(2)}",
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
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
