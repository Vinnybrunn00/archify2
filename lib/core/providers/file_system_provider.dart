import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:path_provider/path_provider.dart';

class FileSystemProvider with ChangeNotifier {
  FileSystemProvider() {
    listFoldersAndFiles();
  }

  List<FileSystemEntity> _entities = [];
  List<FileSystemEntity> get entities => _entities;

  String? _currentPath;
  String? get currentPath => _currentPath;

  String? _rootPath;
  String? get rootPath => _rootPath;
  bool get canGoBack => (_currentPath != null) && (_currentPath != _rootPath);

  void listFoldersAndFiles([String? path]) async {
    final Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getDownloadsDirectory();

    /// if (_rootPath == null) {
    ///   _rootPath = directory!.path;
    /// {
    _rootPath ??= directory?.path;

    final String rootPath = path ?? _rootPath!;

    final Directory dicFiles = Directory(rootPath);
    final List<FileSystemEntity> entities = dicFiles.listSync();

    entities.sort((FileSystemEntity a, FileSystemEntity b) {
      final DateTime aDate = a.statSync().modified;
      final DateTime bDate = b.statSync().modified;
      return bDate.compareTo(aDate);
    });

    _entities = entities;
    _currentPath = rootPath;
    notifyListeners();
  }

  void goBackFolders() {
    if (!canGoBack) return;
    final Directory directory = Directory(_currentPath!);
    listFoldersAndFiles(directory.parent.path);
  }

  Future<void> createFolder(String newFolder) async {
    final Directory directory = Directory('$_currentPath/$newFolder');
    await directory.create();

    if (_currentPath != null) {
      listFoldersAndFiles(_currentPath);
    }
  }

  String? get showRelativePath {
    if (_currentPath == null) return null;

    if (_rootPath != null && _currentPath!.startsWith(_rootPath!)) {
      final String pathSeparator = Platform.pathSeparator;

      return '$pathSeparator${_currentPath?.substring(_rootPath!.length)}'
          .replaceFirst('$pathSeparator$pathSeparator', pathSeparator);
    }

    return _currentPath;
  }
}
