import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthgraph/pages/startup_page.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.alarm),
            title: const Text('취침 알림 시간 변경'),
            subtitle: const Text('23:00'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StartupScreen()),
              );
            },
          ),
          const ListTile(
            leading: Icon(Icons.chat),
            title: Text('챗봇 연결 상태'),
            subtitle: Text('연결됨'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('앱 정보'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }
}
