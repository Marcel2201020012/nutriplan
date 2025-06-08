import 'package:flutter/material.dart';
import 'package:nutriplan/auth_services.dart';
import 'package:nutriplan/cek_otentifikasi.dart';
import 'package:nutriplan/database_services.dart';
import 'package:nutriplan/widgets/gradient_scaffold.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CalculationPage extends StatefulWidget {
  const CalculationPage({super.key});

  @override
  State<CalculationPage> createState() => _CalculationPageState();
}

class _CalculationPageState extends State<CalculationPage> {
  int kalori = 0;

  // Data user
  String gender = "male";
  int umur = 0;
  int berat = 0;
  int tinggi = 0;
  String username = "User";

  final uid = AuthServices().currentUid;

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  void saveKaloriToFirebase() async {
    if (uid == null) return;
    final data = {'kalori': kalori, 'isProfileComplete': true};
    final ref = DatabaseServices.ref('users/$uid/profile');

    await ref.update(data);
  }

  void loadUserProfile() async {
    if (uid == null) return;

    final ref = DatabaseServices.ref('users/$uid/profile/');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        username = data['nama'] ?? "User";
        gender = data['gender'] ?? "male";
        umur = int.tryParse(data['umur'].toString()) ?? 25;
        berat = int.tryParse(data['berat'].toString()) ?? 70;
        tinggi = int.tryParse(data['tinggi'].toString()) ?? 170;

        hitungKalori();
      });
    }
  }

  void hitungKalori() {
    double hasil = 0;
    if (gender == "male") {
      hasil = 88.362 + (13.397 * berat) + (4.799 * tinggi) - (5.677 * umur);
    } else {
      hasil = 447.593 + (9.247 * berat) + (3.098 * tinggi) - (4.330 * umur);
    }
    setState(() {
      kalori = hasil.toInt();
      saveKaloriToFirebase();
    });
  }

  void editKaloriDialog() {
    final controller = TextEditingController(text: kalori.toStringAsFixed(0));
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Edit Kalori"),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Kalori harian"),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  final input = int.tryParse(controller.text);
                  if (input != null) {
                    setState(() {
                      kalori = input;
                      saveKaloriToFirebase();
                    });
                  }
                  Navigator.pop(context);
                },
                child: const Text("Simpan"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Selamat Datang\n$username!",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularPercentIndicator(
                              radius: 80.0,
                              lineWidth: 13.0,
                              percent: 0.75,
                              backgroundColor: Colors.grey.shade300,
                              progressColor: Colors.grey.shade500,
                              circularStrokeCap: CircularStrokeCap.round,
                              center: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    kalori.toStringAsFixed(0),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text("kal"),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: editKaloriDialog,
                                    child: const Icon(Icons.edit, size: 16),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const CekOtentifikasi(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF2D8A7),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text("Lanjutkan"),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Berikut adalah perkiraan kalori harian Anda",
                              textAlign: TextAlign.center,
                            ),
                          ],
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
}
