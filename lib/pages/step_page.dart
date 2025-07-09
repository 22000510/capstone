import 'dart:async';
import 'package:flutter/material.dart';
import 'package:healthgraph/pages/setting_page.dart';
import 'package:provider/provider.dart';
import '../provider/step_provider.dart';
import '../utils/notifications.dart';
import 'chatbot_intro_page.dart';

class StepPage extends StatefulWidget {
  const StepPage({super.key});

  @override
  State<StepPage> createState() => _StepPageState();
}

class _StepPageState extends State<StepPage> {
  Timer? _autoRefreshTimer;

  @override
  void initState() {
    super.initState();
    final stepProvider = Provider.of<StepProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      requestNotificationPermission();
      stepProvider.fetchSteps();
    });

    _autoRefreshTimer = Timer.periodic(const Duration(hours: 1), (_) {
      stepProvider.fetchSteps();
    });
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StepProvider>(context);
    return Scaffold(
      appBar: AppBar(
          title: const Text("걸음 수"),
          actions: [
            IconButton(
              icon: const Icon(Icons.chat),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChatbotIntroScreen()),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: provider.isLoading
              ? const CircularProgressIndicator()
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '오늘 걸음 수:\n${provider.totalSteps} 걸음',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: provider.fetchSteps,
                child: const Text('걸음 수 다시 가져오기'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showNotification("🎉 알림 테스트", "걸음 수 알림 테스트입니다.");
                },
                child: const Text("🔔 알림 테스트"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
