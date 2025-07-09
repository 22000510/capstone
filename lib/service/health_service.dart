import 'package:flutter/cupertino.dart';
import 'package:health/health.dart';

class HealthService {
  final health = Health();

  Future<List<HealthDataPoint>> fetchSteps(DateTime start, DateTime end) async {
    final types = [HealthDataType.STEPS];
    final permissions = [HealthDataAccess.READ];

    final authorized = await health.requestAuthorization(types, permissions: permissions);
    if (!authorized) return [];

    final data = await health.getHealthDataFromTypes(types: types, startTime: start, endTime: end);
    return health.removeDuplicates(data);
  }

  Future<List<HealthDataPoint>> fetchSleep(DateTime start, DateTime end) async {
    final types = [HealthDataType.SLEEP_ASLEEP];
    final permissions = [HealthDataAccess.READ];

    final authorized = await health.requestAuthorization(types, permissions: permissions);
    if (!authorized) return [];

    final data = await health.getHealthDataFromTypes(types: types, startTime: start, endTime: end);
    return health.removeDuplicates(data);
  }
  
  Future<bool> requestPermission() async {
    final types = [HealthDataType.STEPS];
    final permissions = [HealthDataAccess.READ];

    return await health.requestAuthorization(types, permissions: permissions);
  }

}
