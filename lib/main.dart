import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nutriplan/cek_otentifikasi.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:nutriplan/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';
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

  await NotificationService.init();

  await requestNotificationPermission();

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

Future<void> requestNotificationPermission() async {
  final androidInfo = await DeviceInfoPlugin().androidInfo;
  if (androidInfo.version.sdkInt >= 33) {
    final status = await Permission.notification.status;
    if (!status.isGranted) {
      final result = await Permission.notification.request();
      print('Notification permission granted: $result');
    } else {
      print('Notification permission already granted');
    }
  }
}
