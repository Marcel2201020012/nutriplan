import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutriplan/services/auth_services.dart';
import 'package:nutriplan/services/database_services.dart';
import 'package:nutriplan/services/notification_service.dart';
import 'package:nutriplan/widgets/gradient_scaffold.dart';
import 'package:nutriplan/widgets/text_styles.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:nutriplan/widgets/app_bar.dart';

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  String username = '';

  List<Map<String, dynamic>> daftarMakanan = [];
  int totalKalori = 0;
  int kalori = 0;
  bool isDataLoaded = false;

  List<String> semuaMakanan = [];
  List<String> filteredMakanan = [];

  @override
  void initState() {
    super.initState();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    loadReminder();
    loadUserProfile();
    loadHistorisDataFromFirebase(today);

    getMakananDb().then((makanan) {
      setState(() {
        semuaMakanan = makanan;
      });
    });
  }

  final uid = AuthServices().currentUid;

  void loadReminder() async {
    final key = DateTime.now().toIso8601String().substring(0, 10);
    final ref = DatabaseServices.ref('users/$uid/historis/$key');
    final snapshot = await ref.get();

    if (!snapshot.exists) {
      //("set reminder");

      final now = DateTime.now();
      DateTime scheduledTime = DateTime(now.year, now.month, now.day, 0, 0);

      if (scheduledTime.isBefore(now)) {
        scheduledTime = scheduledTime.add(const Duration(days: 1));
      }

      await NotificationService.jadwalNotif(
        id: 0,
        title: "Jangan Lupa Makan!",
        body: "Ayo tambahkan menu makanan hari ini!",
        waktu: scheduledTime,
      );
    } else {
      //print("tidak ada reminder");
    }
  }

  void loadUserProfile() async {
    if (uid == null) return;
    final ref = DatabaseServices.ref('users/$uid/profile/');

    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        username = data['nama'];
        totalKalori = data['kalori'];
      });
    } else {
      setState(() {
        username = "User";
      });
    }
  }

  void saveDataToFirebase() async {
    if (uid == null) return;
    final nowDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    double now = daftarMakanan.fold(0.0, (sum, item) {
      if (item['diMakan'] == true) {
        return sum + (item['kalori'] ?? 0);
      }
      return sum;
    });

    final data = {
      'daftarMakanan': daftarMakanan,
      'totalKalori': totalKalori,
      'kalori': now,
    };

    final ref = DatabaseServices.ref('users/$uid/historis/$nowDate');

    await ref.set(data);
  }

  void loadHistorisDataFromFirebase(String date) async {
    if (uid == null) return;

    final ref = DatabaseServices.ref('users/$uid/historis/$date');

    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);

      setState(() {
        totalKalori = data['totalKalori'] ?? 0;
        kalori = (data['kalori'] as num?)?.toInt() ?? 0;

        final rawList = data['daftarMakanan'];
        if (rawList != null && rawList is List) {
          daftarMakanan =
              rawList
                  .map<Map<String, dynamic>>(
                    (item) => Map<String, dynamic>.from(item as Map),
                  )
                  .toList();
        } else {
          daftarMakanan = [];
        }

        isDataLoaded = true;
      });
    } else {
      setState(() {
        daftarMakanan = [];
        kalori = 0;
        isDataLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: appbar(username, context),
      body: columnHome(context),
    );
  }

  Widget columnHome(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              DateFormat('d MMMM y', 'id_ID').format(DateTime.now()),
              style: AppTextStyles.bb,
            ),
            const SizedBox(height: 20),
            komponenIndikator(context),
            const SizedBox(height: 20),
            kartuDaftarMakanan(context),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Center komponenIndikator(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: indikatorKalori(),
      ),
    );
  }

  Widget indikatorKalori() {
    double now = daftarMakanan.fold(0.0, (sum, item) {
      if (item['diMakan'] == true) {
        return sum + (item['kalori'] ?? 0);
      }
      return sum;
    });

    double percent = now / totalKalori;

    Color progressColor;
    String statusText;

    if (percent < 0.25) {
      progressColor = Colors.red;
      statusText = 'Wah, asupan kalori harian Anda masih kurang nih.';
    } else if (percent < 0.75) {
      progressColor = Colors.orange;
      statusText = 'Progress yang sangat baik!';
    } else if (percent < 1.00) {
      progressColor = const Color(0xFF399F44);
      statusText = 'Hebat! Asupan kalori Anda cukup untuk hari ini.';
    } else if (percent == 1.00) {
      progressColor = const Color(0xFF399F44);
      statusText = 'Wow, Asupan harian Anda sangat sempurna!';
    } else {
      progressColor = Colors.red;
      statusText =
          'Asupan kalori harian Anda melebihi batas yang direkomendasikan!';
    }

    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircularPercentIndicator(
              radius: 80.0,
              lineWidth: 18.0,
              percent: percent.clamp(0.0, 1.0),
              backgroundColor: const Color(0xFFD9D9D9),
              progressColor: progressColor,
              circularStrokeCap: CircularStrokeCap.butt,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Text.rich(
                    TextSpan(
                      text: '${now.toInt()}',
                      style: AppTextStyles.cb,
                      children: [
                        TextSpan(
                          text: '/${totalKalori.toInt()}',
                          style: AppTextStyles.cb,
                        ),
                        const TextSpan(text: ' kal', style: AppTextStyles.cr),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  IconButton(
                    onPressed: editTotalKal,
                    icon: const Icon(Icons.edit, size: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 24),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(statusText, style: AppTextStyles.cr)],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future editTotalKal() {
    TextEditingController controller = TextEditingController();
    String? errorText;

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Edit Kalori", style: AppTextStyles.bb),
              content: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Masukkan Jumlah Kalori",
                  errorText: errorText,
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Batalkan"),
                    ),
                    TextButton(
                      onPressed: () {
                        int? newTotal = int.tryParse(controller.text);
                        if (newTotal != null && newTotal > 0) {
                          setState(() {
                            totalKalori = newTotal;
                            saveDataToFirebase();
                          });
                          Navigator.of(context).pop();
                        } else {
                          setStateDialog(() {
                            errorText = "Input tidak valid";
                          });
                        }
                      },
                      child: const Text("Simpan"),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Center kartuDaftarMakanan(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20, right: 40, left: 40),
              child: ElevatedButton(
                onPressed: () async {
                  final items = await pilihMakanan();
                  if (items != null) {
                    final berat = items['berat'] ?? 0;
                    final nama = items['nama'] ?? '';

                    final snapshot = await DatabaseServices().read(
                      path: 'makanan/$nama',
                    );

                    if (snapshot != null) {
                      final data = snapshot.value as Map<dynamic, dynamic>;
                      final kaloriPerGram = data['kalori'] ?? 1;
                      final kalori = berat * kaloriPerGram;
                      final gambar = data['gambar'] ?? 'rice.png';

                      setState(() {
                        daftarMakanan.add({
                          'nama': nama,
                          'gambar': gambar,
                          'berat': berat,
                          'kalori': kalori,
                          'diMakan': false,
                        });
                        saveDataToFirebase();
                      });
                    } else {
                      //print("data makanan tidak ada: $nama");
                    }
                  }
                },
                style: ElevatedButton.styleFrom(shape: const CircleBorder()),
                child: const Icon(Icons.add, size: 32),
              ),
            ),
            if (daftarMakanan.isEmpty)
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  "Ayo Tambahkan Makanan yang ingin dikonsumsi hari ini!",
                  style: AppTextStyles.cb,
                  textAlign: TextAlign.center,
                ),
              ),

            if (daftarMakanan.isNotEmpty) ...[
              const SizedBox(height: 20),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                height: MediaQuery.of(context).size.height * 0.263,
                child: ListView.builder(
                  itemCount: daftarMakanan.length,
                  itemBuilder: (context, index) {
                    final item = daftarMakanan[index];
                    String gambar = 'assets/img/${item['gambar']}';
                    int berat = item['berat'] ?? 0;
                    int kalori = (item['kalori'] as num).toInt();
                    bool diMakan = item['diMakan'] ?? false;

                    return listMakanan(
                      gambar,
                      '$berat gram',
                      '$kalori kal',
                      diMakan,
                      () {
                        setState(() {
                          daftarMakanan.removeAt(index);
                        });
                        saveDataToFirebase();
                      },
                      (bool? value) {
                        setState(() {
                          daftarMakanan[index]['diMakan'] = value ?? false;
                        });
                        saveDataToFirebase();
                      },
                    );
                  },
                ),
              ),
            ],

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget listMakanan(
    String imagePath,
    String berat,
    String kalori,
    bool isChecked,
    VoidCallback onDelete,
    ValueChanged<bool?> onChecked,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFC2E1C5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imagePath,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),

          Text(berat, style: AppTextStyles.cb),
          Text(kalori, style: AppTextStyles.cb),

          //user menekan checkbox untuk menambahkan nilai variabel now di widget indikatorKalori
          Checkbox(value: isChecked, onChanged: onChecked),

          //hapus makanan
          if (isChecked == false)
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.remove_circle_outline),
            ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>?> pilihMakanan() =>
      showDialog<Map<String, dynamic>>(
        context: context,
        builder: (context) {
          final TextEditingController namaMakanan = TextEditingController();
          final TextEditingController beratMakanan = TextEditingController();

          double kalori = 0;
          double kaloriPerGram = 0;

          String? errorNama;
          String? errorBerat;

          return StatefulBuilder(
            builder: (context, setState) {
              Future<void> updateKalori() async {
                final nama = namaMakanan.text.trim().toLowerCase();
                final berat = int.tryParse(beratMakanan.text) ?? 0;

                setState(() {
                  errorNama = null;
                  errorBerat = null;
                });

                final snapshot = await DatabaseServices().read(
                  path: 'makanan/$nama',
                );

                if (snapshot != null) {
                  final data = snapshot.value as Map<dynamic, dynamic>?;
                  if (data != null && data['kalori'] != null) {
                    kaloriPerGram = (data['kalori'] as num).toDouble();
                  } else {
                    kaloriPerGram = 0;
                  }
                } else {
                  setState(() => errorNama = "Makanan tidak ditemukan");
                  kaloriPerGram = 0;
                }

                setState(() {
                  kalori = kaloriPerGram * berat;
                });
              }

              return AlertDialog(
                title: const Text("Pilih Makanan", style: AppTextStyles.bb),
                content: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.30,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextField(
                        controller: namaMakanan,
                        style: AppTextStyles.cr,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: const Icon(Icons.search),
                          hintText: 'Temukan Menu Makanan',
                          hintStyle: AppTextStyles.cr,
                          errorText: errorNama,
                        ),
                        onChanged: (value) {
                          final input = value.trim().toLowerCase();
                          if (input.isEmpty) {
                            setState(() {
                              filteredMakanan = [];
                            });
                            return;
                          }

                          final results =
                              semuaMakanan
                                  .where(
                                    (food) =>
                                        food.toLowerCase().contains(input),
                                  )
                                  .toList();

                          results.sort((a, b) {
                            final aLower = a.toLowerCase();
                            final bLower = b.toLowerCase();
                            final startsWithA = aLower.startsWith(input);
                            final startsWithB = bLower.startsWith(input);
                            if (startsWithA && !startsWithB) return -1;
                            if (!startsWithA && startsWithB) return 1;
                            return aLower.compareTo(bLower);
                          });

                          final uniqueResults = results.toSet().toList();

                          setState(() {
                            filteredMakanan = uniqueResults.take(3).toList();
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      Visibility(
                        visible: filteredMakanan.isNotEmpty,
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        child: Column(
                          children: [
                            const Text("Saran Makanan:", style: AppTextStyles.cr),
                            const SizedBox(height: 20),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children:
                                  filteredMakanan.map((suggestion) {
                                    return GestureDetector(
                                      onTap: () {
                                        namaMakanan.text = suggestion;
                                        updateKalori();
                                        setState(() => filteredMakanan = []);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                        child: Text(
                                          suggestion,
                                          style: AppTextStyles.cr.copyWith(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: beratMakanan,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.right,
                              style: AppTextStyles.cr,
                              decoration: InputDecoration(
                                hintText: 'Masukkan jumlah',
                                hintStyle: AppTextStyles.cr,
                                errorText: errorBerat,
                                errorStyle: AppTextStyles.cr,
                              ),
                              onChanged: (value) {
                                updateKalori();
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text("Gram"),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Total Kalori: ${kalori.toStringAsFixed(0)}",
                        style: AppTextStyles.cr,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Batalkan"),
                      ),
                      TextButton(
                        onPressed: () {
                          String finalNama = namaMakanan.text.trim();
                          int? finalBerat = int.tryParse(beratMakanan.text);

                          bool valid = true;

                          setState(() {
                            errorNama = null;
                            errorBerat = null;

                            if (finalNama.isEmpty) {
                              errorNama = "Input tidak valid";
                              valid = false;
                            }

                            if (finalBerat == null || finalBerat <= 0) {
                              errorBerat = "Input tidak valid";
                              valid = false;
                            }
                          });

                          if (valid) {
                            Navigator.of(context).pop({
                              'nama': finalNama,
                              'berat': finalBerat!,
                              'kalori': kalori.toInt(),
                            });
                            namaMakanan.clear();
                            filteredMakanan = [];
                          }

                          saveDataToFirebase();
                        },
                        child: const Text("Tambahkan"),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      );

  Future<List<String>> getMakananDb() async {
    final snapshot = await DatabaseServices().read(path: 'makanan');
    if (snapshot != null && snapshot.value is Map) {
      return (snapshot.value as Map).keys.cast<String>().toList();
    }
    return [];
  }
}
