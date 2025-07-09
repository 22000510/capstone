import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/sleep_provider.dart';
import 'chatbot_intro_page.dart';
import 'setting_page.dart';

class SleepReportScreen extends StatelessWidget {
  const SleepReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sleepProvider = Provider.of<SleepProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('수면 리포트'),
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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              '최근 수면 기록',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                sleepProvider.fetchSleepData();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('데이터 불러오기'),
            ),
            const SizedBox(height: 24),
            sleepProvider.isLoading
                ? const CircularProgressIndicator()
                : sleepProvider.sleepStartTime != null &&
                sleepProvider.sleepEndTime != null
                ? Column(
              children: [
                Text(
                  '🛌 수면 시작: ${formatTime(sleepProvider.sleepStartTime!)}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 12),
                Text(
                  '🌞 기상 시간: ${formatTime(sleepProvider.sleepEndTime!)}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 12),
                Text(
                  '⏰ 총 수면 시간: ${sleepProvider.totalSleepHours.toStringAsFixed(1)} 시간',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => saveSleepData(context),
                  icon: const Icon(Icons.save),
                  label: const Text('수면 데이터 저장하기'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            )
                : const Text('수면 기록이 없습니다.', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  String formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

Future<void> saveSleepData(BuildContext context) async {
  final sleepProvider = Provider.of<SleepProvider>(context, listen: false);
  final userId = 'test_user_123'; // 또는 FirebaseAuth.instance.currentUser?.uid

  if (sleepProvider.sleepStartTime == null || sleepProvider.sleepEndTime == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('저장할 수면 데이터가 없습니다.')),
    );
    return;
  }

  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('sleepRecords')
        .add({
      'startTime': sleepProvider.sleepStartTime,
      'endTime': sleepProvider.sleepEndTime,
      'totalHours': sleepProvider.totalSleepHours,
      'savedAt': Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('수면 데이터가 저장되었습니다.')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('저장 실패: $e')),
    );
  }
}
