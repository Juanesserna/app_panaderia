import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/roles_mock_datasource.dart';
import '../../data/repositories/rol_repository_impl.dart';
import '../../domain/entities/rol.dart';
import '../../domain/repositories/rol_repository.dart';

/// Repositorio del módulo de Roles. Hoy resuelve a la implementación en
/// memoria; el día que exista backend, cambiar esta línea es lo único
/// necesario (nada en la UI depende de la implementación concreta).
final rolRepositoryProvider = Provider<RolRepository>((ref) {
  return RolRepositoryImpl(datasource: const RolesMockDatasource());
});

/// Lista de roles + acciones para crear, editar, activar/desactivar o
/// eliminar un rol.
class RolesNotifier extends Notifier<List<Rol>> {
  @override
  List<Rol> build() => ref.watch(rolRepositoryProvider).obtenerRoles();

  /// Siguiente ID correlativo (05R, 06R, ...).
  String siguienteId() {
    final maxNum = state.fold<int>(0, (max, r) {
      final n = int.tryParse(r.id.replaceAll('R', '')) ?? 0;
      return n > max ? n : max;
    });
    return '${(maxNum + 1).toString().padLeft(2, '0')}R';
  }

  void crearRol(Rol rol) {
    ref.read(rolRepositoryProvider).crearRol(rol);
    state = [...state, rol];
  }

  void actualizarRol(Rol rol) {
    ref.read(rolRepositoryProvider).actualizarRol(rol);
    state = [for (final r in state) if (r.id == rol.id) rol else r];
  }

  /// Usado por el switch ACTIVO de la lista: invierte el estado actual.
  void alternarEstado(String id) {
    Rol? actualizado;
    state = [
      for (final r in state)
        if (r.id == id)
          actualizado = r.copyWith(
            estado: r.estado == EstadoRol.activo
                ? EstadoRol.inactivo
                : EstadoRol.activo,
          )
        else
          r,
    ];
    if (actualizado != null) {
      ref.read(rolRepositoryProvider).actualizarRol(actualizado);
    }
  }

  void eliminarRol(String id) {
    ref.read(rolRepositoryProvider).eliminarRol(id);
    state = state.where((r) => r.id != id).toList();
  }
}

final rolesProvider = NotifierProvider<RolesNotifier, List<Rol>>(
  RolesNotifier.new,
);