import 'package:flutter/material.dart';
import '../../../domain/entities/news.dart';

class NewsDetailsScreen extends StatelessWidget {
  final News news;
  const NewsDetailsScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(news.sourceName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (news.imageUrl != null)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    news.imageUrl!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              news.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              news.pubDate,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            if (news.description != null)
              Text(
                news.description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            const SizedBox(height: 16),
            Text('Source: ${news.sourceName}'),
            Text('Language: ${news.language}'),
            Text('Country: ${news.country.join(", ")}'),
            Text('Category: ${news.category.join(", ")}'),
            const SizedBox(height: 16),
            if (news.link.isNotEmpty)
              TextButton(
                onPressed: () {
                  // TODO: Implement launch URL
                },
                child: const Text('Read full article'),
              ),
          ],
        ),
      ),
    );
  }
}
