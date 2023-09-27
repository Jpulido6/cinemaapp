import 'package:cineapp/config/constants/environment.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {

  static const name = 'HomeScreen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cine App'),
      ),
      body: Center(
        child: Text(Environment.apiKey),
      )
    );
  }
}