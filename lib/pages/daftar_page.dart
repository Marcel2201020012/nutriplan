import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutriplan/auth_services.dart';
import 'package:nutriplan/cek_otentifikasi.dart';
import 'package:nutriplan/widgets/gradient_scaffold.dart';

class DaftarPage extends StatefulWidget {
  const DaftarPage({super.key});

  @override
  State<DaftarPage> createState() => _DaftarPageState();
}

class _DaftarPageState extends State<DaftarPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwrodController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String error = '';

  @override
  void dispose() {
    emailController.dispose();
    passwrodController.dispose();
    super.dispose();
  }

  void daftarAkun() async {
    try {
      await authServices.value.daftar(
        email: emailController.text,
        password: passwrodController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        error = e.message ?? 'ada yg error';
      });
      //print(e.message);
    }
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
                  TextField(
                    decoration: InputDecoration(hintText: "Password"),
                    controller: passwrodController,
                  ),
                  Text(error, style: TextStyle(color: Colors.redAccent)),
                  TextButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        daftarAkun();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => CekOtentifikasi()),
                        );
                      }
                    },
                    child: Text("Daftar"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Login"),
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
