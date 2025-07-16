import '../../domain/entities/news.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_api_datasource.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsApiDatasource datasource;

  NewsRepositoryImpl(this.datasource);

  @override
  Future<List<News>> getLatestNews() async {
    return await datasource.fetchLatestNews();
  }
}
