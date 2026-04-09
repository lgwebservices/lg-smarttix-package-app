/// Configuration for the [SmartTixSeatMap] widget.
class SeatMapConfig {
  /// Public token of the venue (required for the venue-viewer component).
  final String publicToken;

  /// Base URL of the SeatMap API (e.g. "https://api.smarttix.pro").
  final String apiUrl;

  /// URL of the venue-viewer JS bundle on CDN.
  final String bundleUrl;

  /// Maximum number of seats that can be selected simultaneously.
  final int maxSeats;

  /// Language code for the viewer UI.
  final String lang;

  /// Whether to show seat availability indicators.
  final bool showAvailability;

  /// Show blocked seats with a distinct color and X marker (promoter mode).
  /// When false, blocked seats look the same as booked (public mode).
  final bool showBlockedMarker;

  /// Append a cache-buster query param to the bundle URL on each load.
  /// The CDN serves the bundle with max-age=86400, so without this
  /// the WebView may show a stale version for up to 24h.
  final bool cacheBust;

  const SeatMapConfig({
    required this.publicToken,
    required this.apiUrl,
    required this.bundleUrl,
    this.maxSeats = 50,
    this.lang = 'es',
    this.showAvailability = true,
    this.showBlockedMarker = false,
    this.cacheBust = true,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SeatMapConfig &&
          runtimeType == other.runtimeType &&
          publicToken == other.publicToken &&
          apiUrl == other.apiUrl &&
          bundleUrl == other.bundleUrl &&
          maxSeats == other.maxSeats &&
          lang == other.lang &&
          showAvailability == other.showAvailability &&
          showBlockedMarker == other.showBlockedMarker &&
          cacheBust == other.cacheBust;

  @override
  int get hashCode => Object.hash(
        publicToken,
        apiUrl,
        bundleUrl,
        maxSeats,
        lang,
        showAvailability,
        showBlockedMarker,
        cacheBust,
      );
}
