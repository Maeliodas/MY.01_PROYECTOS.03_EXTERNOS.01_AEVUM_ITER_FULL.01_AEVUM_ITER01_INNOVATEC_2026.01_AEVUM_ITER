import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/widgets/app_back_button.dart';

/// Ficha local de la carrera (HTML de demostración en assets/careers/).
class CareerSitePage extends StatefulWidget {
  final String? careerId;
  const CareerSitePage({super.key, this.careerId});

  @override
  State<CareerSitePage> createState() => _CareerSitePageState();
}

class _CareerSitePageState extends State<CareerSitePage> {
  static const _known = {
    'isc', 'ii', 'idap', 'iem', 'ie', 'ic', 'ibq', 'ige', 'la', 'cp', 'arq',
  };

  late final WebViewController _controller;
  var _progress = 0;

  @override
  void initState() {
    super.initState();
    final id = (widget.careerId ?? '').trim().toLowerCase();
    final asset = 'assets/careers/${_known.contains(id) ? id : 'isc'}.html';
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.disabled)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (p) => mounted ? setState(() => _progress = p) : null,
          onNavigationRequest: (req) => NavigationDecision.prevent,
        ),
      )
      ..loadFlutterAsset(asset);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Ficha de la carrera'),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_progress < 100)
            const LinearProgressIndicator(minHeight: 3),
        ],
      ),
    );
  }
}
