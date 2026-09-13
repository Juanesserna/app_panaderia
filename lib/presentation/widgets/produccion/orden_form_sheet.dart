import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/date_format.dart';
import '../../../domain/entities/orden_produccion.dart';
import '../../riverpod/produccion_providers.dart';
import '../shell/app_bottom_sheet.dart';

/// Contenido del bottom sheet "Nueva orden" / "Editar orden". Se abre
/// con:
///   showAppBottomSheet(context, title: 'Nueva orden',
///       builder: (_) => const OrdenFormSheet());
///   showAppBottomSheet(context, title: 'Editar orden $id',
///       builder: (_) => OrdenFormSheet(ordenId: id));
class OrdenFormSheet extends ConsumerStatefulWidget {
  /// `null` = modo "nueva orden". Con un id existente = modo "editar".
  final String? ordenId;
  const OrdenFormSheet({super.key, this.ordenId});

  bool get esEdicion => ordenId != null;

  @override
  ConsumerState<OrdenFormSheet> createState() => _OrdenFormSheetState();
}

class _OrdenFormSheetState extends ConsumerState<OrdenFormSheet> {
  late final String _formId;
  late final String _formFechaSolicitud;
  OrdenProduccion? _ordenOriginal;

  final _productoBusquedaCtrl = TextEditingController();
  String? _productoSeleccionado;
  bool _showProductoDropdown = false;
  int _cantidad = 1;

  final List<ItemOrden> _items = [];
  EstadoOrden _estadoSeleccionado = EstadoOrden.pendiente;

  @override
  void initState() {
    super.initState();
    if (widget.esEdicion) {
      final ordenes = ref.read(ordenesProduccionProvider);
      _ordenOriginal = ordenes.firstWhere((o) => o.id == widget.ordenId);
      _formId = _ordenOriginal!.id;
      _formFechaSolicitud = _ordenOriginal!.fechaSolicitud;
      _items.addAll(_ordenOriginal!.items.map((i) => i.copyWith()));
      _estadoSeleccionado = _ordenOriginal!.estado;
    } else {
      _formId = ref.read(ordenesProduccionProvider.notifier).siguienteId();
      _formFechaSolicitud = fechaHoraActualFormateada();
    }
  }

  @override
  void dispose() {
    _productoBusquedaCtrl.dispose();
    super.dispose();
  }

  void _agregarProducto(String nombre) {
    setState(() {
      final idx = _items.indexWhere((i) => i.nombre == nombre);
      if (idx != -1) {
        _items[idx] = _items[idx].copyWith(cantidad: _items[idx].cantidad + _cantidad);
      } else {
        _items.add(ItemOrden(nombre: nombre, cantidad: _cantidad));
      }
      _productoBusquedaCtrl.clear();
      _productoSeleccionado = null;
      _cantidad = 1;
      _showProductoDropdown = false;
    });
  }

  void _quitarProducto(String nombre) {
    setState(() => _items.removeWhere((i) => i.nombre == nombre));
  }

  void _actualizarCantidad(String nombre, int nuevaCantidad) {
    if (nuevaCantidad <= 0) return _quitarProducto(nombre);
    setState(() {
      final idx = _items.indexWhere((i) => i.nombre == nombre);
      if (idx != -1) _items[idx] = _items[idx].copyWith(cantidad: nuevaCantidad);
    });
  }

  void _confirmar() {
    if (_items.isEmpty) return;
    final notifier = ref.read(ordenesProduccionProvider.notifier);
    if (widget.esEdicion) {
      notifier.actualizarItemsYEstado(_formId, List.of(_items), _estadoSeleccionado);
    } else {
      final usuario = ref.read(usuarioActualProduccionProvider);
      notifier.registrarOrden(
        OrdenProduccion(
          id: _formId,
          origen: OrigenOrden.manual,
          items: List.of(_items),
          fechaSolicitud: _formFechaSolicitud,
          estado: EstadoOrden.pendiente,
          generadoPor: usuario,
        ),
      );
    }
    Navigator.of(context).pop();
  }

