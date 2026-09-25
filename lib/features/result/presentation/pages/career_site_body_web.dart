import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web/web.dart' as web;
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:ui_web' as ui_web;

/// Implementación web: iframe con la ficha como blob-URL.
Widget careerSiteBody({
  required String assetPath,
  required WebViewController Function() createController,
}) {
  return _IframeBody(assetPath: assetPath);
}

class _IframeBody extends StatefulWidget {
  final String assetPath;
  const _IframeBody({required this.assetPath});

  @override
  State<_IframeBody> createState() => _IframeBodyState();
}

class _IframeBodyState extends State<_IframeBody> {
  String? _viewType;

  @override
  void initState() {
    super.initState();
    _setup();
  }

  Future<void> _setup() async {
    final html = await rootBundle.loadString(widget.assetPath);
    final blob = web.Blob([html.toJS].toJS, web.BlobPropertyBag(type: 'text/html'));
    final url = web.URL.createObjectURL(blob);
    final viewType = 'career-${widget.assetPath.hashCode}';
    ui_web.platformViewRegistry.registerViewFactory(viewType, (int _) {
      final frame = web.document.createElement('iframe') as web.HTMLIFrameElement;
      frame.src = url;
      frame.style.width = '100%';
      frame.style.height = '100%';
      frame.style.border = '0';
      return frame;
    });
    if (mounted) setState(() => _viewType = viewType);
  }

  @override
  Widget build(BuildContext context) {
    final viewType = _viewType;
    if (viewType == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return HtmlElementView(viewType: viewType);
  }
}
