import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/currency_format.dart';
import '../../../core/utils/date_format.dart';
import '../../../domain/entities/venta.dart';
import '../../riverpod/ventas_providers.dart';
import '../shell/app_bottom_sheet.dart';

/// Contenido del bottom sheet "Nueva venta". Se abre con:
///   showAppBottomSheet(context, title: 'Nueva venta', builder: (_) => const NuevaVentaSheet());
class NuevaVentaSheet extends ConsumerStatefulWidget {
  const NuevaVentaSheet({super.key});

  @override
  ConsumerState<NuevaVentaSheet> createState() => _NuevaVentaSheetState();
}

class _NuevaVentaSheetState extends ConsumerState<NuevaVentaSheet> {
  late final String _formId;
  late final String _formFecha;
  late final String _formHora;

  final _clienteBusquedaCtrl = TextEditingController();
  String? _clienteNit;
  bool _showClienteDropdown = false;

  EstadoVenta _estadoInicial = EstadoVenta.pendiente;

  final _productoBusquedaCtrl = TextEditingController();
  String? _productoSeleccionado;
  bool _showProductoDropdown = false;
  int _cantidad = 1;

  final List<ItemVenta> _items = [];

  @override
  void initState() {
    super.initState();
    _formId = ref.read(ventasProvider.notifier).siguienteId();
    _formFecha = fechaHoyFormateada();
    _formHora = horaHoyFormateada();
  }

  @override
  void dispose() {
    _clienteBusquedaCtrl.dispose();
    _productoBusquedaCtrl.dispose();
    super.dispose();
  }

  double get _total => _items.fold(0, (s, i) => s + i.subtotal);

  void _agregarProducto(ProductoCatalogo p) {
    setState(() {
      final idx = _items.indexWhere((i) => i.nombre == p.nombre);
      if (idx != -1) {
        _items[idx] = _items[idx].copyWith(cantidad: _items[idx].cantidad + _cantidad);
      } else {
        _items.add(ItemVenta(nombre: p.nombre, cantidad: _cantidad, precio: p.precio));
      }
      _productoBusquedaCtrl.clear();
      _productoSeleccionado = null;
      _cantidad = 1;
      _showProductoDropdown = false;
    });
  }

  void _actualizarCantidad(String nombre, int nuevaCantidad) {
    setState(() {
      if (nuevaCantidad <= 0) {
        _items.removeWhere((i) => i.nombre == nombre);
        return;
      }
      final idx = _items.indexWhere((i) => i.nombre == nombre);
      if (idx != -1) _items[idx] = _items[idx].copyWith(cantidad: nuevaCantidad);
    });
  }

