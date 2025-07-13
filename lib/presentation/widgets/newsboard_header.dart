import 'package:flutter/material.dart';

class NewsboardHeader extends StatelessWidget {
  const NewsboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Center(
        child: Image.asset(
          'assets/images/newsboard-logo.png',
          height: 160,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
