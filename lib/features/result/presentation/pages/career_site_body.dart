import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'career_site_body_io.dart'
    if (dart.library.js_interop) 'career_site_body_web.dart' as impl;

/// Cuerpo de la ficha: WebView nativo en móvil, iframe en web.
Widget careerSiteBody({
  required String assetPath,
  required WebViewController Function() createController,
}) =>
    impl.careerSiteBody(
      assetPath: assetPath,
      createController: createController,
    );
