class News {
  final String articleId;
  final String title;
  final String link;
  final List<String>? keywords;
  final List<String>? creator;
  final String? description;
  final String? content;
  final String pubDate;
  final String pubDateTZ;
  final String? imageUrl;
  final String? videoUrl;
  final String sourceId;
  final String sourceName;
  final int sourcePriority;
  final String sourceUrl;
  final String sourceIcon;
  final String language;
  final List<String> country;
  final List<String> category;
  final bool duplicate;

  News({
    required this.articleId,
    required this.title,
    required this.link,
    this.keywords,
    this.creator,
    this.description,
    this.content,
    required this.pubDate,
    required this.pubDateTZ,
    this.imageUrl,
    this.videoUrl,
    required this.sourceId,
    required this.sourceName,
    required this.sourcePriority,
    required this.sourceUrl,
    required this.sourceIcon,
    required this.language,
    required this.country,
    required this.category,
    required this.duplicate,
  });
}
