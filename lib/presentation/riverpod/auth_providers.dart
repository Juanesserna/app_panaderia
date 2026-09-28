import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_roles.dart';

/// Usuario autenticado en la sesión actual.
class AuthUser {
  final String nombre;
  final String correo;
  final AppRole rol;
  const AuthUser({required this.nombre, required this.correo, required this.rol});
}

class _CredencialMock {
  final String correo;
  final String password;
  final AuthUser usuario;
  const _CredencialMock({required this.correo, required this.password, required this.usuario});
}

// Usuarios genéricos mientras no haya backend. Un usuario por rol,
// suficiente para demostrar el control de acceso.
const _kUsuariosMock = [
  _CredencialMock(
    correo: 'panadero@alhorno.com',
    password: 'panadero123',
    usuario: AuthUser(nombre: 'Panadero Al Horno', correo: 'panadero@alhorno.com', rol: AppRole.panadero),
  ),
  _CredencialMock(
    correo: 'vendedor@alhorno.com',
    password: 'vendedor123',
    usuario: AuthUser(nombre: 'Vendedor Al Horno', correo: 'vendedor@alhorno.com', rol: AppRole.vendedor),
  ),
  _CredencialMock(
    correo: 'gerente@alhorno.com',
    password: 'gerente123',
    usuario: AuthUser(nombre: 'Gerente Al Horno', correo: 'gerente@alhorno.com', rol: AppRole.gerente),
  ),
];

/// Sesión actual: `null` si nadie ha iniciado sesión.
class AuthNotifier extends Notifier<AuthUser?> {
  @override
  AuthUser? build() => null;

  /// Intenta iniciar sesión contra los usuarios mock. Devuelve `true` y
  /// deja la sesión activa si las credenciales son correctas.
  bool login(String correo, String password) {
    final correoNorm = correo.trim().toLowerCase();
    for (final c in _kUsuariosMock) {
      if (c.correo == correoNorm && c.password == password) {
        state = c.usuario;
        return true;
      }
    }
    return false;
  }

  void logout() => state = null;
}

final authProvider = NotifierProvider<AuthNotifier, AuthUser?>(AuthNotifier.new);