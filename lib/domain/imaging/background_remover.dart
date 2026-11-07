import 'dart:io';

abstract interface class BackgroundRemover {
  bool get isSupported;

  Future<File> removeBackground(File image);

  Future<List<File>> removeBackgroundBatch(List<File> images);
}
