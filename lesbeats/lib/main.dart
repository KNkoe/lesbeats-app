import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lesbeats/screens/home/home.dart';
import 'package:lesbeats/screens/login.dart';
import 'package:lesbeats/screens/signup.dart';
import 'package:lesbeats/widgets/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lesbeats/wrapper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';

final storage = FirebaseStorage.instance;
final db = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;
final messaging = FirebaseMessaging.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    EasyDynamicThemeWidget(
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lesbeats',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: EasyDynamicTheme.of(context).themeMode!,
      initialRoute: '/',
      routes: {
        '/': (context) => const Wrapper(),
        '/home': (context) => const MyHomePage(),
        '/login': (context) => const MyLoginPage(),
        '/signup': (context) => const MySignupPage()
      },
    );
  }
}
