import 'package:flutter/material.dart';

class MainNewsListItem extends StatelessWidget {
  final String imageUrl;
  final String headline;
  final String summary;
  final VoidCallback? onTap;
  final bool isSaved;
  final VoidCallback? onSave;
  final VoidCallback? onRemove;

  const MainNewsListItem({
    super.key,
    required this.imageUrl,
    required this.headline,
    required this.summary,
    this.onTap,
    this.isSaved = false,
    this.onSave,
    this.onRemove,
  });

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
  Widget build(BuildContext context) {
    final validImageUrl = getValidImageUrl(imageUrl);
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (validImageUrl != null)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                validImageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    headline,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontFamily: 'PlayfairDisplay',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                IconButton(
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
                  tooltip: isSaved ? 'Remove from Saved' : 'Save Article',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              summary,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
