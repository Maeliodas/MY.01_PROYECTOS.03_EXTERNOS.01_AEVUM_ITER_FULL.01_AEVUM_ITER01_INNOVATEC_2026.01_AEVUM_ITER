import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Implementación móvil/escritorio.
Widget careerSiteBody({
  required String assetPath,
  required WebViewController Function() createController,
}) {
  final controller = createController();
  return _WebViewBody(controller: controller);
}

class _WebViewBody extends StatefulWidget {
  final WebViewController controller;
  const _WebViewBody({required this.controller});

  @override
  State<_WebViewBody> createState() => _WebViewBodyState();
}

class _WebViewBodyState extends State<_WebViewBody> {
  var _progress = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.setNavigationDelegate(
      NavigationDelegate(
        onProgress: (p) => mounted ? setState(() => _progress = p) : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: widget.controller),
        if (_progress < 100)
          const LinearProgressIndicator(minHeight: 3),
      ],
    );
  }
}
