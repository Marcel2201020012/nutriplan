import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutriplan/auth_services.dart';
import 'package:nutriplan/database_services.dart';
import 'package:nutriplan/widgets/text_styles.dart';
import 'edit_profile_page.dart';
import 'settings_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = '';
  String berat = '';
  final uid = AuthServices().currentUid;

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  void loadUserProfile() async {
    if (uid == null) return;
    final ref = DatabaseServices.ref('users/$uid/profile/');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        username = data['nama'] ?? 'Tidak diketahui';
        berat = data['berat'] ?? '-';
      });
    } else {
      setState(() {
        username = 'Pengguna Baru';
        berat = '-';
      });
    }
  }

  void logout() async {
    try {
      await authServices.value.signOut();
    } on FirebaseAuthException catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FAF8),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // FOTO PROFIL + IKON NOTIFIKASI
            Stack(
              children: [
                Container(
                  height: 500,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/img/logo.png'),
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

            // KARTU PROFIL
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
                        title: Text(
                          "Nama: $username ", 
                        style: AppTextStyles.bl),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.track_changes_outlined,
                          color: Color(0xFF61B269),
                        ),
                        title: Text(
                          "Berat: $berat kg",
                          style: AppTextStyles.bl,
                        ),
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

            // KARTU FITUR
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
                    onTap: () async {
                      logout();
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
