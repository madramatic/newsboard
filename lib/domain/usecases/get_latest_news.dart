import '../entities/news.dart';
import '../repositories/news_repository.dart';

class GetLatestNews {
  final NewsRepository repository;

  GetLatestNews(this.repository);

  Future<List<News>> call() async {
    return await repository.getLatestNews();
  }
}
