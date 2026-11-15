import 'dart:io';

import 'package:archify2/archify2/archify2.dart';
import 'package:material_ui/material_ui.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // setta o gerenciamento de janela somente para Desktop(linux/windows)
  if (Platform.isWindows || Platform.isLinux) {
    await _setWindowManager();
  }

  // Archify2 em lib/archify2/archify2.dart
  runApp(const Archify2());
}

Future<void> _setWindowManager() async {
  await windowManager.ensureInitialized();

  const Size size = Size(1080, 860);

  final WindowOptions options = WindowOptions(
    size: size,
    minimumSize: size,
    maximumSize: size,
    alwaysOnTop: true,
    center: true,
    titleBarStyle: Platform.isWindows ? TitleBarStyle.hidden : null,
    backgroundColor: Platform.isWindows ? Colors.transparent : null,
  );

  await windowManager.waitUntilReadyToShow(options, () async {
    await windowManager.setMaximizable(false);
    if (Platform.isWindows) {
      await windowManager.setAsFrameless();
      await windowManager.setHasShadow(false);
    }
    await windowManager.show();
    await windowManager.focus();
  });
}
