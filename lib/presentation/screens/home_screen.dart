import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/category_tab_bar.dart';
import '../providers/news_provider.dart';
import 'package:go_router/go_router.dart';
import '../widgets/news_list_item.dart';
import '../widgets/main_news_list_item.dart';
import '../config/categories.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;
  int _selectedCategory = 0;

  // Use categories from config
  List<String> get _categories => kNewsCategories;

  @override
  Widget build(BuildContext context) {
    final newsState =
        ref.watch(newsListProvider(_categories[_selectedCategory]));
    final notifier =
        ref.read(newsListProvider(_categories[_selectedCategory]).notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'newsboard',
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 28,
          ),
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
            child: Builder(
              builder: (context) {
                if (newsState.isLoadingInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (newsState.articles.isEmpty && !newsState.isLoadingInitial) {
                  return const Center(child: Text('No news available.'));
                }
                return RefreshIndicator(
                  color: Theme.of(context).colorScheme.primary,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  onRefresh: () async {
                    await notifier.loadInitial();
                  },
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (scrollInfo) {
                      if (scrollInfo.metrics.pixels >=
                              scrollInfo.metrics.maxScrollExtent - 200 &&
                          !newsState.isLoadingMore &&
                          !newsState.isAllLoaded) {
                        notifier.loadMore();
                      }
                      return false;
                    },
                    child: ListView.builder(
                      itemCount: newsState.articles.length + 1,
                      itemBuilder: (context, index) {
                        if (index < newsState.articles.length) {
                          final news = newsState.articles[index];
                          if (index == 0) {
                            return MainNewsListItem(
                              imageUrl: news.imageUrl ?? '',
                              headline: news.title,
                              summary: news.description ?? '',
                              onTap: () {
                                context.push('/details', extra: news);
                              },
                            );
                          } else {
                            return NewsListItem(
                              news: news,
                              onTap: () {
                                context.push('/details', extra: news);
                              },
                            );
                          }
                        } else {
                          if (newsState.isLoadingMore) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          } else if (newsState.isAllLoaded) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: Text('All caught up.')),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        }
                      },
                    ),
                  ),
                );
              },
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
