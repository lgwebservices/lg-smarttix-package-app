/// Information about a selected seat returned by the venue-viewer.
class SeatInfo {
  /// Unique seat identifier (UUID from the backend).
  final String seatId;

  /// Human-readable label (e.g. "A-12").
  final String label;

  const SeatInfo({required this.seatId, required this.label});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SeatInfo &&
          runtimeType == other.runtimeType &&
          seatId == other.seatId;

  @override
  int get hashCode => seatId.hashCode;

  @override
  String toString() => 'SeatInfo(seatId: $seatId, label: $label)';
}
