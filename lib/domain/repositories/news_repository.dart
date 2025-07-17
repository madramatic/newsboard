import '../entities/news.dart';

class NewsPage {
  final List<News> articles;
  final String? nextPage;

  NewsPage({required this.articles, this.nextPage});
}

abstract class NewsRepository {
  Future<NewsPage> getLatestNews({String? query, String? page});
}
