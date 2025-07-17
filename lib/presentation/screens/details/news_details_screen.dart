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
            Text(
              news.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontFamily: 'PlayfairDisplay',
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              news.pubDate,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            if (news.imageUrl != null)
              Center(
                child: Image.network(
                  news.imageUrl!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: double.infinity,
                    height: 200,
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: Icon(Icons.broken_image,
                        size: 48,
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            if (news.description != null)
              Text(
                news.description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            const SizedBox(height: 16),
            RichText(
              text: TextSpan(
                text: 'Source: ',
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: news.sourceName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'Country: ',
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: news.country.join(", "),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
