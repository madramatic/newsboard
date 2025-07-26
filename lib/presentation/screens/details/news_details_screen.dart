import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../domain/entities/news.dart';
import '../../providers/user_provider.dart';

class NewsDetailsScreen extends ConsumerWidget {
  final News news;
  const NewsDetailsScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(userStateProvider);
    final uid = user?.id;
    final savedArticlesAsync =
        uid != null ? ref.watch(savedArticlesListProvider(uid)) : null;
    final saveArticle = ref.read(saveArticleProvider);
    final removeSavedArticle = ref.read(removeSavedArticleProvider);
    final loadingMap = ref.watch(articleSaveLoadingProvider);
    final isLoading = loadingMap[news.articleId] == true;

    DateTime? publishedAt;
    try {
      publishedAt = DateTime.parse(news.pubDate);
    } catch (_) {
      publishedAt = null;
    }
    final timeAgo = publishedAt != null ? timeago.format(publishedAt) : '';

    bool isSaved = false;
    if (savedArticlesAsync != null && savedArticlesAsync is AsyncData) {
      isSaved =
          savedArticlesAsync.value!.any((a) => a.articleId == news.articleId);
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: 340,
            child: news.imageUrl != null
                ? ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                    child: Image.network(
                      news.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: Icon(Icons.broken_image,
                            size: 48,
                            color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                  ),
          ),
          Column(
            children: [
              const SizedBox(height: 260),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.shadow
                            .withAlpha((0.08 * 255).toInt()),
                        blurRadius: 12,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                backgroundColor: theme.colorScheme.surface
                                    .withAlpha((0.85 * 255).toInt()),
                                child: IconButton(
                                  icon: Icon(Icons.arrow_back,
                                      color: theme.colorScheme.onSurface),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ),
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: theme.colorScheme.surface
                                        .withAlpha((0.85 * 255).toInt()),
                                    child: isLoading
                                        ? SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                theme.colorScheme.primary,
                                              ),
                                            ),
                                          )
                                        : IconButton(
                                            icon: isSaved
                                                ? Image.asset(
                                                    'assets/icons/save-fill.png',
                                                    color: theme
                                                        .colorScheme.primary,
                                                    width: 24,
                                                    height: 24,
                                                  )
                                                : Image.asset(
                                                    'assets/icons/save.png',
                                                    color:
                                                        theme.iconTheme.color,
                                                    width: 24,
                                                    height: 24,
                                                  ),
                                            tooltip: isSaved
                                                ? 'Remove from Saved'
                                                : 'Save Article',
                                            onPressed: uid == null
                                                ? null
                                                : () async {
                                                    final loadingNotifier =
                                                        ref.read(
                                                            articleSaveLoadingProvider
                                                                .notifier);
                                                    loadingNotifier.state = {
                                                      ...loadingNotifier.state,
                                                      news.articleId: true,
                                                    };
                                                    if (isSaved) {
                                                      await removeSavedArticle
                                                          .call(
                                                              uid: uid,
                                                              articleId: news
                                                                  .articleId);
                                                    } else {
                                                      await saveArticle.call(
                                                          uid: uid,
                                                          article: news);
                                                    }
                                                    await ref.refresh(
                                                        savedArticlesListProvider(
                                                                uid)
                                                            .future);
                                                    loadingNotifier.state = {
                                                      ...loadingNotifier.state,
                                                      news.articleId: false,
                                                    };
                                                  },
                                          ),
                                  ),
                                  const SizedBox(width: 12),
                                  CircleAvatar(
                                    backgroundColor: theme.colorScheme.surface
                                        .withAlpha((0.85 * 255).toInt()),
                                    child: Icon(Icons.share,
                                        color: theme.colorScheme.onSurface),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (news.category.isNotEmpty)
                            Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary
                                    .withAlpha((0.85 * 255).toInt()),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                news.category.first,
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: theme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          Text(
                            news.title,
                            style: theme.textTheme.headlineLarge?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'PlayfairDisplay',
                              fontSize: 28,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                'Trending',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                timeAgo,
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.transparent,
                                backgroundImage: NetworkImage(news.sourceIcon),
                                radius: 18,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                news.sourceName,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(Icons.verified,
                                  color: theme.colorScheme.primary, size: 20),
                            ],
                          ),
                          const SizedBox(height: 18),
                          if ((news.description?.trim().isNotEmpty ?? false))
                            Text(
                              news.description ?? '',
                              style: theme.textTheme.bodyMedium,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
