import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/category_tab_bar.dart';
import '../providers/news_provider.dart';
import 'package:go_router/go_router.dart';
import '../widgets/news_list_item.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
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
    final newsAsync =
        ref.watch(newsListProvider(_categories[_selectedCategory]));
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
          Expanded(
            child: newsAsync.when(
              data: (newsList) {
                if (newsList.isEmpty) {
                  return const Center(child: Text('No news available.'));
                }
                return ListView.builder(
                  itemCount: newsList.length,
                  itemBuilder: (context, index) {
                    final news = newsList[index];
                    return NewsListItem(
                      news: news,
                      onTap: () {
                        context.push('/details', extra: news);
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
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
