import 'package:flutter/material.dart';
import 'package:newsboard/presentation/constants/bottom_nav_icons.dart';

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
      kHomeIcon,
      kChatIcon,
      kSaveIcon,
      kUserIcon,
    ];
    final filledItems = [
      kHomeFillIcon,
      kChatFillIcon,
      kSaveFillIcon,
      kUserFillIcon,
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
            4,
            (i) => BottomNavigationBarItem(
                  icon: Image.asset(
                    currentIndex == i ? filledItems[i] : items[i],
                    width: 28,
                    height: 28,
                    color: currentIndex == i
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface
                            .withAlpha((255 * 0.6).round()),
                  ),
                  label: '',
                )),
      ),
    );
  }
}
