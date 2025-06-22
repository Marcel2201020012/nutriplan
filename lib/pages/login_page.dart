import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nutriplan/services/auth_services.dart';
import 'package:nutriplan/pages/daftar_page.dart';
import 'package:nutriplan/pages/lupa_password_page.dart';
import 'package:nutriplan/widgets/gradient_scaffold.dart';
import 'package:nutriplan/widgets/text_styles.dart';

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

  bool hidePassword = true;

  @override
  void initState() {
    super.initState();
    emailController.clear();
    passwrodController.clear();
    error = '';
  }

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
      //(e.message);
    }
  }

  void resetPassword() async {
    try {
      await authServices.value.lupaPasword(email: emailController.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        error = e.message ?? "";
      });
      //print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    double logoWidth =
        kIsWeb
            ? MediaQuery.of(context).size.width * 0.15
            : MediaQuery.of(context).size.width * 0.3;

    double formWidth =
        kIsWeb
            ? MediaQuery.of(context).size.width * 0.5
            : MediaQuery.of(context).size.width * 0.7;

    return GradientScaffold(
      appBar: AppBar(
        title: const Text("Login", style: AppTextStyles.h5b),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: SizedBox(
          width: formWidth,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10,
              ),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/img/logo.png', width: logoWidth),
                        const SizedBox(height: 24),

                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              hintText: "Email",
                              prefixIcon: const Icon(Icons.email_outlined),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 18,
                                horizontal: 20,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Colors.blue.shade400,
                                  width: 2,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Masukkan email';
                              }

                              // Email format check (simple pattern)
                              final emailRegex = RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              );
                              if (!emailRegex.hasMatch(value)) {
                                return 'Format email tidak valid';
                              }

                              return null; // valid
                            },
                          ),
                        ),

                        const SizedBox(height: 16),

                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: passwrodController,
                            obscureText: hidePassword,
                            decoration: InputDecoration(
                              hintText: "Password",
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  hidePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    hidePassword = !hidePassword;
                                  });
                                },
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 18,
                                horizontal: 20,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Colors.blue.shade400,
                                  width: 2,
                                ),
                              ),
                            ),
                            validator:
                                (value) =>
                                    value == null || value.length < 6
                                        ? 'Password minimal 6 karakter'
                                        : null,
                          ),
                        ),

                        const SizedBox(height: 10),

                        if (error.isNotEmpty)
                          Text(
                            error,
                            style: const TextStyle(color: Colors.redAccent),
                          ),

                        const SizedBox(height: 10),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const LupaPasswordPage(),
                                ),
                              );
                            },
                            child: const Text(
                              "Lupa Password?",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Login Button
                        SizedBox(
                          width: 200,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                login();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            child: const Text("Login"),
                          ),
                        ),

                        const SizedBox(height: 10),

                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DaftarPage(),
                              ),
                            );
                          },
                          child: const Text("Belum punya akun? Daftar"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
