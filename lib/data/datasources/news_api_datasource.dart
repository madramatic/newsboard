import 'package:dio/dio.dart';
import '../models/news_model.dart';

class NewsApiResponse {
  final List<NewsModel> articles;
  final String? nextPage;

  NewsApiResponse({required this.articles, this.nextPage});
}

class NewsApiDatasource {
  final Dio dio;
  final String apiKey;

  NewsApiDatasource({required this.dio, required this.apiKey});

  Future<NewsApiResponse> fetchLatestNews({String? query, String? page}) async {
    final response = await dio.get(
      'https://newsdata.io/api/1/latest',
      queryParameters: {
        'apikey': apiKey,
        'language': 'en',
        if (query != null && query.isNotEmpty) 'q': query,
        if (page != null && page.isNotEmpty) 'page': page,
      },
    );
    final data = response.data;
    if (data['status'] == 'success' && data['results'] is List) {
      final articles = (data['results'] as List)
          .map((e) => NewsModel.fromJson(e as Map<String, dynamic>))
          .toList();
      final nextPage = data['nextPage'] as String?;
      return NewsApiResponse(articles: articles, nextPage: nextPage);
    }
    return NewsApiResponse(articles: [], nextPage: null);
  }
}
