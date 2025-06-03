import 'package:flutter/material.dart';
import 'edit_profile_page.dart';
import 'settings_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF0FAF8,
      ), 
      body: SingleChildScrollView(
        child: Column(
          children: [
            // FOTO PROFIL IKON NOTIFIKASI
            Stack(
              children: [
                Container(
                  height: 500,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/img/danyi_profile.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 20,
                  child: IconButton(
                    icon: const Icon(
                      Icons.notifications,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      // Navigasi notifikasi
                    },
                  ),
                ),
              ],
            ),

            // Card pertama 
            Transform.translate(
              offset: const Offset(0, -40), 
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.person_outline,
                          color: Color(0xFF61B269),
                        ),
                        title: const Text(
                          "Danyi Aprizal",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.track_changes_outlined,
                          color: Color(0xFF61B269),
                        ),
                        title: const Text("Penambahan Berat Badan"),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditProfilePage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Perbaharui ›",
                            style: TextStyle(color: Color(0xFF61B269)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Card fitur lainnya
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.bar_chart,
                      color: Color(0xFF61B269),
                    ),
                    title: const Text("Statistik"),
                    onTap: () {
                      // Navigasi statistik
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.settings,
                      color: Color(0xFF61B269),
                    ),
                    title: const Text("Pengaturan"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SettingsPage()),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text("Keluar"),
                    onTap: () {
                      // logout
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
