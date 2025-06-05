import 'package:flutter/material.dart';
import 'package:nutriplan/pages/home_page.dart';
import 'package:nutriplan/widgets/gradient_scaffold.dart';
import 'package:nutriplan/pages/kalender_page.dart';
import 'package:nutriplan/widgets/text_styles.dart';
import 'package:nutriplan/pages/profile_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int indexNavigasi = 0;

  List<Widget> pageList = const [Beranda(), KalenderPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: IndexedStack(index: indexNavigasi, children: pageList),
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
}
