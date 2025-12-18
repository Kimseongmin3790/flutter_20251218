import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GoogleSignIn.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<UserCredential?> googleLogin() async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance.authenticate();

      final googleAuth = googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) {
        debugPrint('Google idToken is null');
        return null;
      }

      final credential = GoogleAuthProvider.credential(idToken: idToken);
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on GoogleSignInException catch (e) {
      debugPrint('GoogleSignInException: ${e.code} / ${e.description}');
      return null;
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('구글 로그인')),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.login),
          label: const Text('구글로 로그인'),
          onPressed: () async {
            final userCredential = await googleLogin();

            if (!context.mounted) return;

            if (userCredential != null) {
              final user = userCredential.user;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${user?.displayName ?? '사용자'}님 환영합니다!'),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('로그인 취소 or 실패')),
              );
            }
          },
        ),
      ),
    );
  }
}