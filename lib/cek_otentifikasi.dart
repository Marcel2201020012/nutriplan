import 'package:flutter/material.dart';
import 'package:nutriplan/auth_services.dart';
import 'package:nutriplan/pages/login_page.dart';
import 'package:nutriplan/pages/mainscreen.dart';

class CekOtentifikasi extends StatelessWidget {
  const CekOtentifikasi({super.key, this.pageIfNotConnected});

  final Widget? pageIfNotConnected;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: authServices,
      builder: (context, authServices, child) {
        return StreamBuilder(
          stream: authServices.authStateChanges,
          builder: (context, snapshot) {
            Widget widget;
            if (snapshot.connectionState == ConnectionState.waiting) {
              widget = Center(child: CircularProgressIndicator.adaptive());
            } else if (snapshot.hasData) {
              widget = MainScreen();
            } else {
              widget = LoginPage();
            }
            return widget;
          },
        );
      },
    );
  }
}
