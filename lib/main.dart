import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nutriplan/cek_otentifikasi.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'models/data_historis.dart';

void main() async {
  //inisialisasi package date
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  //inisialisasi penyimpanan lokal hive
  await Hive.initFlutter();
  Hive.registerAdapter(DataHistorisAdapter());
  await Hive.openBox<DataHistoris>("DataHistorisBox");

  await Hive.openBox("UserProfile");

  //inisialisasi firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Nunito'),

      //aktivasi fitur login
      home: CekOtentifikasi(),
    );
  }
}
