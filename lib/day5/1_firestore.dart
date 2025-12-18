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
    final FirebaseFirestore fs = FirebaseFirestore.instance;
    // fs객체를 통해 collection 접근
    // users컬렉션에 접근하고 싶으면 fs.collection("users")
    // users컬렉션 삽입 -> fs.collection("users").add()
    // users컬렉션 목록 -> fs.collection("users").get()
    // users컬렉션 수정 -> fs.collection("users").update()
    // users컬렉션 삭제 -> fs.collection("users").delete()

    Future<void> createUser() async{
      // Map<String, dynamic>
      // Map<String, dynamic> user = {
      //   "name" : "홍길동",
      //   "age" : 30,
      //   "addr" : "인천",
      //   "cdate" : Timestamp.now()
      // };
      // await fs.collection("users").add(user);

      // 문서 번호(ID)를 자동 생성 - 대부분 상황에서 권장
      // await fs.collection("users").add({
      //   "name" : "홍길동",
      //   "age" : 30,
      //   "addr" : "인천",
      //   "cdate" : Timestamp.now()
      // });

      // 문서 ID를 직접 생성 - 문서 ID가 중복되면 안되겠죠?
      await fs.collection("users").doc("abcd").set({
        "name" : "홍길동",
        "age" : 30,
        "addr" : "인천",
        "cdate" : Timestamp.now()
      });
    }

    Future<void> readUser() async {
      // 기본
      // final snapshot =  await fs.collection("users").get();

      // final snapshot =
      //         await fs.collection("users")
      //             .orderBy("age", descending: true) // // age필드 기준으로 내림차순
      //             // .orderBy("age") // age필드 기준으로 오름차순
      //             .get();

      final snapshot =
      await fs.collection("users")
      // .where("age", isGreaterThan: 20) // age가 20보단 큰 거
          .where("age", isGreaterThanOrEqualTo: 20) // age가 20 이상
          .orderBy("age")
          .get();
      // print(snapshot.docs[0].data()); // Map<String, dynamic>
      for(var doc in snapshot.docs){
        Map<String, dynamic> data = doc.data();
        print("docId : ${doc.id}, name : ${data["name"]}, age : ${data["age"]}");

      }
    }

    Future<void> updateUser() async {
      await fs.collection("users").doc("zzz").update({
        "name" : "박영희",
        "age" : 20
      });
    }

    Future<void> deleteUser() async {
      await fs.collection("users").doc("abcd").delete();
    }

    return MaterialApp(
      home: Scaffold(
          body : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: createUser, child: Text("삽입")),
                ElevatedButton(onPressed: readUser, child: Text("목록")),
                ElevatedButton(onPressed: updateUser, child: Text("수정")),
                ElevatedButton(onPressed: deleteUser, child: Text("삭제"))
              ],
            ),
          )
      ),
    );
  }
}