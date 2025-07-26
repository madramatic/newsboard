// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/category_tab_bar.dart';
import '../providers/news_provider.dart';
import 'package:go_router/go_router.dart';
import '../widgets/news_list_item.dart';
import '../widgets/main_news_list_item.dart';
import '../config/categories.dart';
import '../providers/user_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedCategory = 0;

  List<String> get _categories => kNewsCategories;

  @override
  Widget build(BuildContext context) {
    final newsState =
        ref.watch(newsListProvider(_categories[_selectedCategory]));
    final notifier =
        ref.read(newsListProvider(_categories[_selectedCategory]).notifier);
    final user = ref.watch(userStateProvider);
    final uid = user?.id;
    final savedArticlesAsync =
        uid != null ? ref.watch(savedArticlesListProvider(uid)) : null;
    final saveArticle = ref.read(saveArticleProvider);
    final removeSavedArticle = ref.read(removeSavedArticleProvider);

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
                    if (uid != null) {
                      await ref.refresh(savedArticlesListProvider(uid).future);
                    }
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
                    child: savedArticlesAsync == null
                        ? ListView.builder(
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
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  );
                                } else if (newsState.isAllLoaded) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child:
                                        Center(child: Text('All caught up.')),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              }
                            },
                          )
                        : savedArticlesAsync.when(
                            data: (savedArticles) {
                              return ListView.builder(
                                itemCount: newsState.articles.length + 1,
                                itemBuilder: (context, index) {
                                  if (index < newsState.articles.length) {
                                    final news = newsState.articles[index];
                                    final isSaved = savedArticles.any(
                                        (a) => a.articleId == news.articleId);
                                    if (index == 0) {
                                      return MainNewsListItem(
                                        imageUrl: news.imageUrl ?? '',
                                        headline: news.title,
                                        summary: news.description ?? '',
                                        isSaved: isSaved,
                                        onSave: uid == null
                                            ? null
                                            : () async {
                                                final loadingNotifier = ref.read(
                                                    articleSaveLoadingProvider
                                                        .notifier);
                                                loadingNotifier.state = {
                                                  ...loadingNotifier.state,
                                                  news.articleId: true,
                                                };
                                                await saveArticle.call(
                                                    uid: uid, article: news);
                                                await ref.refresh(
                                                    savedArticlesListProvider(
                                                            uid)
                                                        .future);
                                                loadingNotifier.state = {
                                                  ...loadingNotifier.state,
                                                  news.articleId: false,
                                                };
                                              },
                                        onRemove: uid == null
                                            ? null
                                            : () async {
                                                final loadingNotifier = ref.read(
                                                    articleSaveLoadingProvider
                                                        .notifier);
                                                loadingNotifier.state = {
                                                  ...loadingNotifier.state,
                                                  news.articleId: true,
                                                };
                                                await removeSavedArticle.call(
                                                    uid: uid,
                                                    articleId: news.articleId);
                                                await ref.refresh(
                                                    savedArticlesListProvider(
                                                            uid)
                                                        .future);
                                                loadingNotifier.state = {
                                                  ...loadingNotifier.state,
                                                  news.articleId: false,
                                                };
                                              },
                                        onTap: () {
                                          context.push('/details', extra: news);
                                        },
                                      );
                                    } else {
                                      return NewsListItem(
                                        news: news,
                                        isSaved: isSaved,
                                        onSave: uid == null
                                            ? null
                                            : () async {
                                                final loadingNotifier = ref.read(
                                                    articleSaveLoadingProvider
                                                        .notifier);
                                                loadingNotifier.state = {
                                                  ...loadingNotifier.state,
                                                  news.articleId: true,
                                                };
                                                await saveArticle.call(
                                                    uid: uid, article: news);
                                                await ref.refresh(
                                                    savedArticlesListProvider(
                                                            uid)
                                                        .future);
                                                loadingNotifier.state = {
                                                  ...loadingNotifier.state,
                                                  news.articleId: false,
                                                };
                                              },
                                        onRemove: uid == null
                                            ? null
                                            : () async {
                                                final loadingNotifier = ref.read(
                                                    articleSaveLoadingProvider
                                                        .notifier);
                                                loadingNotifier.state = {
                                                  ...loadingNotifier.state,
                                                  news.articleId: true,
                                                };
                                                await removeSavedArticle.call(
                                                    uid: uid,
                                                    articleId: news.articleId);
                                                await ref.refresh(
                                                    savedArticlesListProvider(
                                                            uid)
                                                        .future);
                                                loadingNotifier.state = {
                                                  ...loadingNotifier.state,
                                                  news.articleId: false,
                                                };
                                              },
                                        onTap: () {
                                          context.push('/details', extra: news);
                                        },
                                      );
                                    }
                                  } else {
                                    if (newsState.isLoadingMore) {
                                      return const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 16),
                                        child: Center(
                                            child: CircularProgressIndicator()),
                                      );
                                    } else if (newsState.isAllLoaded) {
                                      return const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 16),
                                        child: Center(
                                            child: Text('All caught up.')),
                                      );
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  }
                                },
                              );
                            },
                            loading: () => const Center(
                                child: CircularProgressIndicator()),
                            error: (e, st) => const Center(
                                child: Text('Error loading saved articles')),
                          ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
