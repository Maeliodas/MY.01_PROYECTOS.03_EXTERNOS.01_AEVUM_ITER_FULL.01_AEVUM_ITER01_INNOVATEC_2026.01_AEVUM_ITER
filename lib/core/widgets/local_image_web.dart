import 'package:flutter/material.dart';

/// Implementación web: image_picker devuelve blob-URLs que se muestran con red.
Widget localImage(String path, {double iconSize = 88}) => Image.network(
      path,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Icon(Icons.person, size: iconSize),
    );
