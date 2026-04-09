import 'dart:convert';

import 'models/seat_map_config.dart';

/// Builds the full HTML document that loads the `<venue-viewer>` web component
/// and wires up JS→Dart communication via a `flutterBridge` JavaScript channel.
String buildSeatMapHtml(SeatMapConfig config) {
  const escape = HtmlEscape();
  final token = escape.convert(config.publicToken);
  final apiUrl = escape.convert(config.apiUrl);

  String bundleUrl = config.bundleUrl;
  if (config.cacheBust) {
    final ts = DateTime.now().millisecondsSinceEpoch.toString();
    bundleUrl = '$bundleUrl?t=$ts';
  }
  bundleUrl = escape.convert(bundleUrl);

  return '''
<!DOCTYPE html>
<html lang="${config.lang}">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=5">
<style>
  html,body{margin:0;padding:0;height:100%;background:#fff}
  venue-viewer{display:block;width:100%;height:100%}
</style>
<script src="$bundleUrl" defer></script>
</head>
<body>
  <venue-viewer
    public-token="$token"
    api-url="$apiUrl"
    max-seats="${config.maxSeats}"
    lang="${config.lang}"
    show-availability="${config.showAvailability}">
  </venue-viewer>
  <script>
    (function () {
      function send(payload) {
        try { window.flutterBridge && window.flutterBridge.postMessage(JSON.stringify(payload)); }
        catch (e) { /* noop */ }
      }
      function bind() {
        var el = document.querySelector('venue-viewer');
        if (!el) { setTimeout(bind, 100); return; }
        el.addEventListener('seatSelected', function (e) {
          var d = e.detail || {};
          var label = d.rowLabel && d.label
            ? (d.rowLabel + '-' + d.label)
            : (d.label || (d.seatId || '').slice(0, 8));
          send({ type: 'seatSelected', seatId: d.seatId, label: label });
        });
        el.addEventListener('seatDeselected', function (e) {
          var d = e.detail || {};
          send({ type: 'seatDeselected', seatId: d.seatId });
        });
      }
      bind();
    })();
  </script>
</body>
</html>
''';
}
