import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'models/seat_info.dart';
import 'models/seat_map_config.dart';
import 'seat_map_controller.dart';
import 'seat_map_html.dart';

/// A widget that renders a SmartTix venue-viewer inside a WebView.
///
/// The viewer is a read-only seat map that emits `seatSelected` and
/// `seatDeselected` DOM events. This widget translates those events
/// into typed Dart callbacks.
///
/// ```dart
/// SmartTixSeatMap(
///   config: SeatMapConfig(
///     publicToken: 'abc-123',
///     apiUrl: 'https://api.smarttix.pro',
///     bundleUrl: 'https://cdn.smarttix.pro/v1/venue-viewer.js',
///   ),
///   onSeatSelected: (seat) => print('Selected: ${seat.label}'),
///   onSeatDeselected: (id) => print('Deselected: $id'),
/// )
/// ```
class SmartTixSeatMap extends StatefulWidget {
  /// Configuration for the venue-viewer web component.
  final SeatMapConfig config;

  /// Optional controller to trigger [SeatMapController.refresh] from outside.
  final SeatMapController? controller;

  /// Called when the user taps an available seat.
  final void Function(SeatInfo seat)? onSeatSelected;

  /// Called when the user deselects a previously selected seat.
  final void Function(String seatId)? onSeatDeselected;

  /// Called when the venue-viewer has finished rendering inside the WebView.
  final VoidCallback? onMapReady;

  /// Called when the WebView fails to load the HTML content.
  final void Function(String error)? onError;

  const SmartTixSeatMap({
    super.key,
    required this.config,
    this.controller,
    this.onSeatSelected,
    this.onSeatDeselected,
    this.onMapReady,
    this.onError,
  });

  @override
  State<SmartTixSeatMap> createState() => _SmartTixSeatMapState();
}

class _SmartTixSeatMapState extends State<SmartTixSeatMap> {
  WebViewController? _webController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    widget.controller?.bindRefresh(_recreateWebView);
    _createWebView();
  }

  @override
  void didUpdateWidget(SmartTixSeatMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.unbindRefresh();
      widget.controller?.bindRefresh(_recreateWebView);
    }

    if (oldWidget.config != widget.config) {
      _recreateWebView();
    }
  }

  @override
  void dispose() {
    widget.controller?.unbindRefresh();
    super.dispose();
  }

  void _createWebView() {
    final html = buildSeatMapHtml(widget.config);
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..addJavaScriptChannel(
        'flutterBridge',
        onMessageReceived: _onBridgeMessage,
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) {
              setState(() => _isLoading = false);
              widget.onMapReady?.call();
            }
          },
          onWebResourceError: (err) {
            if (err.isForMainFrame ?? false) {
              if (mounted) {
                setState(() => _isLoading = false);
                widget.onError?.call(err.description);
              }
            }
          },
        ),
      )
      ..loadHtmlString(html, baseUrl: widget.config.apiUrl);

    if (mounted) setState(() => _webController = controller);
  }

  void _recreateWebView() {
    setState(() {
      _webController = null;
      _isLoading = true;
    });
    _createWebView();
  }

  void _onBridgeMessage(JavaScriptMessage msg) {
    Map<String, dynamic>? payload;
    try {
      final decoded = jsonDecode(msg.message);
      if (decoded is Map<String, dynamic>) payload = decoded;
    } catch (_) {
      return;
    }
    if (payload == null) return;

    final type = payload['type'];
    if (type == 'seatSelected') {
      final seatId = payload['seatId'] as String?;
      final label = payload['label'] as String? ?? '';
      if (seatId == null) return;
      widget.onSeatSelected?.call(SeatInfo(
        seatId: seatId,
        label: label,
        sectorName: payload['sectorName'] as String?,
        sectionLabel: payload['sectionLabel'] as String?,
        rowLabel: payload['rowLabel'] as String?,
        seatLabel: payload['seatLabel'] as String?,
        price: payload['price'] as num?,
        currency: payload['currency'] as String?,
        categoryColor: payload['categoryColor'] as String?,
        status: payload['status'] as String?,
      ));
    } else if (type == 'seatDeselected') {
      final seatId = payload['seatId'] as String?;
      if (seatId == null) return;
      widget.onSeatDeselected?.call(seatId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_webController != null)
          WebViewWidget(controller: _webController!),
        if (_isLoading)
          Container(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.85),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
