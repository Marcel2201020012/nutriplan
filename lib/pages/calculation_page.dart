import 'package:flutter/material.dart';
import 'package:nutriplan/widgets/gradient_scaffold.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CalculationPage extends StatefulWidget {
  const CalculationPage({super.key});

  @override
  State<CalculationPage> createState() => _CalculationPageState();
}

class _CalculationPageState extends State<CalculationPage> {
  double kalori = 2000;

  // Data user
  String gender = "male";
  int umur = 25;
  double berat = 70;
  double tinggi = 170;
  String username = "User";

  void loadUserProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final ref = FirebaseDatabase.instance.ref('users/$uid/profile/');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        username = data['nama'] ?? "User";
        gender = data['gender'] ?? "male";
        umur = int.tryParse(data['umur'].toString()) ?? 25;
        berat = double.tryParse(data['berat'].toString()) ?? 70;
        tinggi = double.tryParse(data['tinggi'].toString()) ?? 170;

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
      kalori = hasil;
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserProfile(); // ambil data saat halaman dimuat
  }

  void editKaloriDialog() {
    final controller = TextEditingController(text: kalori.toStringAsFixed(0));
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Kalori"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: "Kalori harian",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final input = double.tryParse(controller.text);
              if (input != null) {
                setState(() {
                  kalori = input;
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
                                // lanjutkan
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