import 'package:flutter/material.dart';
import 'package:health/health.dart';
import '../service/health_service.dart';

// provider/step_provider.dart

class StepProvider with ChangeNotifier {
  final HealthService _service = HealthService();

  int _totalSteps = 0;

  int get totalSteps => _totalSteps;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> fetchSteps() async {
    _isLoading = true;
    notifyListeners();

    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);

      final data = await _service.fetchSteps(startOfDay, now);
      _totalSteps = data.fold<int>(0, (sum, e) {
        final value = e.value;
        if (value is NumericHealthValue) {
          return sum + (value.numericValue?.toInt() ?? 0);
        }
        return sum;
      });
    } catch (e, stack) {
      print('fetchSteps 예외 발생: $e');
      print(stack);
      _totalSteps = -1; // 실패시 구분값
    } finally {
      _isLoading = false;
      notifyListeners();
    }
}

  Future<bool> requestPermission() async {
    return await _service.requestPermission();
  }
}
