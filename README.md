# smarttix_seatmap

Flutter widget that wraps the SmartTix `<venue-viewer>` web component for interactive seat maps.

## Features

- Renders a venue-viewer inside a WebView with typed Dart callbacks
- `onSeatSelected` / `onSeatDeselected` events
- `SeatMapController` for programmatic refresh after seat operations
- Cache-buster for CDN bundles (bypasses 24h max-age)
- Configurable: language, max seats, availability display

## Installation

```yaml
dependencies:
  smarttix_seatmap: ^0.1.0
```

Or from git:

```yaml
dependencies:
  smarttix_seatmap:
    git:
      url: https://github.com/lgwebservices/lg-smarttix-package-app.git
      ref: main
```

## Usage

```dart
import 'package:smarttix_seatmap/smarttix_seatmap.dart';

final controller = SeatMapController();

SmartTixSeatMap(
  config: const SeatMapConfig(
    publicToken: 'your-venue-public-token',
    apiUrl: 'https://api.smarttix.pro',
    bundleUrl: 'https://cdn.smarttix.pro/v1/venue-viewer.js',
  ),
  controller: controller,
  onSeatSelected: (seat) => print('Selected: ${seat.label}'),
  onSeatDeselected: (seatId) => print('Deselected: $seatId'),
  onMapReady: () => print('Map loaded'),
  onError: (error) => print('Error: $error'),
)

// After blocking seats, refresh the map:
controller.refresh();
```

## Publisher

Published by [smarttix.pro](https://smarttix.pro).
