import 'dart:io';

import 'package:flutter/material.dart';

/// Implementación móvil/escritorio.
Widget localImage(String path, {double iconSize = 88}) => Image.file(
      File(path),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Icon(Icons.person, size: iconSize),
    );
