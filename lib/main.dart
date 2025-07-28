import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:provider/provider.dart';

import './app.dart';
import 'provider/step_provider.dart';
import 'background/background_step_fetcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();

  // 알람 등록: 오전 7시마다 실행
  await scheduleDailyStepFetch();

  runApp(
    ChangeNotifierProvider(
      create: (_) => StepProvider()..loadStepsFromStorage(),
      child: const SafeArea(child: HealthApp()),
    ),
  );
}

Future<void> scheduleDailyStepFetch() async {
  final now = DateTime.now();
  var next7AM = DateTime(now.year, now.month, now.day, 7);
  if (now.isAfter(next7AM)) {
    next7AM = next7AM.add(const Duration(days: 1));
  }

  final delay = next7AM.difference(now);

  await AndroidAlarmManager.periodic(
    const Duration(minutes: 2),
    777, // 고유 ID
    backgroundStepFetcher,
    startAt: DateTime.now().add(delay),
    exact: true,
    wakeup: true,
  );
}
