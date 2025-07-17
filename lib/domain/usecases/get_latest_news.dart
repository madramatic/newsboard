import '../repositories/news_repository.dart';

class GetLatestNews {
  final NewsRepository repository;

  GetLatestNews(this.repository);

  Future<NewsPage> call({String? query, String? page}) async {
    return await repository.getLatestNews(query: query, page: page);
  }
}
