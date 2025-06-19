import 'package:flutter/material.dart';
import 'package:nutriplan/services/auth_services.dart';
import 'package:nutriplan/services/database_services.dart';
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
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            if (!snapshot.hasData) {
              return const LoginPage();
            }

            final uid = snapshot.data?.uid;

            return FutureBuilder<Map<String, dynamic>?>(
              future: getProfileStatus(uid),
              builder: (context, profileSnapshot) {
                if (profileSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }

                final profileData = profileSnapshot.data;

                if (profileData == null) {
                  return const InitialPage();
                } else if (profileData['isProfileComplete'] == true) {
                  return const MainScreen();
                } else {
                  return const CalculationPage();
                }
              },
            );
          },
        );
      },
    );
  }

  Future<Map<String, dynamic>?> getProfileStatus(String? uid) async {
    if (uid == null) return null;

    final ref = DatabaseServices.ref('users/$uid/profile');
    final snapshot = await ref.get();

    if (!snapshot.exists) return null;

    final data = Map<String, dynamic>.from(snapshot.value as Map);
    return data;
  }
}
