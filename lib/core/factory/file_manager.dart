import 'dart:io';

class FileManager {
  final String path;
  final String name;
  final bool isDirectory;
  final bool isFile;
  final String? sizeFile;
  final int? itemCount;
  final String modifiedAt;

  FileManager({
    required this.path,
    required this.name,
    required this.isDirectory,
    required this.isFile,
    this.sizeFile,
    this.itemCount,
    required this.modifiedAt,
  });

  factory FileManager.fromFileSystemEntity({
    required FileSystemEntity fileSystemEntity,
  }) {
    final FileStat fileStat = fileSystemEntity.statSync();

    return FileManager(
      path: fileSystemEntity.path,
      name: _formatPath(fileSystemEntity.path),
      isDirectory: _isDirectory(fileStat),
      isFile: _isFile(fileStat),
      sizeFile: _fileSize(fileStat),
      itemCount: _itemCount(fileSystemEntity, fileStat),
      modifiedAt: _formatModified(fileStat),
    );
  }

  static String _formatPath(String path) {
    return path.split('/').last;
  }

  static bool _isDirectory(FileStat fileStats) {
    return fileStats.type == FileSystemEntityType.directory;
  }

  static bool _isFile(FileStat fileStats) {
    return fileStats.type == FileSystemEntityType.file;
  }

  static String? _fileSize(FileStat fileStats) {
    if (_isDirectory(fileStats)) return null;

    const List<String> units = ['B', 'KB', 'MB', 'GB', 'TB'];
    double size = fileStats.size.toDouble();
    int unitIndex = 0;

    while ((size >= 1024) && (unitIndex < units.length - 1)) {
      size /= 1024;
      unitIndex++;
    }

    final String formatted = unitIndex == 0
        ? size.toInt().toString()
        : size.toStringAsFixed(1);

    return '$formatted ${units[unitIndex]}';
  }

  static int? _itemCount(FileSystemEntity entity, FileStat fileStats) {
    if (!_isDirectory(fileStats)) return null;

    final Directory directory = Directory(entity.path);

    return directory.listSync().length;
  }

  static String _formatModified(FileStat fileStats) {
    final DateTime now = DateTime.now();

    final DateTime today = DateTime.utc(now.year, now.month, now.day);

    final DateTime day = DateTime.utc(
      fileStats.modified.year,
      fileStats.modified.month,
      fileStats.modified.day,
    );

    final int diffDays = today.difference(day).inDays;

    final String hour =
        '${fileStats.modified.hour.toString().padLeft(2, '0')}:'
        '${fileStats.modified.minute.toString().padLeft(2, '0')}';

    if (diffDays <= 0) return 'Hoje, $hour';
    if (diffDays == 1) return 'Ontem, $hour';
    if (diffDays == 2) return 'Anteontem';
    if (diffDays < 7) return 'Há $diffDays dias';

    final String date =
        '${fileStats.modified.day.toString().padLeft(2, '0')}/'
        '${fileStats.modified.month.toString().padLeft(2, '0')}/'
        '${fileStats.modified.year}';

    return '$date - $hour';
  }
}
