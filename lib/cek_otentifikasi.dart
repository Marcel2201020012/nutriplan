import 'package:flutter/material.dart';
import 'package:nutriplan/auth_services.dart';
import 'package:nutriplan/database_services.dart';
import 'package:nutriplan/pages/calculation_page.dart';
import 'package:nutriplan/pages/initial_page.dart';
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
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator.adaptive());
            } else if (snapshot.hasData) {
              final uid = snapshot.data?.uid;

              return FutureBuilder(
                future: checkIsProfileComplete(uid),
                builder: (context, profileSnapshot) {
                  if (profileSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator.adaptive());
                  } else if (profileSnapshot.hasData &&
                      profileSnapshot.data == true) {
                    // return MainScreen();
                    return CalculationPage();
                  } else {
                    return InitialPage();
                  }
                },
              );
            } else {
              return LoginPage();
            }
          },
        );
      },
    );
  }

  Future<bool> checkIsProfileComplete(String? uid) async {
    if (uid == null) return false;

    final ref = DatabaseServices.ref('users/$uid/profile');
    final snapshot = await ref.get();

    if (snapshot.exists && snapshot.child('isProfileComplete').value == true) {
      return true;
    } else {
      return false;
    }
  }
}
