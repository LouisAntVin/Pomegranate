import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pomegranate/branch.dart';
import 'package:pomegranate/firebase_options.dart';
import 'package:pomegranate/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        backgroundColor: Color(0xFF30303B),


      ),
      home: Login(),
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Branch(),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF30303B),
      body: Center(
        child: Column(
          children: [
            Image.network(
                "https://png.pngtree.com/png-vector/20220709/ourmid/pngtree-half-of-pomegranate-icon-png-image_5592439.png"),
            Text(
              "Pomegranate",
              style: TextStyle(
                fontFamily: 'Helvatica',
                fontSize: 34,
                fontWeight: FontWeight.w500,
                color: Color(0xfff44336),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
