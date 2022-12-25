import 'package:flutter/material.dart';

class MyMessageScreen extends StatefulWidget {
  const MyMessageScreen({super.key});

  @override
  State<MyMessageScreen> createState() => _MyMessageScreenState();
}

class _MyMessageScreenState extends State<MyMessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Library",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
