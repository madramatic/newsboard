import 'package:dio/dio.dart';
import '../models/news_model.dart';

class NewsApiDatasource {
  final Dio dio;
  final String apiKey;

  NewsApiDatasource({required this.dio, required this.apiKey});

  Future<List<NewsModel>> fetchLatestNews() async {
    final response = await dio.get(
      'https://newsdata.io/api/1/latest',
      queryParameters: {'apikey': apiKey, 'language': 'en'},
    );
    final data = response.data;
    if (data['status'] == 'success' && data['results'] is List) {
      return (data['results'] as List)
          .map((e) => NewsModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
