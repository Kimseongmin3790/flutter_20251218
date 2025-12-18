import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:newproject/day5/Product_List.dart';
import '../firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Firebase 초기화 설정
  );
  await dotenv.load(fileName : '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AddProduct(),
    );
  }
}

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final FirebaseFirestore fs = FirebaseFirestore.instance;
  final TextEditingController _pName = TextEditingController();
  final TextEditingController _category = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _info = TextEditingController();

  Future<void> createProduct() async{
    await fs.collection("product").add({
      "pName" : _pName.text,
      "category" : _category.text,
      "price" : int.parse(_price.text),
      "info" : _info.text
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('제품 등록'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProductList())
              );
            },
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Colors.blue[300],
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: '등록',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '마이페이지',
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            /// 이미지 등록 영역
            Card(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.camera_alt_outlined,
                        size: 40,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '제품 이미지를 등록해주세요',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            /// 제품 정보 카드
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '제품 정보',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: _pName,
                      decoration: InputDecoration(
                        labelText: '제품명',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: _category,
                      decoration: InputDecoration(
                        labelText: '카테고리',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: _price,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: '가격',
                        prefixText: '₩ ',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            /// 상세 설명 카드
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '상세 설명',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: _info,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: '제품에 대한 설명을 입력해주세요',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            /// 등록 버튼
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: createProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  '제품 등록하기',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}