import 'package:flutter/cupertino.dart';

import '../service/health_service.dart';

class SleepProvider with ChangeNotifier {
  final _service = HealthService();

  double _totalSleepHours = 0;
  double get totalSleepHours => _totalSleepHours;

  DateTime? _sleepStartTime;
  DateTime? _sleepEndTime;

  DateTime? get sleepStartTime => _sleepStartTime;
  DateTime? get sleepEndTime => _sleepEndTime;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchSleepData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);

      final data = await _service.fetchSleep(startOfDay, now);

      double totalHours = 0;
      DateTime? earliest;
      DateTime? latest;

      for (final entry in data) {
        final from = entry.dateFrom;
        final to = entry.dateTo;

        final durationMinutes = to.difference(from).inMinutes;
        final durationHours = durationMinutes / 60.0;
        totalHours += durationHours;

        if (earliest == null || from.isBefore(earliest)) {
          earliest = from;
        }
        if (latest == null || to.isAfter(latest)) {
          latest = to;
        }

        debugPrint('수면 기록: from $from to $to, duration: $durationMinutes 분 ($durationHours 시간)');
      }

      _totalSleepHours = totalHours;
      _sleepStartTime = earliest;
      _sleepEndTime = latest;
    } catch (e, stack) {
      debugPrint('SleepProvider 예외 발생: $e');
      debugPrint(stack.toString());
      _totalSleepHours = -1;
      _sleepStartTime = null;
      _sleepEndTime = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> requestPermission() async {
    return await _service.requestPermission();
  }
}
