import 'package:flutter/material.dart';
import 'package:healthgraph/pages/startup_page.dart';
import 'package:provider/provider.dart';
import 'package:health/health.dart';
import 'provider/step_provider.dart';
import 'provider/sleep_provider.dart';
import 'pages/bottom_nav_app.dart';

class HealthApp extends StatefulWidget {
  const HealthApp({super.key});

  @override
  State<HealthApp> createState() => _HealthAppState();
}

class _HealthAppState extends State<HealthApp> {
  final Health health = Health();

  @override
  void initState() {
    super.initState();
    _requestHealthPermissions();
  }

  Future<void> _requestHealthPermissions() async {
    final types = [
      HealthDataType.STEPS,
      HealthDataType.SLEEP_ASLEEP,
      // 필요한 타입 추가
    ];
    final permissions = [
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      // 권한 종류에 맞게 추가
    ];

    bool granted = await health.requestAuthorization(types, permissions: permissions);
    if (!granted) {
      debugPrint('Health Connect 권한이 거부되었습니다.');
      // 필요하면 사용자에게 권한 필요 안내 UI 표시 가능
    } else {
      debugPrint('Health Connect 권한이 허용되었습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StepProvider()),
        ChangeNotifierProvider(create: (_) => SleepProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BottomNavApp(),
      ),
    );
  }
}
