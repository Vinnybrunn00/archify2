import 'dart:io';

import 'package:archify2/core/constants/regex_patterns.dart';
import 'package:archify2/core/models/file_types.dart';
import 'package:archify2/core/models/icon_color_from_file.dart';
import 'package:archify2/ui/themes/app_colors.dart';
import 'package:iconsx_plus/iconsx_plus.dart';
import 'package:material_ui/material_ui.dart';

class FileManager {
  final String path;
  final IconColorFromFile iconDetails;
  final String name;
  final bool isDirectory;
  final bool isFile;
  final String? sizeFile;
  final int? itemCount;
  final String modifiedAt;

  FileManager({
    required this.path,
    required this.iconDetails,
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
    final String path = fileSystemEntity.path;

    return FileManager(
      path: path,
      iconDetails: _showIconsTypeFileAndFolder(fileStat, path),
      name: _formatPath(path),
      isDirectory: _isDirectory(fileStat),
      isFile: _isFile(fileStat),
      sizeFile: _fileSize(fileStat),
      itemCount: _itemCount(path, fileStat),
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

  static int? _itemCount(String path, FileStat fileStats) {
    if (!_isDirectory(fileStats)) return null;

    final Directory directory = Directory(path);

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

  static FileTypes _fileTypes(String path) => FileTypes(
    isImage: imageExtensions.hasMatch(path),
    isPdf: pdfExtRegex.hasMatch(path),
    isVideo: videoExtRegex.hasMatch(path),
    isAudio: audioExtRegex.hasMatch(path),
    isText: textExtRegex.hasMatch(path),
    isCode: codeExtRegex.hasMatch(path),
    isWord: wordExtRegex.hasMatch(path),
  );

  static IconColorFromFile _showIconsTypeFileAndFolder(
    FileStat fileStats,
    String path,
  ) {
    final FileTypes fileTypes = _fileTypes(path);

    if (fileStats.type == FileSystemEntityType.file) {
      return _switchIconFiles(fileTypes);
    }

    return IconColorFromFile(
      icon: BoxIcons.bxs_folder,
      color: AppColor.cyanColor,
    );
  }

  static IconColorFromFile _switchIconFiles(FileTypes fileTypes) {
    if (fileTypes.isWord) {
      return IconColorFromFile(
        icon: AntDesign.file_word_outline,
        color: AppColor.blackColor,
      );
    }

    if (fileTypes.isCode) {
      return IconColorFromFile(
        icon: LineAwesome.file_code,
        color: AppColor.greenColor,
      );
    }

    if (fileTypes.isAudio) {
      return IconColorFromFile(
        icon: EvaIcons.music_outline,
        color: AppColor.purpleColor,
      );
    }

    if (fileTypes.isVideo) {
      return IconColorFromFile(
        icon: EvaIcons.video_outline,
        color: AppColor.pinkColor,
      );
    }

    if (fileTypes.isText) {
      return IconColorFromFile(
        icon: AntDesign.file_text_outline,
        color: AppColor.blackColor,
      );
    }

    if (fileTypes.isPdf) {
      return IconColorFromFile(
        icon: AntDesign.file_pdf_outline,
        color: AppColor.redColor,
      );
    }

    if (fileTypes.isImage) {
      return IconColorFromFile(
        icon: AntDesign.file_image_fill,
        color: Color(0xFF8C00FF),
      );
    }

    return IconColorFromFile(
      icon: EvaIcons.question_mark,
      color: AppColor.greyColor,
    );
  }
}
