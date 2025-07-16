import 'package:flutter/material.dart';

class NewsboardHeader extends StatelessWidget {
  const NewsboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Image.asset(
        'assets/images/newsboard-logo.png',
        height: 48,
        fit: BoxFit.contain,
      ),
    );
  }
}
