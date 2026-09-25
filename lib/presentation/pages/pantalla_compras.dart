import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/modelo_compra.dart';
import '../widgets/compras/nueva_compra_sheet.dart';
import '../widgets/compras/tarjeta_compra.dart';
import '../widgets/compras/detalle_compra_sheet.dart';
import '../widgets/compras/filtros_compras_sheet.dart';
import '../widgets/shell/app_bottom_sheet.dart';
import '../widgets/common/common_ui.dart';

class PantallaCompras extends StatefulWidget {
  const PantallaCompras({super.key});

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
      items: [
        ItemCompra(
          insumo: "Harina de trigo",
          cantidad: 50,
          unidad: "kg",
          valorUnitario: 7000,
          lote: LoteCompra(numero: "LOTE-MT001", cantidadDisponible: 50),
        ),
        ItemCompra(
          insumo: "Levadura",
          cantidad: 10,
          unidad: "kg",
          valorUnitario: 10000,
          lote: LoteCompra(numero: "LOTE-MT002", cantidadDisponible: 10),
        ),
      ],
      total: 450000.0,
      estado: EstadoCompra.pagado,
      fecha: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ModeloCompra(
      id: "COM-002",
      proveedor: "Industria Nacional de Gaseosas",
      items: [
        ItemCompra(
          insumo: "Bebidas variadas",
          cantidad: 5,
          unidad: "cajas",
          valorUnitario: 36000,
          lote: LoteCompra(numero: "LOTE-MT003", cantidadDisponible: 5),
        ),
      ],
      total: 180000.0,
      estado: EstadoCompra.pendiente,
      fecha: DateTime.now(),
    ),
    ModeloCompra(
      id: "COM-003",
      proveedor: "Lácteos del Norte",
      items: [
        ItemCompra(
          insumo: "Mantequilla sin sal",
          cantidad: 20,
          unidad: "kg",
          valorUnitario: 9000,
          lote: LoteCompra(numero: "LOTE-MT004", cantidadDisponible: 20),
        ),
        ItemCompra(
          insumo: "Leche",
          cantidad: 50,
          unidad: "L",
          valorUnitario: 2800,
          lote: LoteCompra(numero: "LOTE-MT005", cantidadDisponible: 50),
        ),
      ],
      total: 320000.0,
      estado: EstadoCompra.parcial,
      fecha: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  void _abrirNuevaCompra() {
    showAppBottomSheet(
      context,
      title: 'Nueva Compra',
      builder: (_) => NuevaCompraSheet(
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
  }

  void _abrirFiltros() {
    showAppBottomSheet(
      context,
      title: 'Filtros',
      builder: (_) => FiltrosComprasSheet(
        estadoSeleccionado: estadoSeleccionado,
        onEstadoChanged: (nuevoEstado) {
          setState(() => estadoSeleccionado = nuevoEstado);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final listaFiltrada = compras.where((item) {
      // Antes: item.insumos (String). Ahora: item.resumenInsumos, calculado
      // a partir de item.items.
      final coincideBusqueda =
          item.proveedor.toLowerCase().contains(
            consultaBusqueda.toLowerCase(),
          ) ||
          item.resumenInsumos.toLowerCase().contains(
            consultaBusqueda.toLowerCase(),
          ) ||
          item.id.toLowerCase().contains(consultaBusqueda.toLowerCase());
      final coincideEstado =
          estadoSeleccionado == null || item.estado == estadoSeleccionado;
      return coincideBusqueda && coincideEstado;
    }).toList();

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: const Text("Gestión de Compras")),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppSearchField(
                        placeholder: 'Buscar por proveedor o insumos...',
                        onChanged: (val) =>
                            setState(() => consultaBusqueda = val),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ActionBtn(
                      label: 'Filtros',
                      icon: Icons.filter_list,
                      onTap: _abrirFiltros,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: listaFiltrada.isEmpty
                      ? const Center(
                          child: Text("No se encontraron registros."),
                        )
                      : ListView.builder(
                          itemCount: listaFiltrada.length,
                          itemBuilder: (context, index) {
                            final item = listaFiltrada[index];
                            return TarjetaCompra(
                              compra: item,
                              onTap: () => showAppBottomSheet(
                                context,
                                title: 'Detalle Compra',
                                builder: (_) => DetalleCompraSheet(
                                  compra: item,
                                  onActualizarEstado: (compraActualizada) {
                                    setState(() {
                                      final idx = compras.indexWhere(
                                        (c) => c.id == compraActualizada.id,
                                      );
                                      if (idx != -1) {
                                        compras[idx] = compraActualizada;
                                      }
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 16,
          bottom: 24,
          child: _NuevaCompraFab(onTap: _abrirNuevaCompra),
        ),
      ],
    );
  }
}

class _NuevaCompraFab extends StatelessWidget {
  final VoidCallback onTap;
  const _NuevaCompraFab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Material(
      color: colors.accent,
      borderRadius: BorderRadius.circular(18),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, size: 18, color: colors.accentFg),
              const SizedBox(width: 8),
              Text(
                'Nueva Compra',
                style: TextStyle(
                  color: colors.accentFg,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
