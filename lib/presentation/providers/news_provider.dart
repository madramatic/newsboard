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

class NewsListState {
  final List<News> articles;
  final String? nextPage;
  final bool isLoadingMore;
  final bool isAllLoaded;
  final bool isLoadingInitial;

  NewsListState({
    required this.articles,
    this.nextPage,
    this.isLoadingMore = false,
    this.isAllLoaded = false,
    this.isLoadingInitial = true,
  });

  NewsListState copyWith({
    List<News>? articles,
    String? nextPage,
    bool? isLoadingMore,
    bool? isAllLoaded,
    bool? isLoadingInitial,
  }) {
    return NewsListState(
      articles: articles ?? this.articles,
      nextPage: nextPage ?? this.nextPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isAllLoaded: isAllLoaded ?? this.isAllLoaded,
      isLoadingInitial: isLoadingInitial ?? this.isLoadingInitial,
    );
  }
}

class NewsListNotifier extends StateNotifier<NewsListState> {
  final GetLatestNews getLatestNews;
  final String category;

  NewsListNotifier(this.getLatestNews, this.category)
      : super(NewsListState(articles: [])) {
    loadInitial();
  }

  Future<void> loadInitial() async {
    state = state.copyWith(isLoadingInitial: true);
    final query = category == 'Top' ? '' : category;
    const page = null;
    final result = await getLatestNews.call(query: query, page: page);
    state = state.copyWith(
      articles: result.articles,
      nextPage: result.nextPage,
      isAllLoaded: result.nextPage == null,
      isLoadingInitial: false,
    );
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || state.isAllLoaded || state.nextPage == null) {
      return;
    }
    state = state.copyWith(isLoadingMore: true);
    final query = category == 'Top' ? '' : category;
    final result = await getLatestNews.call(query: query, page: state.nextPage);
    state = state.copyWith(
      articles: [...state.articles, ...result.articles],
      nextPage: result.nextPage,
      isLoadingMore: false,
      isAllLoaded: result.nextPage == null,
    );
  }
}

final newsListProvider =
    StateNotifierProvider.family<NewsListNotifier, NewsListState, String>(
        (ref, category) {
  final getLatestNews = ref.watch(getLatestNewsProvider);
  return NewsListNotifier(getLatestNews, category);
});
