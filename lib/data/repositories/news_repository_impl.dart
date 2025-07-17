import '../../domain/repositories/news_repository.dart';
import '../datasources/news_api_datasource.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsApiDatasource datasource;

  NewsRepositoryImpl(this.datasource);

  @override
  Future<NewsPage> getLatestNews({String? query, String? page}) async {
    final response = await datasource.fetchLatestNews(query: query, page: page);
    return NewsPage(articles: response.articles, nextPage: response.nextPage);
  }
}
