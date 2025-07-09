import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  TimeOfDay _selectedTime = const TimeOfDay(hour: 23, minute: 0);

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> saveBedTime() async {
    final userId = 'test_user_123'; // 실제 앱에서는 FirebaseAuth 사용 권장
    final bedTimeStr =
        '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}';

    try {
      print('[Firebase 저장 시도] $userId -> $bedTimeStr');

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('bedTimeRecords') // 👈 서브 컬렉션에 저장
          .add({
        'bedTime': bedTimeStr,
        'hour': _selectedTime.hour,
        'minute': _selectedTime.minute,
        'savedAt': Timestamp.now(),
      });

      print('[Firebase 저장 성공] $userId -> $bedTimeStr');

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('취침 시간이 저장되었습니다: $bedTimeStr')),
      );
    } catch (e) {
      print('[Firebase 저장 실패] $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('저장 실패: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SleepManager - 설정')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '취침 시간 설정',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickTime,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _selectedTime.format(context),
                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: saveBedTime,
              child: const Text('저장하기', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
