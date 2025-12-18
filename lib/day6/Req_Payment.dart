import 'package:flutter/material.dart';
import 'package:newproject/day6/Payment.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName : '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _ReqPaymentState(),
    );
  }
}

class _ReqPaymentState extends StatefulWidget {
  const _ReqPaymentState({super.key});

  @override
  State<_ReqPaymentState> createState() => _ReqPaymentStateState();
}

class _ReqPaymentStateState extends State<_ReqPaymentState> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => Payment()
                      )
                  );
                },
                child: Text("결제하기")
            )
          ],
        ),
      ),
    );
  }
}
