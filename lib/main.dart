import 'dart:io';

import 'package:archify2/archify2/archify2.dart';
import 'package:material_ui/material_ui.dart';
import 'package:window_manager/window_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // setta o gerenciamento de janela somente para Desktop(linux/windows)
  if (Platform.isWindows || Platform.isLinux) {
    _setWindowManager();
  }

  // Archify2 em lib/archify2/archify2.dart
  runApp(const Archify2());
}

void _setWindowManager() {
  final Window? window = WindowManager.instance.getCurrent();

  final Size size = Size(1080, 860);

  window?.setSize(size.toNative(), false);
  window?.minimumSize = size.toNative();
  window?.maximumSize = size.toNative();
  window?.isAlwaysOnTop = true;
  window?.isMaximizable = false;
  if (Platform.isWindows) {
    window?.titleBarStyle = TitleBarStyle.hidden;
    window?.setFrameless(true);
    window?.hasShadow = false;
    window?.backgroundColor = Colors.transparent.toNative();
  }
  window?.center();
  window?.show();
  window?.focus();
}
