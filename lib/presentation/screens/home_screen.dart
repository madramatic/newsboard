import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/category_tab_bar.dart';
import '../providers/news_provider.dart';
import 'package:go_router/go_router.dart';

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
    final newsAsync = ref.watch(newsListProvider);
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
                    return InkWell(
                      onTap: () {
                        context.push('/details', extra: news);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (news.imageUrl != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  news.imageUrl!,
                                  width: 100,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    news.title,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    news.sourceName,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    news.pubDate,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
