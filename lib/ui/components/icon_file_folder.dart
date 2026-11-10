import 'package:iconsx_plus/iconsx_plus.dart';
import 'package:material_ui/material_ui.dart';

class IconFileAndFolder extends StatelessWidget {
  final bool isDirectory;

  const IconFileAndFolder({super.key, required this.isDirectory});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: isDirectory
            ? colors.primaryContainer
            : colors.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        isDirectory ? BoxIcons.bxs_folder : BoxIcons.bxs_file_blank,
        size: 24,
        color: isDirectory
            ? colors.onPrimaryContainer
            : colors.onSecondaryContainer,
      ),
    );
  }
}
