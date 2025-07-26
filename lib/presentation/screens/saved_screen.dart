import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsboard/presentation/screens/details/news_details_screen.dart';

import '../providers/user_provider.dart';
import '../widgets/news_list_item.dart';

class SavedScreen extends ConsumerWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStateProvider);
    final uid = user?.id;
    if (uid == null) {
      return const Scaffold(
        body: Center(child: Text('Sign in to view saved articles.')),
      );
    }
    final savedArticlesAsync = ref.watch(savedArticlesListProvider(uid));
    final removeSavedArticle = ref.read(removeSavedArticleProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Saved',
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 28,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: savedArticlesAsync.when(
        data: (articles) {
          if (articles.isEmpty) {
            return const Center(child: Text('No saved articles.'));
          }
          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final news = articles[index];
              return NewsListItem(
                news: news,
                isSaved: true,
                onRemove: () async {
                  final loadingNotifier =
                      ref.read(articleSaveLoadingProvider.notifier);
                  loadingNotifier.state = {
                    ...loadingNotifier.state,
                    news.articleId: true,
                  };
                  await removeSavedArticle.call(
                      uid: uid, articleId: news.articleId);
                  await ref.refresh(savedArticlesListProvider(uid).future);
                  loadingNotifier.state = {
                    ...loadingNotifier.state,
                    news.articleId: false,
                  };
                },
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NewsDetailsScreen(news: news),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) =>
            const Center(child: Text('Error loading saved articles')),
      ),
    );
  }
}
