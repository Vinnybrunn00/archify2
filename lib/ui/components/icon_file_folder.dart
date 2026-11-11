import 'package:archify2/core/factory/file_manager.dart';
import 'package:material_ui/material_ui.dart';

class IconFileAndFolder extends StatelessWidget {
  final FileManager fileManager;

  const IconFileAndFolder({super.key, required this.fileManager});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: fileManager.iconColor?.withAlpha(50),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(fileManager.icon, color: fileManager.iconColor),
    );
  }
}
