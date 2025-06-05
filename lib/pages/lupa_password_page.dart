import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutriplan/auth_services.dart';
import 'package:nutriplan/widgets/gradient_scaffold.dart';

class LupaPasswordPage extends StatefulWidget {
  const LupaPasswordPage({super.key});

  @override
  State<LupaPasswordPage> createState() => _LupaPasswordPageState();
}

class _LupaPasswordPageState extends State<LupaPasswordPage> {
  TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String error = "";

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void resetPassword() async {
    try {
      await authServices.value.lupaPasword(email: emailController.text);
      showPesan();
      setState(() {
        error = "";
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        error = e.message ?? "";
      });
      print(e.message);
    }
  }

  void showPesan() {
    ScaffoldMessenger.of(context).clearMaterialBanners();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Cek Email Anda Untuk Mengatur Ulang Password!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.95,
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Image.asset('assets/img/logo.png'),
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: "Email"),
                    controller: emailController,
                  ),
                  Text(error, style: TextStyle(color: Colors.redAccent)),
                  TextButton(
                    onPressed: () {
                      resetPassword();
                    },
                    child: Text("Ganti Password"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
