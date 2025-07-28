import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatbotIntroScreen extends StatelessWidget {
  const ChatbotIntroScreen({super.key});

  // 카카오톡 채널 ID (URL 뒤에 있는 고유 ID)
  final String kakaoChannelId = '_ssrFn'; // ← 여기에 자신의 채널 ID로 바꾸세요

  Future<void> _launchKakaoChannel() async {
    final Uri kakaoAppUri = Uri.parse('kakaotalk://plusfriend/home/$kakaoChannelId');
    final Uri webUri = Uri.parse('https://pf.kakao.com/$kakaoChannelId');

    if (await canLaunchUrl(kakaoAppUri)) {
      // 카카오톡 앱이 설치되어 있으면 앱으로 열기
      await launchUrl(kakaoAppUri);
    } else if (await canLaunchUrl(webUri)) {
      // 앱 없으면 웹으로 열기
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('카카오톡 앱 및 웹 모두 열기 실패');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('챗봇 연결 안내')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '카카오톡 챗봇 연동 방법',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('1. 아래 버튼을 눌러 챗봇 채널 추가하기'),
            const SizedBox(height: 8),
            const Text('2. "수면 리포트 받아보기" 메시지를 보내기'),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _launchKakaoChannel,
              icon: const Icon(Icons.chat),
              label: const Text('카카오톡 채널 바로가기'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
