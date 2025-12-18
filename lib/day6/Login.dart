import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseFirestore fs = FirebaseFirestore.instance;
  final TextEditingController _idCtrl = TextEditingController();
  final TextEditingController _pwdCtrl = TextEditingController();
  
  Future<void> login() async{
    var member = await fs.collection("member")
        .where("memberId", isEqualTo: _idCtrl.text)
        .where("pwd", isEqualTo: _pwdCtrl.text).get();
    if (member.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("로그인 실패"))
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("로그인 성공"))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('로그인'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 20),

                // 아이디
                TextField(
                  controller: _idCtrl,
                  decoration: InputDecoration(
                    labelText: '아이디',
                    hintText: '아이디를 입력하세요',
                    prefixIcon: Icon(Icons.person_outline),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),

                SizedBox(height: 16),

                // 비밀번호
                TextField(
                  controller: _pwdCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: '비밀번호',
                    hintText: '비밀번호를 입력하세요',
                    prefixIcon: Icon(Icons.lock_outline),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),

                SizedBox(height: 30),

                // 로그인 버튼
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      elevation: 2,
                    ),
                    child: Text(
                      '로그인',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // 하단 안내 텍스트
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '아직 회원이 아니셈?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    SizedBox(width: 6),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        '회원가입',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}