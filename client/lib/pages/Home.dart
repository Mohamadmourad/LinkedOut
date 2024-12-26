import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final userId;
  final role;
  const Home({super.key, required this.userId, required this.role});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body:  Center(
        child: Text(widget.userId.toString()),
      ),
    );
  }
}