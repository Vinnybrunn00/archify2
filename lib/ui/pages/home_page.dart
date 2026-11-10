import 'dart:io';

import 'package:archify2/core/factory/file_manager.dart';
import 'package:archify2/core/providers/file_system_provider.dart';
import 'package:archify2/ui/components/animated/animated_path.dart';
import 'package:archify2/ui/components/box_file_folder.dart';
import 'package:archify2/ui/components/empty_folder.dart';
import 'package:archify2/ui/themes/app_colors.dart';
import 'package:iconsx_plus/iconsx_plus.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

class HomePage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final FileSystemProvider provider = Provider.of<FileSystemProvider>(
      context,
    );

    return Scaffold(
      backgroundColor: AppColor.backgroundColorWhite,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColorWhite,
        title: Text(
          'Archify',
          style: TextStyle(fontSize: 23),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        leading: provider.canGoBack
            ? MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => provider.goBackFolders(),
                  child: const Icon(BoxIcons.bx_arrow_back),
                ),
              )
            : null,
        actions: [
          // mostra os botões de minizar e fechar a jenala somente no linux/windows.
          if (Platform.isLinux || Platform.isWindows) ...[
            _WindowButton(
              icon: Icons.remove,
              tooltip: 'Minimizar',
              onPressed: () => WindowManager.instance.getCurrent()?.minimize(),
            ),
            SizedBox(width: 5),
            _WindowButton(
              icon: Icons.close,
              tooltip: 'Fechar',
              onPressed: () => WindowManager.instance.getCurrent()?.close(),
            ),
          ],
        ],
        actionsPadding: .only(right: 15),
      ),

      body: Column(
        crossAxisAlignment: .stretch,
        children: [
          Padding(
            padding: const .fromLTRB(20, 0, 20, 0),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              spacing: 12,
              children: [
                if (provider.showRelativePath != null)
                  Expanded(
                    child: AnimatedPath(path: provider.showRelativePath!),
                  ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () async =>
                        await provider.createFolder('nova-pasta2'),

                    child: Icon(EvaIcons.folder_add_outline, size: 19),
                  ),
                ),
              ],
            ),
          ),

          Expanded(child: _buildBody(context, provider)),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, FileSystemProvider provider) {
    if (provider.currentPath == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.entities.isEmpty) {
      return const EmptyFolder();
    }

    return ListView.separated(
      padding: const .fromLTRB(12, 8, 12, 96),
      itemCount: provider.entities.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final FileManager fileManager = FileManager.fromFileSystemEntity(
          fileSystemEntity: provider.entities[index],
        );

        return BoxFileAndFolder(
          fileManager: fileManager,
          onTap: fileManager.isDirectory
              ? () => provider.listFoldersAndFiles(fileManager.path)
              : null,
        );
      },
    );
  }
}

class _WindowButton extends StatelessWidget {
  const _WindowButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            width: 36,
            height: 36,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: AppColor.blackColorAlpha55.withAlpha(10),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: AppColor.backgroundColorBlack),
          ),
        ),
      ),
    );
  }
}
