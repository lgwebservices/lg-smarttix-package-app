## 0.2.0

* `SeatInfo` enriched with full event detail: `sectorName`, `sectionLabel`, `rowLabel`, `seatLabel`, `price`, `currency`, `categoryColor`, `status`.
* `SeatMapConfig`: add `showBlockedMarker` option for promoter mode (blocked seats render in red with X marker).
* HTML bridge forwards all venue-viewer event fields including seat status (`Available`, `Blocked`, `Booked`).

## 0.1.0

* Initial release.
* `SmartTixSeatMap` widget wrapping the venue-viewer web component.
* `SeatMapConfig` for viewer configuration (token, API URL, bundle URL, language, etc.).
* `SeatMapController` for programmatic refresh.
* `SeatInfo` model for selected seat data.
* JavaScript bridge forwarding `seatSelected`/`seatDeselected` DOM events to typed Dart callbacks.
* Cache-buster support for CDN-hosted bundles.
