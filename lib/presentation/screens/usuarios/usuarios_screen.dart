import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../widgets/common/common_ui.dart';
import '../../widgets/shell/app_bottom_sheet.dart';
import '../../widgets/usuarios/usuario_tile.dart';
import '../../widgets/usuarios/usuario_status_badge.dart';
import '../../widgets/usuarios/filtros_usuarios_panel.dart';
import '../../widgets/usuarios/detalle_usuario_sheet.dart';
import '../../widgets/usuarios/nuevo_usuario_sheet.dart';
import '../../widgets/usuarios/editar_usuario_sheet.dart';

/// Página de contenido del módulo Usuarios.
class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({super.key});

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  bool _mostrarFiltros = false;
  String _busqueda = '';
  RolUsuario? _rolFiltro;
  EstadoUsuario? _estadoFiltro;

  // Ahora es una lista mutable en el estado (antes era `final _usuarios` a
  // nivel de archivo) para poder cambiar el estado activo/inactivo al
  // tocar el ícono de personita, sin tocar lógica real de nadie.
  final List<Usuario> _usuarios = List.of(_usuariosIniciales);

  List<Usuario> get _usuariosFiltrados {
    return _usuarios.where((u) {
      final coincideBusqueda = _busqueda.isEmpty ||
          u.nombre.toLowerCase().contains(_busqueda.toLowerCase()) ||
          u.email.toLowerCase().contains(_busqueda.toLowerCase());
      final coincideRol = _rolFiltro == null || u.rol == _rolFiltro;
      final coincideEstado = _estadoFiltro == null || u.estado == _estadoFiltro;
      return coincideBusqueda && coincideRol && coincideEstado;
    }).toList();
  }

  void _toggleEstado(Usuario u) {
    final index = _usuarios.indexOf(u);
    if (index == -1) return;
    final nuevoEstado = u.estado == EstadoUsuario.activo ? EstadoUsuario.inactivo : EstadoUsuario.activo;
    setState(() => _usuarios[index] = u.copyWith(estado: nuevoEstado));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(nuevoEstado == EstadoUsuario.activo ? 'Usuario habilitado' : 'Usuario inhabilitado')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final usuarios = _usuariosFiltrados;

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 96),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    AppSearchField(
                      placeholder: 'Buscar usuario...',
                      onChanged: (v) => setState(() => _busqueda = v),
                    ),
                    const SizedBox(width: 10),
                    _FilterIconButton(
                      active: _mostrarFiltros,
                      onTap: () => setState(() => _mostrarFiltros = !_mostrarFiltros),
                    ),
                  ],
                ),
              ),
              if (_mostrarFiltros) ...[
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: FiltrosUsuariosPanel(
                    rolSeleccionado: _rolFiltro,
                    estadoSeleccionado: _estadoFiltro,
                    onRolChanged: (v) => setState(() => _rolFiltro = v),
                    onEstadoChanged: (v) => setState(() => _estadoFiltro = v),
                    onLimpiar: () => setState(() {
                      _rolFiltro = null;
                      _estadoFiltro = null;
                    }),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'EQUIPO',
                  style: AppTextStyles.captionBold.copyWith(color: colors.textMuted, letterSpacing: 0.5),
                ),
              ),
              const SizedBox(height: 4),
              ...usuarios.map((u) {
                final last = u == usuarios.last;
                return Column(
                  children: [
                    UsuarioTile(
                      usuario: u,
                      onView: () {
                        showAppBottomSheet(
                          context,
                          title: u.nombre,
                          builder: (_) => DetalleUsuarioSheet(usuario: u),
                        );
                      },
                      onEdit: () {
                        showAppBottomSheet(
                          context,
                          title: 'Editar usuario',
                          builder: (_) => EditarUsuarioSheet(usuario: u),
                        );
                      },
                      onToggleEstado: () => _toggleEstado(u),
                    ),
                    if (!last) const AppDivider(),
                  ],
                );
              }),
            ],
          ),
        ),
        Positioned(
          right: 16,
          bottom: 10,
          child: _NuevoUsuarioFab(
            onTap: () async {
            final nuevoUsuario = await showAppBottomSheet<Usuario>(
            context,
            title: 'Nuevo usuario',
            builder: (_) => const NuevoUsuarioSheet(),
           );

           if (nuevoUsuario != null && mounted) {
           setState(() {
           _usuarios.add(nuevoUsuario);
          });

                  ScaffoldMessenger.of(context).showSnackBar(
                 const SnackBar(
                 content: Text('Usuario creado correctamente'),
                 ),
               );
              }
            },
          ),
        ),
      ],
    );
  }
}

const _usuariosIniciales = [
  Usuario(
    nit: '52341234',
    nombre: 'Juan Carlos Díaz',
    email: 'jdiaz@alhorno.co',
    telefono: '310 123 4567',
    rol: RolUsuario.gerente,
    estado: EstadoUsuario.activo,
    permisos: [
      'Dashboard', 'Ventas', 'Producción', 'Insumos', 'Compras',
      'Proveedores', 'Categorías', 'Productos', 'Usuarios', 'Roles',
    ],
  ),
  Usuario(
    nit: '43876521',
    nombre: 'Sara Lucía Muñoz',
    email: 'smunoz@alhorno.co',
    telefono: '311 456 7890',
    rol: RolUsuario.vendedor,
    estado: EstadoUsuario.activo,
    permisos: ['Dashboard', 'Ventas'],
  ),
  Usuario(
    nit: '39012345',
    nombre: 'Pedro Torres Ríos',
    email: 'ptorres@alhorno.co',
    telefono: '312 789 0123',
    rol: RolUsuario.panadero,
    estado: EstadoUsuario.activo,
    permisos: ['Dashboard', 'Producción', 'Insumos'],
  ),
  Usuario(
    nit: '48765432',
    nombre: 'Diana Rincón Caro',
    email: 'drincon@alhorno.co',
    telefono: '313 234 5678',
    rol: RolUsuario.vendedor,
    estado: EstadoUsuario.inactivo,
    permisos: ['Dashboard', 'Ventas'],
  ),
];

// fondo SIEMPRE blanco/borde (nunca relleno naranja) + ícono correcto
// (filter_alt_outlined, el embudo de tu imagen en vez de filter_list).
class _FilterIconButton extends StatelessWidget {
  final bool active;
  final VoidCallback onTap;
  const _FilterIconButton({required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: active ? colors.accent : colors.border),
          ),
          child: Icon(Icons.filter_alt_outlined, size: 20, color: active ? colors.accent : colors.text),
        ),
      ),
    );
  }
}

class _NuevoUsuarioFab extends StatelessWidget {
  final VoidCallback onTap;
  const _NuevoUsuarioFab({required this.onTap});

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
              Text('Nuevo usuario', style: TextStyle(color: colors.accentFg, fontWeight: FontWeight.w600, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}