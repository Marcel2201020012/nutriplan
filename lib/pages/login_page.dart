import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutriplan/auth_services.dart';
import 'package:nutriplan/pages/daftar_page.dart';
import 'package:nutriplan/pages/lupa_password_page.dart';
import 'package:nutriplan/widgets/gradient_scaffold.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwrodController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String error = "";

  @override
  void dispose() {
    emailController.dispose();
    passwrodController.dispose();
    super.dispose();
  }

  void login() async {
    try {
      await authServices.value.signIn(
        email: emailController.text,
        password: passwrodController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        error = e.message ?? "";
      });
      print(e.message);
    }
  }

  void resetPassword() async {
    try {
      await authServices.value.lupaPasword(email: emailController.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        error = e.message ?? "";
      });
      print(e.message);
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LupaPasswordPage(),
                        ),
                      );
                    },
                    child: Text("Lupa Password"),
                  ),
                  TextButton(
                    onPressed: () {
                      login();
                    },
                    child: Text("Login"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DaftarPage()),
                      );
                    },
                    child: Text("Daftar"),
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
