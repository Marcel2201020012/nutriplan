import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

ValueNotifier<AuthServices> authServices = ValueNotifier(AuthServices());

class AuthServices {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => firebaseAuth.currentUser;

  String? get currentUid => FirebaseAuth.instance.currentUser?.uid;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> daftar({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> lupaPasword({required String email}) async {
    return await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<void> hapusAkun({
    required String email,
    required String password,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.delete();
    await firebaseAuth.signOut();
  }
}
