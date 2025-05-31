import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:nutriplan/models/data_historis.dart';
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
  List<Map<String, dynamic>> daftarMakanan = [];
  double totalKalori = 0;
  int kalori = 0;
  bool isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    loadHistorisData(today);
  }

  void saveData() async {
    final box = await Hive.openBox<DataHistoris>("DataHistorisBox");
    final nowDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    double now = daftarMakanan.fold(0.0, (sum, item) {
      if (item['diMakan'] == true) {
        return sum + (item['kalori'] ?? 0);
      }
      return sum;
    });

    final dataMakanan = DataHistoris(
      daftarMakanan: daftarMakanan,
      totalKalori: totalKalori,
      kalori: now,
    );

    await box.put(nowDate, dataMakanan);
  }

  void loadHistorisData(String date) async {
    final box = await Hive.openBox<DataHistoris>("DataHistorisBox");
    final data = box.get(date);

    if (data != null) {
      setState(() {
        daftarMakanan = data.daftarMakanan;
        totalKalori = data.totalKalori;
        kalori = data.kalori.toInt();
        isDataLoaded = true;
      });
    } else {
      setState(() {
        daftarMakanan = [];
        totalKalori = 2000; //dummy data, nanti diganti waktu udh buat initial page
        kalori = 0;
        isDataLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(appBar: appbar(), body: columnHome(context));
  }

  Widget columnHome(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              DateFormat('d MMMM y', 'id_ID').format(DateTime.now()),
              style: AppTextStyles.bb,
            ),
            SizedBox(height: 20),
            komponenIndikator(context),
            SizedBox(height: 20),
            kartuDaftarMakanan(context),
            SizedBox(height: 20),
            SizedBox(height: 20),
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
          boxShadow: [
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
      progressColor = Color(0xFF399F44);
      statusText = 'Hebat! Asupan kalori Anda cukup untuk hari ini.';
    } else if (percent == 1.00) {
      progressColor = Color(0xFF399F44);
      statusText = 'Wow, Asupan harian Anda sangat sempurna!';
    }else {
      progressColor = Colors.red;
      statusText =
          'Asupan kalori harian Anda melebihi batas yang direkomendasikan!';
    }

    return Card(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            CircularPercentIndicator(
              radius: 80.0,
              lineWidth: 18.0,
              percent: percent.clamp(0.0, 1.0),
              backgroundColor: Color(0xFFD9D9D9),
              progressColor: progressColor,
              circularStrokeCap: CircularStrokeCap.butt,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Text.rich(
                    TextSpan(
                      text: '${now.toInt()}',
                      style: AppTextStyles.cb,
                      children: [
                        TextSpan(
                          text: '/${totalKalori.toInt()}',
                          style: AppTextStyles.cb,
                        ),
                        TextSpan(text: ' kal', style: AppTextStyles.cr),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4),
                  IconButton(
                    onPressed: editTotalKal,
                    icon: Icon(Icons.edit, size: 16),
                  ),
                ],
              ),
            ),

            SizedBox(width: 24),

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
              title: Text("Edit Kalori", style: AppTextStyles.bb),
              content: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Masukkan Jumlah Kalori",
                  errorText: errorText, // shows red text and border
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
                      child: Text("Batalkan"),
                    ),
                    TextButton(
                      onPressed: () {
                        double? newTotal = double.tryParse(controller.text);
                        if (newTotal != null && newTotal > 0) {
                          setState(() {
                            totalKalori = newTotal;
                            saveData();
                          });
                          Navigator.of(context).pop();
                        } else {
                          setStateDialog(() {
                            errorText = "Input tidak valid";
                          });
                        }
                      },
                      child: Text("Simpan"),
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
          boxShadow: [
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
              margin: EdgeInsets.only(top: 20, right: 40, left: 40),
              child: ElevatedButton(
                onPressed: () async {
                  final items = await pilihMakanan();
                  if (items != null) {
                    setState(() {
                      final berat = items['berat'] ?? 0;
                      final nama = items['nama'] ?? '';
                      final kaloriPerGram = (nama == 'ayam') ? 12 : 1;
                      final kalori = berat * kaloriPerGram;

                      daftarMakanan.add({
                        'nama': nama,
                        'berat': berat,
                        'kalori': kalori,
                        'diMakan': false,
                      });

                      saveData();
                    });
                  }
                },
                style: ElevatedButton.styleFrom(shape: const CircleBorder()),
                child: Icon(Icons.add, size: 32),
              ),
            ),
            if (daftarMakanan.isEmpty)
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  "Ayo Tambahkan Makanan yang ingin dikonsumsi hari ini!",
                  style: AppTextStyles.cb,
                  textAlign: TextAlign.center,
                ),
              ),

            if (daftarMakanan.isNotEmpty) ...[
              SizedBox(height: 20),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                height: MediaQuery.of(context).size.height * 0.263,
                child: ListView.builder(
                  itemCount: daftarMakanan.length,
                  itemBuilder: (context, index) {
                    final item = daftarMakanan[index];
                    String gambar =
                        item['nama'] == 'ayam'
                            ? 'assets/img/chicken.png'
                            : 'assets/img/rice.png';
                    int berat = item['berat'] ?? 0;
                    int kalori = item['kalori'] ?? 0;
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
                        saveData();
                      },
                      (bool? value) {
                        setState(() {
                          daftarMakanan[index]['diMakan'] = value ?? false;
                        });
                        saveData();
                      },
                    );
                  },
                ),
              ),
            ],

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget listMakanan(
    String imagePath,
    String weight,
    String calories,
    bool isChecked,
    VoidCallback onDelete,
    ValueChanged<bool?> onChecked,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xFFC2E1C5),
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

          Text(weight, style: AppTextStyles.cb),
          Text(calories, style: AppTextStyles.cb),

          //user menekan checkbox untuk menambahkan nilai variabel now di widget indikatorKalori
          Checkbox(value: isChecked, onChanged: onChecked),

          //hapus makanan
          if (isChecked == false)
            IconButton(
              onPressed: onDelete,
              icon: Icon(Icons.remove_circle_outline),
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
          final Map<String, double> makananData = {'ayam': 12.0};

          String? errorNama;
          String? errorBerat;

          return StatefulBuilder(
            builder: (context, setState) {
              void updateKalori() {
                final nama = namaMakanan.text.trim().toLowerCase();
                final berat = int.tryParse(beratMakanan.text) ?? 0;

                setState(() {
                  errorNama = null;
                  errorBerat = null;

                  if (makananData.containsKey(nama)) {
                    kaloriPerGram = makananData[nama]!;
                  } else {
                    kaloriPerGram = 0;
                  }

                  kalori = kaloriPerGram * berat;
                });
              }

              return AlertDialog(
                title: Text("Pilih Makanan", style: AppTextStyles.bb),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextField(
                        controller: namaMakanan,
                        autofocus: true,
                        style: AppTextStyles.cr,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: Icon(Icons.search),
                          hintText: 'Temukan Menu Makanan',
                          hintStyle: AppTextStyles.cr,
                          errorText: errorNama,
                        ),
                        onChanged: (value) => updateKalori(),
                      ),
                      SizedBox(height: 20),
                      Text("${kalori.toStringAsFixed(0)} Kalori/Gram"),
                      SizedBox(height: 20),
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
                              onChanged: (value) => updateKalori(),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text("Gram"),
                        ],
                      ),
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
                        child: Text("Batalkan"),
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
                          }
                        },
                        child: Text("Tambahkan"),
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