  void _registrarVenta(List<Cliente> clientes) {
    if (_items.isEmpty || _clienteNit == null) return;
    final clienteSel = clientes.where((c) => c.nit == _clienteNit).firstOrNull;
    final nuevaVenta = Venta(
      id: _formId,
      usuario: ref.read(usuarioActualProvider),
      cliente: clienteSel?.nombre ?? 'Cliente no especificado',
      nit: _clienteNit,
      productosResumen: _items.map((i) => '${i.nombre} ×${i.cantidad}').join(', '),
      total: _total,
      estado: _estadoInicial,
      fecha: _formFecha,
      hora: _formHora,
      items: List.of(_items),
    );
    ref.read(ventasProvider.notifier).registrarVenta(nuevaVenta);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final clientes = ref.watch(clientesProvider);
    final productos = ref.watch(catalogoProductosProvider);

    final clientesFiltrados = clientes
        .where((c) => '${c.nit} ${c.nombre}'.toLowerCase().contains(_clienteBusquedaCtrl.text.toLowerCase()))
        .toList();
    final productosFiltrados = productos
        .where((p) => p.nombre.toLowerCase().contains(_productoBusquedaCtrl.text.toLowerCase()))
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header con ID y fecha
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.surface2,
              border: Border.all(color: colors.border),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ID de venta', style: AppTextStyles.caption.copyWith(color: colors.textMuted)),
                    Text('Fecha', style: AppTextStyles.caption.copyWith(color: colors.textMuted)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(_formId, style: AppTextStyles.monoCaption.copyWith(color: colors.text)),
                    Text('$_formFecha · $_formHora', style: AppTextStyles.monoCaption.copyWith(color: colors.text)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Buscador de NIT/Cédula
          _Label('NIT/CÉDULA'),
          const SizedBox(height: 6),
          _BorderedField(
            controller: _clienteBusquedaCtrl,
            hint: 'Buscar por NIT o nombre...',
            onFocusChange: (focused) => setState(() => _showClienteDropdown = focused),
            onChanged: (v) => setState(() {
              _clienteNit = null;
              _showClienteDropdown = true;
            }),
          ),
          if (_showClienteDropdown && clientesFiltrados.isNotEmpty)
            _Dropdown(
              children: clientesFiltrados
                  .map(
                    (c) => _DropdownItem(
                      label: '${c.nit} — ${c.nombre}',
                      onTap: () => setState(() {
                        _clienteNit = c.nit;
                        _clienteBusquedaCtrl.text = '${c.nit} — ${c.nombre}';
                        _showClienteDropdown = false;
                      }),
                    ),
                  )
                  .toList(),
            ),
          const SizedBox(height: 16),

          // Estado inicial
          _Label('ESTADO INICIAL'),
          const SizedBox(height: 6),
          _EstadoDropdown(
            value: _estadoInicial,
            onChanged: (v) => setState(() => _estadoInicial = v),
          ),
          const SizedBox(height: 8),
          const AppDivider(),
          const SizedBox(height: 16),

          // Agregar productos
          _Label('AGREGAR PRODUCTOS'),
          const SizedBox(height: 6),
          _BorderedField(
            controller: _productoBusquedaCtrl,
            hint: 'Buscar producto...',
            onFocusChange: (focused) => setState(() => _showProductoDropdown = focused),
            onChanged: (v) => setState(() {
              _productoSeleccionado = null;
              _showProductoDropdown = true;
            }),
          ),
          if (_showProductoDropdown)
            _Dropdown(
              children: productosFiltrados.isEmpty
                  ? [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text('Sin resultados', style: AppTextStyles.caption.copyWith(color: colors.textMuted)),
                      ),
                    ]
                  : productosFiltrados
                      .map(
                        (p) => _DropdownItem(
                          label: p.nombre,
                          trailing: '\$${p.precio.toStringAsFixed(2)}',
                          active: _productoSeleccionado == p.nombre,
                          onTap: () => setState(() {
                            _productoSeleccionado = p.nombre;
                            _productoBusquedaCtrl.text = p.nombre;
                            _showProductoDropdown = false;
                          }),
                        ),
                      )
                      .toList(),
            ),
          const SizedBox(height: 10),
          Row(
            children: [
              _StepperControl(
                value: _cantidad,
                onChanged: (v) => setState(() => _cantidad = v),
              ),
              const Spacer(),
              _MiniButton(
                label: '+ Agregar',
                enabled: _productoSeleccionado != null,
                onTap: () {
                  final p = productos.where((p) => p.nombre == _productoSeleccionado).firstOrNull;
                  if (p != null) _agregarProducto(p);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Resumen
          _Label('RESUMEN'),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 90),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.surface2,
              border: Border.all(color: colors.border),
              borderRadius: BorderRadius.circular(18),
            ),
            child: _items.isEmpty
                ? Center(
                    child: Text(
                      'Sin productos agregados',
                      style: AppTextStyles.caption.copyWith(color: colors.textMuted, fontWeight: FontWeight.w600),
                    ),
                  )
                : Column(
                    children: _items
                        .map(
                          (item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(item.nombre,
                                      style: AppTextStyles.captionBold.copyWith(color: colors.text),
                                      overflow: TextOverflow.ellipsis),
                                ),
                                _StepperControl(
                                  compact: true,
                                  value: item.cantidad,
                                  onChanged: (v) => _actualizarCantidad(item.nombre, v),
                                ),
                                const SizedBox(width: 8),
                                Text('\$${item.subtotal.toStringAsFixed(2)}',
                                    style: AppTextStyles.monoCaption.copyWith(color: colors.text)),
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  icon: Icon(Icons.close, size: 16, color: colors.danger),
                                  onPressed: () => setState(() => _items.removeWhere((i) => i.nombre == item.nombre)),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
          const SizedBox(height: 16),

          // Total y registrar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total a pagar', style: AppTextStyles.bodyBold.copyWith(color: colors.textMuted)),
              Text(formatCurrency(_total),
                  style: AppTextStyles.monoBody.copyWith(fontSize: 22, fontWeight: FontWeight.bold, color: colors.text)),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (_items.isEmpty || _clienteNit == null) ? null : () => _registrarVenta(clientes),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.accent,
                foregroundColor: colors.accentFg,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text('Registrar venta', style: AppTextStyles.bodyBold.copyWith(color: colors.accentFg)),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- Helpers de UI internos del formulario ----------

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Text(text, style: AppTextStyles.tiny.copyWith(color: colors.textMuted, letterSpacing: 0.4));
  }
}

class _BorderedField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<bool>? onFocusChange;
  const _BorderedField({required this.controller, required this.hint, this.onChanged, this.onFocusChange});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Focus(
      onFocusChange: onFocusChange,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface2,
          border: Border.all(color: colors.border),
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          style: AppTextStyles.bodyRegular.copyWith(color: colors.text),
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
            hintText: hint,
            hintStyle: AppTextStyles.bodyRegular.copyWith(color: colors.textMuted),
          ),
        ),
      ),
    );
  }
}

