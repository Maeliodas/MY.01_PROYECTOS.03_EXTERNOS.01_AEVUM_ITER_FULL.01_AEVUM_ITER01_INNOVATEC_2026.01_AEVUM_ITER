import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'local_image_io.dart'
    if (dart.library.js_interop) 'local_image_web.dart' as impl;

/// ¿Es foto local (galería/cámara) y no asset empaquetado?
bool isLocalPhoto(String path) {
  if (kIsWeb) return !path.startsWith('assets/');
  return path.startsWith('/') || path.contains('emulated');
}

/// Imagen de foto local (galería/cámara): archivo en móvil, blob-URL en web.
Widget localImage(String path, {double iconSize = 88}) =>
    impl.localImage(path, iconSize: iconSize);
