import 'package:flutter/material.dart';

class ModalExportar extends StatefulWidget {
  const ModalExportar({Key? key}) : super(key: key);

  @override
  State<ModalExportar> createState() => _ModalExportarState();
}

class _ModalExportarState extends State<ModalExportar> {
  String formatoSeleccionado = "excel";
  final List<String> modulosSeleccionados = ["Ventas", "Compras"];
  final List<String> modulos = [
    "Ventas",
    "Producción",
    "Compras",
    "Insumos",
    "Productos",
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Exportar reporte",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              "MÓDULOS A INCLUIR",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: modulos.map((mod) {
                final estaSeleccionado = modulosSeleccionados.contains(mod);
                return FilterChip(
                  label: Text(mod),
                  selected: estaSeleccionado,
                  onSelected: (val) {
                    setState(() {
                      if (val) {
                        modulosSeleccionados.add(mod);
                      } else {
                        modulosSeleccionados.remove(mod);
                      }
                    });
                  },
                  selectedColor: const Color(0xFFFF6B00).withOpacity(0.2),
                  checkmarkColor: const Color(0xFFFF6B00),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              "FORMATO",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text("Excel (.xlsx)")),
                    selected: formatoSeleccionado == "excel",
                    onSelected: (val) =>
                        setState(() => formatoSeleccionado = "excel"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text("PDF (.pdf)")),
                    selected: formatoSeleccionado == "pdf",
                    onSelected: (val) =>
                        setState(() => formatoSeleccionado = "pdf"),
                  ),
                ),
              ],
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
                    onPressed: modulosSeleccionados.isEmpty
                        ? null
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Generando reporte en $formatoSeleccionado...",
                                ),
                              ),
                            );
                            Navigator.of(context).pop();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B00),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      "Exportar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
