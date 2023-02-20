import 'package:flutter/material.dart';
import 'package:lesbeats/main.dart';
import 'package:lesbeats/screens/home/home.dart';
import 'package:lesbeats/screens/login.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    if (auth.currentUser == null || !auth.currentUser!.emailVerified) {
      return const MyLoginPage();
    } else {
      return const MyHomePage();
    }
  }
}
