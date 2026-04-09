import 'dart:ui';

/// Controller for programmatic interaction with a [SmartTixSeatMap].
///
/// Create an instance, pass it to the widget, and call [refresh] when
/// you need to reload the venue-viewer (e.g. after blocking seats).
class SeatMapController {
  VoidCallback? _onRefreshRequested;

  /// Destroys and recreates the WebView, forcing a fresh load of the
  /// venue-viewer HTML. This is the only reliable way to "reload" when
  /// the content was loaded via `loadHtmlString`.
  void refresh() => _onRefreshRequested?.call();

  // --- Internal API (called by SmartTixSeatMap) ---

  void bindRefresh(VoidCallback callback) => _onRefreshRequested = callback;

  void unbindRefresh() => _onRefreshRequested = null;
}