class _Dropdown extends StatelessWidget {
  final List<Widget> children;
  const _Dropdown({required this.children});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      margin: const EdgeInsets.only(top: 4),
      constraints: const BoxConstraints(maxHeight: 176),
      decoration: BoxDecoration(
        color: colors.surface2,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: SingleChildScrollView(child: Column(children: children)),
      ),
    );
  }
}

class _DropdownItem extends StatelessWidget {
  final String label;
  final String? trailing;
  final bool active;
  final VoidCallback onTap;
  const _DropdownItem({required this.label, this.trailing, this.active = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return InkWell(
      onTap: onTap,
      child: Container(
        color: active ? colors.border : null,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(label, style: AppTextStyles.caption.copyWith(color: colors.text))),
            if (trailing != null)
              Text(trailing!, style: AppTextStyles.monoCaption.copyWith(color: colors.textMuted)),
          ],
        ),
      ),
    );
  }
}

class _EstadoDropdown extends StatelessWidget {
  final EstadoVenta value;
  final ValueChanged<EstadoVenta> onChanged;
  const _EstadoDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface2,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<EstadoVenta>(
          value: value,
          isExpanded: true,
          style: AppTextStyles.bodyRegular.copyWith(color: colors.text),
          dropdownColor: colors.surface2,
          items: EstadoVenta.values
              .map((e) => DropdownMenuItem(value: e, child: Text(e.label)))
              .toList(),
          onChanged: (v) => v != null ? onChanged(v) : null,
        ),
      ),
    );
  }
}

class _StepperControl extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final bool compact;
  const _StepperControl({required this.value, required this.onChanged, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final size = compact ? 22.0 : 34.0;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(compact ? 8 : 12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepBtn(icon: Icons.remove, size: size, onTap: () => onChanged(value - 1)),
          SizedBox(
            width: compact ? 20 : 28,
            child: Text('$value', textAlign: TextAlign.center, style: AppTextStyles.monoCaption.copyWith(color: colors.text)),
          ),
          _StepBtn(icon: Icons.add, size: size, onTap: () => onChanged(value + 1)),
        ],
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  final IconData icon;
  final double size;
  final VoidCallback onTap;
  const _StepBtn({required this.icon, required this.size, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return InkWell(
      onTap: onTap,
      child: SizedBox(width: size, height: size, child: Icon(icon, size: 14, color: colors.textMuted)),
    );
  }
}

class _MiniButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;
  const _MiniButton({required this.label, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Material(
      color: colors.surface2,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: enabled ? onTap : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(border: Border.all(color: colors.border), borderRadius: BorderRadius.circular(12)),
          child: Opacity(
            opacity: enabled ? 1 : 0.5,
            child: Text(label, style: AppTextStyles.captionBold.copyWith(color: colors.text)),
          ),
        ),
      ),
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
