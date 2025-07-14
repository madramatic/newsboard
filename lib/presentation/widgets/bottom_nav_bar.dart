import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = [
      CupertinoIcons.house_alt,
      CupertinoIcons.news,
      CupertinoIcons.search_circle,
      CupertinoIcons.heart,
      CupertinoIcons.person,
    ];
    final filledItems = [
      CupertinoIcons.house_alt_fill,
      CupertinoIcons.news_solid,
      CupertinoIcons.search_circle_fill,
      CupertinoIcons.heart_fill,
      CupertinoIcons.person_fill,
    ];
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor:
            theme.colorScheme.onSurface.withAlpha((255 * 0.6).round()),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: List.generate(
            5,
            (i) => BottomNavigationBarItem(
                  icon: Icon(
                    currentIndex == i ? filledItems[i] : items[i],
                    size: 28,
                  ),
                  label: '',
                )),
      ),
    );
  }
}
