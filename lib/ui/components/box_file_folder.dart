import 'dart:io';

import 'package:archify2/core/factory/file_manager.dart';
import 'package:archify2/ui/components/icon_file_folder.dart';
import 'package:iconsx_plus/iconsx_plus.dart';
import 'package:material_ui/material_ui.dart';

class BoxFileAndFolder extends StatelessWidget {
  final FileManager fileManager;
  final VoidCallback? onTap;

  const BoxFileAndFolder({super.key, required this.fileManager, this.onTap});

  bool get _isDesktop => Platform.isLinux || Platform.isWindows;

  String? get _details {
    if (fileManager.isDirectory && fileManager.itemCount != null) {
      final int count = fileManager.itemCount!;
      return '$count ${count == 1 ? 'item' : 'itens'}';
    }
    return fileManager.sizeFile;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: .circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Color(0xffFFFFFF),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const .symmetric(horizontal: 12, vertical: 10),
            child: Row(
              spacing: 12,
              children: [
                IconFileAndFolder(isDirectory: fileManager.isDirectory),
                Expanded(
                  child: Column(
                    mainAxisSize: .min,
                    crossAxisAlignment: .start,
                    spacing: 2,
                    children: [
                      Text(
                        fileManager.name,
                        style: TextStyle(fontSize: _isDesktop ? 16 : 18),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      if (!_isDesktop)
                        Text(
                          [fileManager.modifiedAt, ?_details].join('  •  '),
                          style: TextStyle(
                            color: Colors.black.withAlpha(150),
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),

                if (_isDesktop) ...[
                  SizedBox(
                    width: 90,
                    child: Text(
                      _details ?? '',
                      style: TextStyle(
                        color: Colors.black.withAlpha(150),
                        fontSize: 15.5,
                        fontWeight: .w600,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: Text(
                      fileManager.modifiedAt,
                      style: TextStyle(
                        color: Colors.black.withAlpha(150),
                        fontSize: 15.5,
                        fontWeight: .w600,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],

                if (fileManager.isDirectory)
                  Icon(BoxIcons.bx_chevron_right, color: Colors.green)
                else
                  const SizedBox(width: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
