import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nutriplan/services/auth_services.dart';
import 'package:nutriplan/services/cek_otentifikasi.dart';
import 'package:nutriplan/services/database_services.dart';
import 'package:nutriplan/services/notification_service.dart';
import 'package:nutriplan/widgets/text_styles.dart';
import 'edit_profile_page.dart';
import 'settings_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
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
      await NotificationService.notificationsPlugin.cancelAll();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CekOtentifikasi()),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal logout: ${e.message}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    const isWeb = kIsWeb;
    final screenWidth = MediaQuery.of(context).size.width;
    final logoSize = isWeb ? screenWidth * 0.15 : screenWidth * 0.3;

    return Scaffold(
      backgroundColor: const Color(0xFFF0FAF8),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),

            // Logo Centered with Shadow
            Center(
              child: SizedBox(
                width: logoSize,
                height: logoSize,
                child: ClipOval(
                  child: Image.asset('assets/img/logo.png', fit: BoxFit.cover),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Profile Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
                shadowColor: Colors.black.withValues(alpha: 13),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(
                          Icons.person_outline,
                          color: Color(0xFF61B269),
                        ),
                        title: Text("Nama: $username", style: AppTextStyles.bl),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
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
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const EditProfilePage(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.edit,
                            size: 18,
                            color: Color(0xFF61B269),
                          ),
                          label: const Text(
                            "Perbarui",
                            style: TextStyle(color: Color(0xFF61B269)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Feature Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
                shadowColor: Colors.black.withValues(alpha: 13),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.bar_chart,
                        color: Color(0xFF61B269),
                      ),
                      title: const Text("Statistik"),
                      onTap: () {
                        // Navigate to statistik
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
                          MaterialPageRoute(
                            builder: (_) => const SettingsPage(),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(
                        Icons.logout,
                        color: Colors.redAccent,
                      ),
                      title: const Text("Keluar"),
                      onTap: logout,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
