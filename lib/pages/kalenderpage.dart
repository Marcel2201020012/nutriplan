import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:nutriplan/models/data_historis.dart';
import 'package:nutriplan/widgets/app_bar.dart';
import 'package:nutriplan/widgets/gradient_scaffold.dart';
import 'package:nutriplan/widgets/text_styles.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class KalenderPage extends StatefulWidget {
  const KalenderPage({super.key});

  @override
  State<KalenderPage> createState() => _KalenderPageState();
}

class _KalenderPageState extends State<KalenderPage> {
  final TextEditingController finalTanggal = TextEditingController();
  bool tanggalSelected = false;

  List<Map<String, dynamic>> daftarMakanan = [];
  int totalKalori = 0;
  int kalori = 0;
  bool isDataLoaded = false;

  Future<void> loadHistorisData(String date) async {
    final box = await Hive.openBox<DataHistoris>("DataHistorisBox");
    final data = box.get(date);

    if (data != null) {
      setState(() {
        daftarMakanan = data.daftarMakanan;
        totalKalori = data.totalKalori.toInt();
        kalori = data.kalori.toInt();
        isDataLoaded = true;
      });
    } else {
      setState(() {
        daftarMakanan = [];
        totalKalori = 0;
        kalori = 0;
        isDataLoaded = true;
      });
    }
  }

  @override
  void dispose() {
    finalTanggal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: appbar(),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextField(
                      controller: finalTanggal,
                      decoration: InputDecoration(
                        labelText: "Pilih Tanggal",
                        prefixIcon: Icon(Icons.calendar_month),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? tanggal = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2025),
                          lastDate: DateTime(2100),
                        );

                        if (tanggal != null) {
                          String temp = tanggal.toString().split(" ")[0];
                          setState(() {
                            finalTanggal.text = temp;
                            tanggalSelected = true;
                          });
                          await loadHistorisData(temp);
                        }
                      },
                    ),
                  ),
                ),
                if (finalTanggal.text.isNotEmpty) ...[
                  SizedBox(height: 20),
                  historisPage(context),
                  SizedBox(height: 20),
                ],

                if (tanggalSelected == false) ...[
                  SizedBox(height: 20),
                  Text(
                    "Pilih Tanggal Untuk Melihat Histori Menu Makanan dan Kalori Anda!",
                    style: AppTextStyles.bb,
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget historisPage(BuildContext context) {
    double percent = kalori / totalKalori;
    Color progressColor;

    if (percent < 0.25) {
      progressColor = Colors.red;
    } else if (percent < 0.75) {
      progressColor = Colors.orange;
    } else if (percent < 1.00) {
      progressColor = Color(0xFF399F44);
    } else {
      progressColor = Colors.red;
    }

    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 20),
          CircularPercentIndicator(
            radius: 80,
            lineWidth: 18,
            percent: percent.clamp(0.0, 1.0),
            progressColor: progressColor,
            backgroundColor: Color(0xFFD9D9D9),
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text.rich(
                  TextSpan(
                    text: '$kalori',
                    style: AppTextStyles.cb,
                    children: [
                      TextSpan(text: '/$totalKalori', style: AppTextStyles.cb),
                      TextSpan(text: ' kal', style: AppTextStyles.cr),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 20),

          if (daftarMakanan.isNotEmpty) ...[
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
                  );
                },
              ),
            ),
            SizedBox(height: 20),
          ],

          if (daftarMakanan.isEmpty) ...[
            Text(
              "Oops, sepertinya Anda tidak mencatat menu makanan Anda di hari ini...",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  Widget listMakanan(
    String imagePath,
    String weight,
    String calories,
    bool isChecked,
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
          Checkbox(value: isChecked, onChanged: (value) {}),
        ],
      ),
    );
  }
}
