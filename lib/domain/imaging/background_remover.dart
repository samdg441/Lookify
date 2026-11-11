import 'local_photo.dart';

abstract interface class BackgroundRemover {
  bool get isSupported;

  Future<LocalPhoto> removeBackground(LocalPhoto image);

  Future<List<LocalPhoto>> removeBackgroundBatch(List<LocalPhoto> images);
}
