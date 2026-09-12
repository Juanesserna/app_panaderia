import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_modules.dart';

/// Notifier para controlar el módulo/pantalla actualmente visible.
class CurrentModuleNotifier extends Notifier<AppModule> {
  @override
  AppModule build() => AppModule.dashboard;

  void setModule(AppModule module) {
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