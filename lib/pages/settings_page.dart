import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FAF8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        title: const Text("Pengaturan", style: TextStyle(color: Colors.black)),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildSettingItem(Icons.privacy_tip, "Privasi"),
              buildDivider(),
              buildSettingItem(Icons.security, "Keamanan"),
              buildDivider(),
              buildSettingItem(Icons.help_outline, "Bantuan"),
              buildDivider(),
              buildSettingItem(Icons.info_outline, "Tentang"),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSettingItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // tambahkan aksi jika perlu
      },
    );
  }

  Widget buildDivider() {
    return const Divider(height: 1);
  }
}
