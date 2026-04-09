import 'package:flutter_test/flutter_test.dart';
import 'package:smarttix_seatmap/smarttix_seatmap.dart';

void main() {
  group('SeatMapConfig', () {
    test('equality works with same values', () {
      const a = SeatMapConfig(
        publicToken: 'abc',
        apiUrl: 'https://api.example.com',
        bundleUrl: 'https://cdn.example.com/viewer.js',
      );
      const b = SeatMapConfig(
        publicToken: 'abc',
        apiUrl: 'https://api.example.com',
        bundleUrl: 'https://cdn.example.com/viewer.js',
      );
      expect(a, equals(b));
    });

    test('inequality when publicToken differs', () {
      const a = SeatMapConfig(
        publicToken: 'abc',
        apiUrl: 'https://api.example.com',
        bundleUrl: 'https://cdn.example.com/viewer.js',
      );
      const b = SeatMapConfig(
        publicToken: 'xyz',
        apiUrl: 'https://api.example.com',
        bundleUrl: 'https://cdn.example.com/viewer.js',
      );
      expect(a, isNot(equals(b)));
    });
  });

  group('SeatInfo', () {
    test('equality based on seatId only', () {
      const a = SeatInfo(seatId: 's1', label: 'A-1');
      const b = SeatInfo(seatId: 's1', label: 'Different');
      expect(a, equals(b));
    });
  });

  group('SeatMapController', () {
    test('refresh calls bound callback', () {
      final controller = SeatMapController();
      var called = false;
      controller.bindRefresh(() => called = true);
      controller.refresh();
      expect(called, isTrue);
    });

    test('refresh does nothing when unbound', () {
      final controller = SeatMapController();
      controller.bindRefresh(() {});
      controller.unbindRefresh();
      controller.refresh(); // no-op, no crash
    });
  });
}
