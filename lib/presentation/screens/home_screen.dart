import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/category_tab_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int _selectedCategory = 0;

  final List<String> _categories = [
    'Latest',
    'Health',
    'Sports',
    'Finance',
    'Technology',
    'World',
    'Politics',
    'Entertainment',
    'Science',
    'Travel',
    'Food',
    'Opinion',
    'Culture',
    'Business',
    'Education',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Image.asset(
          Theme.of(context).brightness == Brightness.dark
              ? 'assets/images/newsboard-logo-dark.png'
              : 'assets/images/newsboard-logo-light.png',
          height: 160,
          fit: BoxFit.contain,
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CategoryTabBar(
            categories: _categories,
            selectedIndex: _selectedCategory,
            onTap: (index) {
              setState(() {
                _selectedCategory = index;
              });
            },
          ),
          const Expanded(
            child: Center(
              child: Text('Welcome to newsboard!'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
