import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'presentation/riverpod/shell_providers.dart';
import 'presentation/widgets/shell/app_shell.dart';

void main() {
  runApp(const ProviderScope(child: AlHornoApp()));
}

class AlHornoApp extends ConsumerWidget {
  const AlHornoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      title: 'AlHorno',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      home: const AppShell(),
    );
  }
}
