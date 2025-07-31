import 'package:flutter/material.dart';

class NewsboardIconsRow extends StatelessWidget {
  const NewsboardIconsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/icons/home-fill.png',
          width: 28,
          height: 28,
          color: isDark ? Colors.white : null,
        ),
        const SizedBox(width: 60),
        Image.asset(
          'assets/icons/chat-fill.png',
          width: 28,
          height: 28,
          color: isDark ? Colors.white : null,
        ),
        const SizedBox(width: 60),
        Image.asset(
          'assets/icons/save-fill.png',
          width: 28,
          height: 28,
          color: isDark ? Colors.white : null,
        ),
        const SizedBox(width: 60),
        Image.asset(
          'assets/icons/user-fill.png',
          width: 28,
          height: 28,
          color: isDark ? Colors.white : null,
        ),
      ],
    );
  }
}
