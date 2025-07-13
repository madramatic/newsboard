import 'package:flutter/material.dart';
import '../widgets/newsboard_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NewsboardHeader(),
          Expanded(
            child: Center(
              child: Text('Welcome to newsboard!'),
            ),
          ),
        ],
      ),
    );
  }
}
