import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:nutriplan/services/cek_otentifikasi.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:nutriplan/services/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'firebase/firebase_options.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  //inisialisasi package date
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

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
      home: const CekOtentifikasi(),
    );
  }
}

Future<void> requestNotificationPermission() async {
  final deviceInfo = DeviceInfoPlugin();
  if (kIsWeb) {
    final webInfo = await deviceInfo.webBrowserInfo;
    debugPrint('Running on Web, browser name: ${webInfo.browserName}');
  } else {
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        final status = await Permission.notification.status;
        if (!status.isGranted) {
          final result = await Permission.notification.request();
          debugPrint('Notification permission granted: $result');
        } else {
          debugPrint('Notification permission already granted');
        }
      }
    }
  }
}