  /// Vista previa de la fecha de fabricación al editar: si se selecciona
  /// "completado" y la orden aún no tenía fecha, muestra lo que quedaría
  /// al guardar (el campo no es editable directamente).
  String get _fechaFabricacionPreview {
    final original = _ordenOriginal;
    if (original == null) return '';
    if (original.fechaFabricacion.isNotEmpty) return original.fechaFabricacion;
    return _estadoSeleccionado == EstadoOrden.completado ? fechaHoraActualFormateada() : '';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final catalogo = ref.watch(catalogoProductosProduccionProvider);
    final usuario = widget.esEdicion
        ? _ordenOriginal!.generadoPor
        : ref.watch(usuarioActualProduccionProvider);

    final productosFiltrados = catalogo
        .where((p) => p.toLowerCase().contains(_productoBusquedaCtrl.text.toLowerCase()))
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Encabezado con datos de la orden
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.surface2,
              border: Border.all(color: colors.border),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                _InfoRow(label: 'ID de orden', value: _formId, mono: true),
                const SizedBox(height: 6),
                _InfoRow(label: 'Fecha solicitud', value: _formFechaSolicitud),
                const SizedBox(height: 6),
                _InfoRow(
                  label: 'Fecha fabricación',
                  value: widget.esEdicion
                      ? (_fechaFabricacionPreview.isEmpty ? 'Por definir' : _fechaFabricacionPreview)
                      : 'Por definir',
                  italic: widget.esEdicion ? _fechaFabricacionPreview.isEmpty : true,
                ),
                if (!widget.esEdicion) ...[
                  const SizedBox(height: 6),
                  const _InfoRow(label: 'Estado', value: 'Pendiente'),
                ],
                const SizedBox(height: 6),
                _InfoRow(
                  label: widget.esEdicion && _ordenOriginal!.origen == OrigenOrden.pagina
                      ? 'Solicitado por'
                      : 'Generado por',
                  value: usuario.nombre,
                ),
                const SizedBox(height: 6),
                _InfoRow(label: 'NIT/Cédula', value: usuario.documento),
              ],
            ),
          ),

          if (widget.esEdicion) ...[
            const SizedBox(height: 16),
            _Label('ESTADO'),
            const SizedBox(height: 6),
            _EstadoDropdown(
              value: _estadoSeleccionado,
              onChanged: (v) => setState(() => _estadoSeleccionado = v),
            ),
            if (_ordenOriginal!.origen == OrigenOrden.pagina && _ordenOriginal!.ventaId != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: colors.surface2,
                  border: Border.all(color: colors.border),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Venta relacionada',
                        style: AppTextStyles.caption.copyWith(color: colors.textMuted)),
                    Text(_ordenOriginal!.ventaId!,
                        style: AppTextStyles.monoCaption.copyWith(color: colors.text)),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            const AppDivider(),
          ],

          const SizedBox(height: 16),
          _Label('AGREGAR PRODUCTOS'),
          const SizedBox(height: 6),
          Focus(
            onFocusChange: (focused) => setState(() => _showProductoDropdown = focused),
            child: Container(
              decoration: BoxDecoration(
                color: colors.surface2,
                border: Border.all(color: colors.border),
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: _productoBusquedaCtrl,
                onChanged: (v) => setState(() {
                  _productoSeleccionado = null;
                  _showProductoDropdown = true;
                }),
                style: AppTextStyles.bodyRegular.copyWith(color: colors.text),
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: 'Buscar producto...',
                  hintStyle: AppTextStyles.bodyRegular.copyWith(color: colors.textMuted),
                ),
              ),
            ),
          ),
          if (_showProductoDropdown)
            Container(
              margin: const EdgeInsets.only(top: 4),
              constraints: const BoxConstraints(maxHeight: 176),
              decoration: BoxDecoration(
                color: colors.surface2,
                border: Border.all(color: colors.border),
                borderRadius: BorderRadius.circular(14),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: productosFiltrados.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text('Sin resultados',
                            style: AppTextStyles.caption.copyWith(color: colors.textMuted)),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: productosFiltrados
                              .map(
                                (p) => InkWell(
                                  onTap: () => setState(() {
                                    _productoSeleccionado = p;
                                    _productoBusquedaCtrl.text = p;
                                    _showProductoDropdown = false;
                                  }),
                                  child: Container(
                                    color: _productoSeleccionado == p ? colors.border : null,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 10),
                                    child: Text(p,
                                        style:
                                            AppTextStyles.caption.copyWith(color: colors.text)),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
              ),
            ),
          const SizedBox(height: 10),
          Row(
            children: [
              _StepperControl(value: _cantidad, onChanged: (v) => setState(() => _cantidad = v)),
              const Spacer(),
              _MiniButton(
                label: '+ Agregar',
                enabled: _productoSeleccionado != null,
                onTap: () {
                  if (_productoSeleccionado != null) _agregarProducto(_productoSeleccionado!);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

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
                      style: AppTextStyles.caption
                          .copyWith(color: colors.textMuted, fontWeight: FontWeight.w600),
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
                                  child: Text(
                                    item.nombre,
                                    style: AppTextStyles.captionBold.copyWith(color: colors.text),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                _StepperControl(
                                  compact: true,
                                  value: item.cantidad,
                                  onChanged: (v) => _actualizarCantidad(item.nombre, v),
                                ),
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  icon: Icon(Icons.close, size: 16, color: colors.danger),
                                  onPressed: () => _quitarProducto(item.nombre),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _items.isEmpty ? null : _confirmar,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.accent,
                foregroundColor: colors.accentFg,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text('Ordenar', style: AppTextStyles.bodyBold.copyWith(color: colors.accentFg)),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- Helpers de UI internos del formulario ----------

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool mono;
  final bool italic;
  const _InfoRow({required this.label, required this.value, this.mono = false, this.italic = false});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final base = mono ? AppTextStyles.monoCaption : AppTextStyles.caption;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.caption.copyWith(color: colors.textMuted)),
        Text(
          value,
          style: base.copyWith(
            color: italic ? colors.textMuted : colors.text,
            fontStyle: italic ? FontStyle.italic : FontStyle.normal,
          ),
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Text(text, style: AppTextStyles.tiny.copyWith(color: colors.textMuted, letterSpacing: 0.4));
  }
}

class _EstadoDropdown extends StatelessWidget {
  final EstadoOrden value;
  final ValueChanged<EstadoOrden> onChanged;
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
        child: DropdownButton<EstadoOrden>(
          value: value,
          isExpanded: true,
          style: AppTextStyles.bodyRegular.copyWith(color: colors.text),
          dropdownColor: colors.surface2,
          items: EstadoOrden.values
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
            child: Text('$value',
                textAlign: TextAlign.center,
                style: AppTextStyles.monoCaption.copyWith(color: colors.text)),
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
