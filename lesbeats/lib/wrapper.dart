import 'package:firebase_auth/firebase_auth.dart';
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
  User? _user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    auth.authStateChanges().listen((User? user) {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return const MyLoginPage();
    } else {
      return const MyHomePage();
    }
  }
}
