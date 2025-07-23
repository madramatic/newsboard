import 'package:flutter/material.dart';
import 'package:newsboard/presentation/screens/home_screen.dart';
import 'package:newsboard/presentation/screens/chat_screen.dart';
import 'package:newsboard/presentation/screens/saved_screen.dart';
import 'package:newsboard/presentation/screens/profile_screen.dart';
import '../widgets/bottom_nav_bar.dart';

class MainNavScaffold extends StatefulWidget {
  const MainNavScaffold({super.key, this.initialIndex = 0});
  final int initialIndex;

  @override
  State<MainNavScaffold> createState() => _MainNavScaffoldState();
}

class _MainNavScaffoldState extends State<MainNavScaffold> {
  late int _selectedIndex;

  final List<Widget> _screens = const [
    HomeScreen(),
    ChatScreen(),
    SavedScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onTabTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
