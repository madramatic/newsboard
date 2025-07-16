import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../data/datasources/news_api_datasource.dart';
import '../../data/repositories/news_repository_impl.dart';
import '../../domain/usecases/get_latest_news.dart';
import '../../domain/entities/news.dart';

const apiKey = 'pub_145a3186ca7c47639740b023e5ab7fe1';

final dioProvider = Provider<Dio>((ref) => Dio());

final newsApiDatasourceProvider = Provider<NewsApiDatasource>((ref) {
  final dio = ref.watch(dioProvider);
  return NewsApiDatasource(dio: dio, apiKey: apiKey);
});

final newsRepositoryProvider = Provider<NewsRepositoryImpl>((ref) {
  final datasource = ref.watch(newsApiDatasourceProvider);
  return NewsRepositoryImpl(datasource);
});

final getLatestNewsProvider = Provider<GetLatestNews>((ref) {
  final repository = ref.watch(newsRepositoryProvider);
  return GetLatestNews(repository);
});

final newsListProvider =
    FutureProvider.family<List<News>, String>((ref, category) async {
  final getLatestNews = ref.watch(getLatestNewsProvider);
  // If category is 'Latest', pass empty string to get all news
  final query = category == 'Latest' ? '' : category;
  return await getLatestNews.call(query: query);
});
