import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:lesbeats/screens/home/home.dart';
import 'package:lesbeats/screens/login.dart';
import 'package:lesbeats/screens/signup.dart';
import 'package:lesbeats/widgets/decoration.dart';
import 'package:lesbeats/widgets/theme.dart';
import 'package:firebase_core/firebase_core.dart';

final storage = FirebaseStorage.instance;
final db = FirebaseFirestore.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  configLoading();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: lightTheme,
      builder: EasyLoading.init(),
      initialRoute: '/login',
      routes: {
        '/': (context) => const MyHomePage(),
        '/login': (context) => const MyLoginPage(),
        '/signup': (context) => const MySignupPage()
      },
    );
  }
}
