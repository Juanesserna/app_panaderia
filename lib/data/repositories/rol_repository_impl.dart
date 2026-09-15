import '../../domain/entities/rol.dart';
import '../../domain/repositories/rol_repository.dart';
import '../datasources/roles_mock_datasource.dart';

/// Implementación en memoria de [RolRepository]. Simula persistencia
/// durante la sesión de la app (vive en una lista mutable); no sobrevive
/// a un reinicio. Cuando haya backend, se reemplaza por una
/// implementación que llame a la API/DB sin tocar providers ni UI.
class RolRepositoryImpl implements RolRepository {
  final RolesMockDatasource _datasource;
  late final List<Rol> _roles;

  RolRepositoryImpl({
    RolesMockDatasource datasource = const RolesMockDatasource(),
  }) : _datasource = datasource {
    _roles = List.of(_datasource.rolesIniciales());
  }

  @override
  List<Rol> obtenerRoles() => List.unmodifiable(_roles);

  @override
  void crearRol(Rol rol) {
    _roles.add(rol);
  }

  @override
  void actualizarRol(Rol rol) {
    final i = _roles.indexWhere((r) => r.id == rol.id);
    if (i != -1) _roles[i] = rol;
  }

  @override
  void eliminarRol(String id) {
    _roles.removeWhere((r) => r.id == id);
  }
}