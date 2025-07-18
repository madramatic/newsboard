import 'package:flutter/material.dart';

class MainNewsListItem extends StatelessWidget {
  final String imageUrl;
  final String headline;
  final String summary;
  final VoidCallback? onTap;

  const MainNewsListItem({
    super.key,
    required this.imageUrl,
    required this.headline,
    required this.summary,
    this.onTap,
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
            child: Text(
              headline,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontFamily: 'PlayfairDisplay',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              summary,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
