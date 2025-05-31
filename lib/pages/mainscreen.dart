import 'package:flutter/material.dart';
import 'package:nutriplan/pages/homepage.dart';
import 'package:nutriplan/widgets/gradient_scaffold.dart';
import 'package:nutriplan/pages/kalenderpage.dart';
import 'package:nutriplan/widgets/text_styles.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int indexNavigasi = 0;

  List<Widget> pageList = const[
    Beranda(),
    KalenderPage()
  ];

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