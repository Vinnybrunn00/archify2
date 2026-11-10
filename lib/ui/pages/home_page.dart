import 'package:archify2/core/factory/file_manager.dart';
import 'package:archify2/core/providers/file_system_provider.dart';
import 'package:archify2/ui/components/animated/animated_path.dart';
import 'package:archify2/ui/components/box_file_folder.dart';
import 'package:archify2/ui/components/empty_folder.dart';
import 'package:archify2/ui/themes/app_colors.dart';
import 'package:iconsx_plus/iconsx_plus.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

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
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.backgroundColorWhite,
        surfaceTintColor: Colors.transparent,
        leading: provider.canGoBack
            ? GestureDetector(
                onTap: () => provider.goBackFolders(),
                child: const Icon(BoxIcons.bx_arrow_back),
              )
            : null,
        title: Text(
          'Archify',
          style: TextStyle(fontSize: 23),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
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
                GestureDetector(
                  onTap: () async => await provider.createFolder('nova-pasta2'),

                  child: Icon(EvaIcons.folder_add_outline, size: 19),
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
