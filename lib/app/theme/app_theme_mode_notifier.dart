import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Estado global do tema. Inicia seguindo a preferência do sistema.
final appThemeModeProvider = NotifierProvider<AppThemeModeNotifier, ThemeMode>(
  AppThemeModeNotifier.new,
);

class AppThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  void useSystem() => state = ThemeMode.system;

  void useLight() => state = ThemeMode.light;

  void useDark() => state = ThemeMode.dark;
}
