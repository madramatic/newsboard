import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/news.dart';
import 'package:intl/intl.dart';
import '../providers/user_provider.dart';

class NewsListItem extends ConsumerWidget {
  final News news;
  final VoidCallback? onTap;
  final bool isSaved;
  final VoidCallback? onSave;
  final VoidCallback? onRemove;
  const NewsListItem({
    super.key,
    required this.news,
    this.onTap,
    this.isSaved = false,
    this.onSave,
    this.onRemove,
  });

  String _getTimeAgo(String pubDate) {
    // Parse pubDate and return time ago string
    try {
      final date = DateTime.parse(pubDate);
      final now = DateTime.now();
      final diff = now.difference(date);
      if (diff.inMinutes < 60) {
        return '${diff.inMinutes} mins ago';
      } else if (diff.inHours < 24) {
        return '${diff.inHours} hrs ago';
      } else {
        return DateFormat.yMMMd().format(date);
      }
    } catch (_) {
      return pubDate;
    }
  }

  String? getValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    final uri = Uri.tryParse(url);
    if (uri == null || !(uri.isScheme('http') || uri.isScheme('https'))) {
      return null;
    }
    if (url.contains('thumbor') && url.contains('https%3A')) return null;
    return url;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final loadingMap = ref.watch(articleSaveLoadingProvider);
    final isLoading = loadingMap[news.articleId] == true;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Divider(height: .2, thickness: .2, color: theme.dividerColor),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (news.imageUrl != null)
                    Row(
                      children: [
                        Image.network(
                          getValidImageUrl(news.imageUrl!)!,
                          width: 120,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            width: 120,
                            height: 80,
                            color: theme.colorScheme.surfaceContainerHighest,
                            child: Icon(Icons.broken_image,
                                color: theme.colorScheme.onSurfaceVariant),
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                news.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontFamily: 'PlayfairDisplay',
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            isLoading
                                ? IconButton(
                                    icon: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation(
                                          theme.colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                    onPressed: null,
                                  )
                                : IconButton(
                                    icon: isSaved
                                        ? Image.asset(
                                            'assets/icons/save-fill.png',
                                            color: theme.colorScheme.primary,
                                            width: 20,
                                            height: 20,
                                          )
                                        : Image.asset(
                                            'assets/icons/save.png',
                                            color: theme.iconTheme.color,
                                            width: 20,
                                            height: 20,
                                          ),
                                    onPressed: isSaved ? onRemove : onSave,
                                    tooltip: isSaved
                                        ? 'Remove from Saved'
                                        : 'Save Article',
                                  ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              _getTimeAgo(news.pubDate),
                              style: const TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('|'),
                            const SizedBox(width: 8),
                            Text(
                              news.category.isNotEmpty
                                  ? news.country.first
                                  : '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: .2, thickness: .2, color: theme.dividerColor),
          ],
        ),
      ),
    );
  }
}
