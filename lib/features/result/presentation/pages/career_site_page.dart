import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/widgets/app_back_button.dart';
import 'career_site_body.dart';

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

  late final String _asset;

  @override
  void initState() {
    super.initState();
    final id = (widget.careerId ?? '').trim().toLowerCase();
    _asset = 'assets/careers/${_known.contains(id) ? id : 'isc'}.html';
  }

  WebViewController _createController() {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.disabled)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (req) => NavigationDecision.prevent,
        ),
      )
      ..loadFlutterAsset(_asset);
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Ficha de la carrera'),
      ),
      body: careerSiteBody(
        assetPath: _asset,
        createController: _createController,
      ),
    );
  }
}
