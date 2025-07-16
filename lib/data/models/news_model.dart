import '../../domain/entities/news.dart';

class NewsModel extends News {
  NewsModel({
    required super.articleId,
    required super.title,
    required super.link,
    super.keywords,
    super.creator,
    super.description,
    super.content,
    required super.pubDate,
    required super.pubDateTZ,
    super.imageUrl,
    super.videoUrl,
    required super.sourceId,
    required super.sourceName,
    required super.sourcePriority,
    required super.sourceUrl,
    required super.sourceIcon,
    required super.language,
    required super.country,
    required super.category,
    required super.duplicate,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      articleId: json['article_id'] ?? '',
      title: json['title'] ?? '',
      link: json['link'] ?? '',
      keywords: (json['keywords'] as List?)?.map((e) => e.toString()).toList(),
      creator: (json['creator'] as List?)?.map((e) => e.toString()).toList(),
      description: json['description'],
      content: json['content'],
      pubDate: json['pubDate'] ?? '',
      pubDateTZ: json['pubDateTZ'] ?? '',
      imageUrl: json['image_url'],
      videoUrl: json['video_url'],
      sourceId: json['source_id'] ?? '',
      sourceName: json['source_name'] ?? '',
      sourcePriority: json['source_priority'] ?? 0,
      sourceUrl: json['source_url'] ?? '',
      sourceIcon: json['source_icon'] ?? '',
      language: json['language'] ?? '',
      country:
          (json['country'] as List?)?.map((e) => e.toString()).toList() ?? [],
      category:
          (json['category'] as List?)?.map((e) => e.toString()).toList() ?? [],
      duplicate: json['duplicate'] ?? false,
    );
  }
}
