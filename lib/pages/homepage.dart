import 'package:flutter/material.dart';
import 'package:nutriplan/gradient_scaffold.dart';
import 'package:nutriplan/text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int indexNavigasi = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      columnHome(context),
      const Text('Kelender'),
      const Text('Profile'),
    ];

    return GradientScaffold(
      appBar: appBar(),
      body: IndexedStack(index: indexNavigasi, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            indexNavigasi = index;
          });
        },
        currentIndex: indexNavigasi,
        type: BottomNavigationBarType.shifting,
        unselectedItemColor: Color(0xFFA4A4AD),
        selectedItemColor: Color(0xFF61B269),
        selectedLabelStyle: AppTextStyles.cb,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Kalender',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Akun',
          ),
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      leading: GestureDetector(
        onTap: () {},
        child: Align(
          alignment: Alignment.centerRight,
          child: CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/img/danyi_profile.png'),
          ),
        ),
      ),
      title: Text('Hai, User', style: AppTextStyles.h5b),
      actions: [
        GestureDetector(
          onTap: () {},
          child: SizedBox(
            width: 60,
            child: SvgPicture.asset(
              'assets/icons/notif.svg',
              height: 35,
              width: 35,
            ),
          ),
        ),
      ],
    );
  }

  Widget columnHome(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Text('5 januari 2025', style: AppTextStyles.bb),
          SizedBox(height: 20),
          komponenIndikator(context),
          SizedBox(height: 20),
          kartuDaftarMakanan(context),
          SizedBox(height: 20),
          SizedBox(height: 20),
        ],
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
    double now = 800;
    double total = 2000;
    double percent = now / total;

    Color progressColor;
    String statusText;

    if (percent < 0.25) {
      progressColor = Colors.red;
      statusText = 'Wah, asupan kalori harian anda masih kurang nih.';
    } else if (percent < 0.75) {
      progressColor = Colors.orange;
      statusText = 'Progress yang sangat baik!';
    } else {
      progressColor = Color(0xFF399F44);
      statusText = 'Hebat! Asupan kalori anda cukup untuk hari ini.';
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
                  Text.rich(
                    TextSpan(
                      text: '${now.toInt()}',
                      style: AppTextStyles.cb,
                      children: [
                        TextSpan(
                          text: '/${total.toInt()}',
                          style: AppTextStyles.cb,
                        ),
                        TextSpan(text: ' kal', style: AppTextStyles.cr),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4),
                  Icon(Icons.edit, size: 16),
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
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: TextField(
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
                  suffixIcon: Transform.scale(
                    scale: 1,
                    child: Icon(Icons.search),
                  ),
                  hintText: 'Temukan Menu Makanan',
                  hintStyle: AppTextStyles.cr,
                ),
              ),
            ),

            SizedBox(height: 20),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.height * 0.263,
              child: ListView(
                children: [
                  listMakanan(
                    'assets/img/rice.png',
                    '120 gr',
                    '120 kal',
                    false,
                  ),
                  listMakanan(
                    'assets/img/fruit.png',
                    '120 gr',
                    '120 kal',
                    false,
                  ),
                  listMakanan(
                    'assets/img/chicken.png',
                    '120 gr',
                    '120 kal',
                    false,
                  ),
                  listMakanan(
                    'assets/img/chicken.png',
                    '120 gr',
                    '120 kal',
                    false,
                  ),
                ],
              ),
            ),

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
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xFFC2E1C5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

          //tombol cek
          Checkbox(value: isChecked, onChanged: (value) {}),

          //tombol hapus
          IconButton(onPressed: () {}, icon: Icon(Icons.remove_circle_outline)),
        ],
      ),
    );
  }
}
