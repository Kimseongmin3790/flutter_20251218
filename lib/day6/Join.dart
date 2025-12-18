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
      home: SignUpPage(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String gender = 'M';
  final FirebaseFirestore fs = FirebaseFirestore.instance;
  final TextEditingController _idCtrl = TextEditingController();
  final TextEditingController _pwdCtrl = TextEditingController();
  final TextEditingController _pwdCheckCtrl = TextEditingController();
  final TextEditingController _nameCtrl = TextEditingController();
  bool joinFlg = false;

  Future<void> idCheck() async{
    var checked = await fs.collection("member")
        .where("memberId", isEqualTo: _idCtrl.text).get();
    if (checked.docs.isEmpty) {
      setState(() {
        joinFlg = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("사용 가능한 아이디"))
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("사용 중인 아이디입니다"))
      );
    }
  }

  Future<void> join() async{

    if (_pwdCtrl.text != _pwdCheckCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("비밀번호가 다릅니다"))
      );
      return;
    }

    if (_idCtrl.text.isEmpty || _pwdCtrl.text.isEmpty || _nameCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("빈값이 있습니다"))
      );
      return;
    }

    await fs.collection("member").add({
      "memberId" : _idCtrl.text,
      "pwd" : _pwdCtrl.text,
      "name" : _nameCtrl.text,
      "gender" : gender
    });
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("회원가입 성공!"))
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 10),

                // 아이디, 중복체크
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        enabled: joinFlg ? false : true,
                        controller: _idCtrl,
                        decoration: InputDecoration(
                          labelText: '아이디',
                          hintText: '아이디를 입력하세요',
                          prefixIcon: Icon(Icons.person_outline),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: idCheck,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                        ),
                        child: Text('중복체크'),
                      ),
                    ),
                  ],
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
                SizedBox(height: 16),

                // 비밀번호 확인
                TextField(
                  controller: _pwdCheckCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: '비밀번호 확인',
                    hintText: '비밀번호를 다시 입력하세요',
                    prefixIcon: Icon(Icons.lock_reset_outlined),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                // 이름
                TextField(
                  controller: _nameCtrl,
                  decoration: InputDecoration(
                    labelText: '이름',
                    hintText: '홍길동',
                    prefixIcon: Icon(Icons.person),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                // 성별
                Text(
                  '성별',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                        title: Text('남자'),
                        value: 'M',
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        title: Text('여자'),
                        value: 'F',
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value!;
                          });
                        },
                        dense: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                // 회원가입 버튼
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: joinFlg ? join : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      '회원가입',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}