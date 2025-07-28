import 'package:health/health.dart';

Future<int> fetchTodayStepCount() async {
  final health = Health();

  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day);

  final types = [HealthDataType.STEPS];

  final hasPermissions = await health.requestAuthorization(types);
  if (!hasPermissions) {
    print("? 권한 거부됨");
    return 0;
  }

  try {
    final data = await health.getHealthDataFromTypes(
      types: types,
      startTime: startOfDay,
      endTime: now,
    );

    final steps = removeDuplicateHealthData(data);

    int total = 0;
    for (var point in steps) {
      if (point.value is int) {
        total += point.value as int;
      } else if (point.value is double) {
        total += (point.value as double).round();
      }
    }

    return total;
  } catch (e) {
    print("? 데이터 수집 오류: $e");
    return 0;
  }
}

List<HealthDataPoint> removeDuplicateHealthData(List<HealthDataPoint> data) {
  final seen = <String>{};
  final deduped = <HealthDataPoint>[];

  for (var point in data) {
    final key = '${point.typeString}_${point.dateFrom}_${point.dateTo}';
    if (!seen.contains(key)) {
      seen.add(key);
      deduped.add(point);
    }
  }

  return deduped;
}
