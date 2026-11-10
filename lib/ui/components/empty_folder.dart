

import 'package:iconsx_plus/iconsx_plus.dart';
import 'package:material_ui/material_ui.dart';

class EmptyFolder extends StatelessWidget {
  const EmptyFolder({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextTheme texts = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisSize: .min,
        spacing: 8,
        children: [
          Icon(BoxIcons.bx_folder_open, size: 64, color: colors.outline),
          Text('Pasta vazia', style: texts.titleMedium),
          Text(
            'Nenhum arquivo ou pasta por aqui.',
            style: texts.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
