import 'dart:io';

import 'package:archify2/core/constants/regex_patterns.dart';
import 'package:archify2/core/models/file_types.dart';
import 'package:archify2/ui/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsx_plus/iconsx_plus.dart';

class FileManager {
  final String path;
  final IconData icon;
  final Color? iconColor;
  final String name;
  final bool isDirectory;
  final bool isFile;
  final String? sizeFile;
  final int? itemCount;
  final String modifiedAt;

  FileManager({
    required this.path,
    required this.icon,
    this.iconColor,
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
      icon: _showIconsTypeFileAndFolder(fileStat, path),
      iconColor: _switchIconColor(fileStat, path),
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

  static IconData _showIconsTypeFileAndFolder(FileStat fileStats, String path) {
    final FileTypes fileTypes = _fileTypes(path);

    if (fileStats.type == FileSystemEntityType.file) {
      return _switchIconFiles(fileTypes);
    }

    return BoxIcons.bxs_folder;
  }

  static IconData _switchIconFiles(FileTypes fileTypes) {
    if (fileTypes.isWord) {
      return AntDesign.file_word_outline;
    }

    if (fileTypes.isCode) {
      return LineAwesome.file_code;
    }

    if (fileTypes.isAudio) {
      return EvaIcons.music_outline;
    }

    if (fileTypes.isVideo) {
      return EvaIcons.video_outline;
    }

    if (fileTypes.isText) {
      return AntDesign.file_text_outline;
    }

    if (fileTypes.isPdf) {
      return AntDesign.file_pdf_outline;
    }

    if (fileTypes.isImage) {
      return AntDesign.file_image_fill;
    }

    return EvaIcons.question_mark;
  }

  static Color? _switchIconColor(FileStat fileStats, String path) {
    final FileTypes fileTypes = _fileTypes(path);

    if (fileStats.type == FileSystemEntityType.directory) {
      return AppColor.cyanColor;
    }

    if (fileTypes.isWord) {
      return AppColor.blackBlue;
    }

    if (fileTypes.isCode) {
      return AppColor.greenColor;
    }

    if (fileTypes.isAudio) {
      return AppColor.purpleColor;
    }

    if (fileTypes.isVideo) {
      return AppColor.pinkColor;
    }

    if (fileTypes.isText) {
      return AppColor.blackColor;
    }

    if (fileTypes.isPdf) {
      return AppColor.redColor;
    }

    if (fileTypes.isImage) {
      return const Color(0xFF8C00FF);
    }

    return AppColor.greyColor;
  }
}
