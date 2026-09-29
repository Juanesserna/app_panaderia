import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../widgets/common/common_ui.dart';
import '../../widgets/productos/producto_form_fields.dart';

/// Pantalla de formulario para registrar un nuevo producto.
class NuevoProductoScreen extends StatefulWidget {
  const NuevoProductoScreen({super.key});

  @override
  State<NuevoProductoScreen> createState() => _NuevoProductoScreenState();
}

class _NuevoProductoScreenState extends State<NuevoProductoScreen> {
  final _nombreCtrl = TextEditingController();
  final _precioCtrl = TextEditingController();
  final _stockActualCtrl = TextEditingController();
  final _stockMinCtrl = TextEditingController();
  final _minProdCtrl = TextEditingController();
  final _maxProdCtrl = TextEditingController();
  final _imagenCtrl = TextEditingController();

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _precioCtrl.dispose();
    _stockActualCtrl.dispose();
    _stockMinCtrl.dispose();
    _minProdCtrl.dispose();
    _maxProdCtrl.dispose();
    _imagenCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(icon: const Icon(Icons.arrow_back, size: 22), onPressed: () => Navigator.pop(context)),
                Expanded(
                  child: Text('Nuevo Producto', style: AppTextStyles.titleMd.copyWith(color: colors.text)),
                ),
              ],
            ),
            Text('Completa los campos para registrar un nuevo producto', style: AppTextStyles.caption.copyWith(color: colors.textMuted)),
            const SizedBox(height: 20),
            ProductoFormFields(
              nombreCtrl: _nombreCtrl,
              precioCtrl: _precioCtrl,
              stockActualCtrl: _stockActualCtrl,
              stockMinCtrl: _stockMinCtrl,
              minProdCtrl: _minProdCtrl,
              maxProdCtrl: _maxProdCtrl,
              imagenCtrl: _imagenCtrl,
              initialCategoria: 'Bollería',
              initialActivo: true,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: ActionBtn(label: 'Cancelar', onTap: () => Navigator.pop(context))),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Próximamente')));
                    },
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(color: colors.accent, borderRadius: BorderRadius.circular(14)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                              child: Icon(Icons.add, size: 12, color: Color(0xFFC1592F)),
                            ),
                            const SizedBox(width: 6),
                            const Text('Guardar Producto', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
