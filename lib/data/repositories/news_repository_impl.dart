import '../../domain/entities/news.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_api_datasource.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsApiDatasource datasource;

  NewsRepositoryImpl(this.datasource);

  @override
  Future<List<News>> getLatestNews({String? query}) async {
    return await datasource.fetchLatestNews(query: query);
  }
}
