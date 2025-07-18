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
  final String? errorMessage;
  final bool canRetry;

  NewsListState({
    required this.articles,
    this.nextPage,
    this.isLoadingMore = false,
    this.isAllLoaded = false,
    this.isLoadingInitial = true,
    this.errorMessage,
    this.canRetry = false,
  });

  NewsListState copyWith({
    List<News>? articles,
    String? nextPage,
    bool? isLoadingMore,
    bool? isAllLoaded,
    bool? isLoadingInitial,
    String? errorMessage,
    bool? canRetry,
  }) {
    return NewsListState(
      articles: articles ?? this.articles,
      nextPage: nextPage ?? this.nextPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isAllLoaded: isAllLoaded ?? this.isAllLoaded,
      isLoadingInitial: isLoadingInitial ?? this.isLoadingInitial,
      errorMessage: errorMessage,
      canRetry: canRetry ?? false,
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
    state = state.copyWith(
      isLoadingInitial: true,
      errorMessage: null,
      canRetry: false,
    );
    final query = category == 'Top' ? '' : category;
    const page = null;
    try {
      final result = await getLatestNews.call(query: query, page: page);
      state = state.copyWith(
        articles: result.articles,
        nextPage: result.nextPage,
        isAllLoaded: result.nextPage == null,
        isLoadingInitial: false,
        errorMessage: null,
        canRetry: false,
      );
    } catch (e) {
      String message = 'Failed to load news.';
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          message = 'Connection timed out. Please try again.';
        } else if (e.response?.statusCode == 429) {
          message = 'Too many requests. Please wait and try again.';
        } else if (e.type == DioExceptionType.connectionError) {
          message = 'No internet connection.';
        } else if (e.response != null) {
          message = 'Error: ${e.response?.statusCode}';
        }
      }
      state = state.copyWith(
        isLoadingInitial: false,
        errorMessage: message,
        canRetry: true,
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || state.isAllLoaded || state.nextPage == null) {
      return;
    }
    state = state.copyWith(isLoadingMore: true, errorMessage: null);
    final query = category == 'Top' ? '' : category;
    try {
      final result =
          await getLatestNews.call(query: query, page: state.nextPage);
      state = state.copyWith(
        articles: [...state.articles, ...result.articles],
        nextPage: result.nextPage,
        isLoadingMore: false,
        isAllLoaded: result.nextPage == null,
        errorMessage: null,
      );
    } catch (e) {
      String message = 'Failed to load more news.';
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          message = 'Connection timed out. Please try again.';
        } else if (e.response?.statusCode == 429) {
          message = 'Too many requests. Please wait and try again.';
        } else if (e.type == DioExceptionType.connectionError) {
          message = 'No internet connection.';
        } else if (e.response != null) {
          message = 'Error: ${e.response?.statusCode}';
        }
      }
      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: message,
        canRetry: true,
      );
    }
  }
}

final newsListProvider =
    StateNotifierProvider.family<NewsListNotifier, NewsListState, String>(
        (ref, category) {
  final getLatestNews = ref.watch(getLatestNewsProvider);
  return NewsListNotifier(getLatestNews, category);
});
