/// Information about a selected seat returned by the venue-viewer.
class SeatInfo {
  /// Unique seat identifier (UUID from the backend).
  final String seatId;

  /// Human-readable composite label (e.g. "1-3").
  final String label;

  /// Category name (e.g. "Private Boxes", "VIP").
  final String? sectorName;

  /// Sub-sector / block label (e.g. "BOX 3", "Table 2").
  /// This is what the viewer tooltip shows as "SECTOR".
  final String? sectionLabel;

  /// Row label (e.g. "1", "A").
  final String? rowLabel;

  /// Individual seat label within the row (e.g. "3", "12").
  final String? seatLabel;

  /// Seat price (0 if not set).
  final num? price;

  /// Currency code (e.g. "EUR", "USD").
  final String? currency;

  /// Category color as hex string (e.g. "#00b4ff").
  final String? categoryColor;

  /// Seat status at the time of selection (e.g. "Available", "Blocked").
  final String? status;

  const SeatInfo({
    required this.seatId,
    required this.label,
    this.sectorName,
    this.sectionLabel,
    this.rowLabel,
    this.seatLabel,
    this.price,
    this.currency,
    this.categoryColor,
    this.status,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SeatInfo &&
          runtimeType == other.runtimeType &&
          seatId == other.seatId;

  @override
  int get hashCode => seatId.hashCode;

  @override
  String toString() =>
      'SeatInfo(seatId: $seatId, label: $label, sectorName: $sectorName, '
      'sectionLabel: $sectionLabel, rowLabel: $rowLabel, seatLabel: $seatLabel, '
      'price: $price, currency: $currency, categoryColor: $categoryColor)';
}
