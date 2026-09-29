import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_modules.dart';
import '../../core/constants/app_roles.dart';
import 'auth_providers.dart';

/// Notifier para controlar el módulo/pantalla actualmente visible.
class CurrentModuleNotifier extends Notifier<AppModule> {
  @override
  AppModule build() => AppModule.dashboard;

  /// Cambia de módulo. Si hay una sesión activa y el rol no tiene acceso
  /// a ese módulo, el cambio se ignora (defensa extra: la UI ya filtra
  /// las opciones, pero esto evita que algo quede accesible por error).
  void setModule(AppModule module) {
    final usuario = ref.read(authProvider);
    if (usuario != null && !usuario.rol.modulosPermitidos.contains(module)) {
      return;
    }
    state = module;
  }
}

final currentModuleProvider =
    NotifierProvider<CurrentModuleNotifier, AppModule>(
      CurrentModuleNotifier.new,
    );

/// Notifier para controlar el tema claro/oscuro global.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.light;

  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  void setTheme(ThemeMode mode) {
    state = mode;
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);