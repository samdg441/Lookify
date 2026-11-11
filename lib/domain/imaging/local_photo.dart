/// A photo that already lives on the device. The domain keeps the path
/// and leaves file-system types to the adapters.
class LocalPhoto {
  const LocalPhoto(this.path);

  final String path;
}
