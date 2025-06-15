import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutriplan/auth_services.dart';
import 'package:nutriplan/database_services.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _namaController = TextEditingController();
  final _beratController = TextEditingController();
  final _passwordLamaController = TextEditingController();
  final _passwordBaruController = TextEditingController();

  final uid = AuthServices().currentUid;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    if (uid == null) return;
    final ref = DatabaseServices.ref('users/$uid/profile/');
    final snapshot = await ref.get();

    currentUser = FirebaseAuth.instance.currentUser;

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      _namaController.text = data['nama'] ?? '';
      _beratController.text = data['berat'] ?? '';
    }
  }

  Future<void> saveChanges() async {
    final nama = _namaController.text.trim();
    final berat = _beratController.text.trim();
    final passwordLama = _passwordLamaController.text.trim();
    final passwordBaru = _passwordBaruController.text.trim();

    if (nama.isEmpty || berat.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama dan Berat tidak boleh kosong')),
      );
      return;
    }

    try {
      final ref = DatabaseServices.ref('users/$uid/profile/');
      await ref.update({'nama': nama, 'berat': berat});

      // Jika ingin ubah password
      if (passwordLama.isNotEmpty && passwordBaru.isNotEmpty) {
        final cred = EmailAuthProvider.credential(
          email: currentUser!.email!,
          password: passwordLama,
        );
        await currentUser!.reauthenticateWithCredential(cred);
        await currentUser!.updatePassword(passwordBaru);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui')),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal update: ${e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FAF8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/img/logo.png'),
            ),
            const SizedBox(height: 16),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    buildTextField(
                      controller: _namaController,
                      icon: Icons.person,
                      hintText: "Nama Lengkap",
                    ),
                    buildTextField(
                      controller: _beratController,
                      icon: Icons.track_changes,
                      hintText: "Berat Badan",
                    ),
                    const Divider(height: 20),
                    buildTextField(
                      controller: _passwordLamaController,
                      icon: Icons.lock_outline,
                      hintText: "Password Saat Ini",
                      isObscure: true,
                    ),
                    buildTextField(
                      controller: _passwordBaruController,
                      icon: Icons.lock,
                      hintText: "Password Baru",
                      isObscure: true,
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: saveChanges,
                        child: const Text(
                          "Simpan Perubahan ›",
                          style: TextStyle(color: Colors.teal),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    bool isObscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        obscureText: isObscure,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.teal),
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _beratController.dispose();
    _passwordLamaController.dispose();
    _passwordBaruController.dispose();
    super.dispose();
  }
}
