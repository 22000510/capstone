import 'package:flutter/material.dart';
import 'package:health/health.dart';
import '../service/health_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// provider/step_provider.dart

class StepProvider with ChangeNotifier {
  final HealthService _service = HealthService();

  int _totalSteps = 0;

  int get totalSteps => _totalSteps;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // 저장된 걸음 수를 불러와 _totalSteps에 할당하고 notifyListeners() 호출
  Future<void> loadStepsFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    _totalSteps = prefs.getInt('today_steps') ?? 0;
    notifyListeners();
  }

  // 걸음 수 저장하는 내부 함수
  Future<void> _saveStepsToStorage(int steps) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('today_steps', steps);
  }

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

      // 여기서 저장까지 같이
      await _saveStepsToStorage(_totalSteps);
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
