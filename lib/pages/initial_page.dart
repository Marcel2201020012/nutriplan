import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nutriplan/auth_services.dart';
import 'package:nutriplan/cek_otentifikasi.dart';
import 'package:nutriplan/database_services.dart';
import 'package:nutriplan/widgets/gradient_scaffold.dart';
import 'package:nutriplan/widgets/text_styles.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController ageController = TextEditingController(text: '20');
  final TextEditingController weightController = TextEditingController(
    text: '90',
  );
  final TextEditingController heightController = TextEditingController(
    text: '180',
  );

  String selectedGender = 'male';

  //firebase data stuff
  Future<void> saveUserProfileToFirebase({
    required String uid,
    required String nama,
    required String umur,
    required String berat,
    required String tinggi,
  }) async {
    final ref = DatabaseServices.ref('users/$uid/profile');

    final profileData = {
      'nama': nama,
      'umur': umur,
      'berat': berat,
      'tinggi': tinggi,
      'isProfileComplete': true,
    };

    await ref.set(profileData);
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Halo Sobat Nutri,\nKenalan Dulu Yuk!",
                  style: AppTextStyles.h5b,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: usernameController,
                  inputFormatters: [LengthLimitingTextInputFormatter(16)],
                  decoration: InputDecoration(
                    hintText: "Masukkan nama kamu",
                    hintStyle: AppTextStyles.bl,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Gender selection
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => selectedGender = 'male'),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:
                                selectedGender == 'male'
                                    ? Colors.green.shade100
                                    : Colors.transparent,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: const [
                              Icon(Icons.male, size: 40, color: Colors.blue),
                              SizedBox(height: 4),
                              Text("Male", style: AppTextStyles.cb),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => selectedGender = 'female'),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:
                                selectedGender == 'female'
                                    ? Colors.green.shade100
                                    : Colors.transparent,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: const [
                              Icon(Icons.female, size: 40, color: Colors.pink),
                              SizedBox(height: 4),
                              Text("Female", style: AppTextStyles.cb),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: ageController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        onChanged: (value) {
                          if (value.isNotEmpty && int.parse(value) > 100) {
                            ageController.text = '100';
                            ageController
                                .selection = TextSelection.fromPosition(
                              TextPosition(offset: ageController.text.length),
                            );
                          }
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          labelText: "Umur",
                          suffixText: "Tahun",
                          hintStyle: AppTextStyles.bl,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 120),

                // Gambar tengah dari path sesuai gender
                Center(
                  child: Image.asset(
                    selectedGender == 'male'
                        ? 'assets/img/initial_page/maleicon.png'
                        : 'assets/img/initial_page/femaleicon.png',
                    height: 180,
                  ),
                ),

                const SizedBox(height: 8),

                // Input Berat dan Tinggi
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 100,
                      child: TextField(
                        controller: weightController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        onChanged: (value) {
                          if (value.isNotEmpty && int.parse(value) > 200) {
                            weightController.text = '200';
                            weightController
                                .selection = TextSelection.fromPosition(
                              TextPosition(
                                offset: weightController.text.length,
                              ),
                            );
                          }
                        },
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          suffixText: "Kg",
                          hintStyle: AppTextStyles.bl,
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        controller: heightController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        onChanged: (value) {
                          if (value.isNotEmpty && int.parse(value) > 200) {
                            heightController.text = '200';
                            heightController
                                .selection = TextSelection.fromPosition(
                              TextPosition(
                                offset: heightController.text.length,
                              ),
                            );
                          }
                        },
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          suffixText: "Cm",
                          hintStyle: AppTextStyles.bl,
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Center(
                  child: ElevatedButton(
                    onPressed: () async{
                      final uid = AuthServices().currentUid;

                      final name = usernameController.text;
                      final age = ageController.text;
                      final weight = weightController.text;
                      final height = heightController.text;

                      if (uid != null &&
                          name.isNotEmpty &&
                          age.isNotEmpty &&
                          weight.isNotEmpty &&
                          height.isNotEmpty) {
                        await saveUserProfileToFirebase(
                          uid: uid,
                          nama: name,
                          umur: age,
                          berat: weight,
                          tinggi: height,
                        );
                      }

                      if (context.mounted) {
                        //cek apakah widget ter-disposed
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CekOtentifikasi(),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFDE9CC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      child: Text("Lanjutkan", style: AppTextStyles.cb),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
