import 'package:shared_preferences/shared_preferences.dart';
import '../service/health_service.dart';
import 'package:health/health.dart'; // HealthValue ����� ���� �ʿ�

void backgroundStepFetcher() async {
  final service = HealthService();

  final now = DateTime.now();
  final start = DateTime(now.year, now.month, now.day);

  final granted = await service.requestPermission();
  if (!granted) {
    print("? ���� �źε�");
    return;
  }

  final data = await service.fetchSteps(start, now);

  int totalSteps = 0;
  for (var point in data) {
    final healthValue = point.value;
    if (healthValue is NumericHealthValue) {
      final numeric = healthValue.numericValue;
      if (numeric != null) {
        totalSteps += numeric.round();
      }
    } else {
      print("?? �� �� ���� HealthValue Ÿ��: ${healthValue.runtimeType}");
    }
  }

  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('today_steps', totalSteps);

  print("? ��׶��� ���� �� ���� �Ϸ�: $totalSteps");
}
