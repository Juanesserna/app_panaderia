import 'package:flutter/material.dart';
import '../../../data/models/modelo_compra.dart';

class NuevaCompraSheet extends StatefulWidget {
  final Function(ModeloCompra) onGuardar;

  const NuevaCompraSheet({Key? key, required this.onGuardar}) : super(key: key);

  @override
  State<NuevaCompraSheet> createState() => _NuevaCompraSheetState();
}

class _NuevaCompraSheetState extends State<NuevaCompraSheet> {
  final _formKey = GlobalKey<FormState>();
  final _proveedorController = TextEditingController();
  final _insumosController = TextEditingController();
  final _totalController = TextEditingController();
  EstadoCompra _estadoSeleccionado = EstadoCompra.pendiente;
  DateTime _fechaSeleccionada = DateTime.now();

  @override
  void dispose() {
    _proveedorController.dispose();
    _insumosController.dispose();
    _totalController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: const Locale('es', 'ES'),
    );
    if (picked != null && picked != _fechaSeleccionada) {
      setState(() => _fechaSeleccionada = picked);
    }
  }

  String _formatearFecha(DateTime fecha) {
    return "${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Nueva Compra",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _proveedorController,
                decoration: const InputDecoration(
                  labelText: "Proveedor *",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.business),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingrese el nombre del proveedor';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _insumosController,
                decoration: const InputDecoration(
                  labelText: "Insumos *",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.inventory_2),
                  hintText: "Ej: Harina de trigo x50kg, Levadura x10kg",
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingrese los insumos comprados';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _totalController,
                      decoration: const InputDecoration(
                        labelText: "Total *",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                        prefixText: "\$ ",
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Ingrese el total';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Ingrese un número válido';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: _seleccionarFecha,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: "Fecha *",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(_formatearFecha(_fechaSeleccionada)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                "ESTADO",
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: EstadoCompra.values.map((estado) {
                  final estaSeleccionado = _estadoSeleccionado == estado;
                  return FilterChip(
                    label: Text(ModeloCompra.obtenerEtiquetaEstado(estado)),
                    selected: estaSeleccionado,
                    onSelected: (val) {
                      setState(() => _estadoSeleccionado = estado);
                    },
                    selectedColor: const Color(0xFFFF6B00).withOpacity(0.2),
                    checkmarkColor: const Color(0xFFFF6B00),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text("Cancelar"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final compra = ModeloCompra(
                            id: "COM-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}",
                            proveedor: _proveedorController.text.trim(),
                            insumos: _insumosController.text.trim(),
                            total: double.parse(_totalController.text),
                            estado: _estadoSeleccionado,
                            fecha: _fechaSeleccionada,
                          );
                          widget.onGuardar(compra);
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B00),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        "Guardar",
                        style: TextStyle(color: Colors.white),
                      ),
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