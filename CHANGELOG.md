## 0.1.0

* Initial release.
* `SmartTixSeatMap` widget wrapping the venue-viewer web component.
* `SeatMapConfig` for viewer configuration (token, API URL, bundle URL, language, etc.).
* `SeatMapController` for programmatic refresh.
* `SeatInfo` model for selected seat data.
* JavaScript bridge forwarding `seatSelected`/`seatDeselected` DOM events to typed Dart callbacks.
* Cache-buster support for CDN-hosted bundles.
