import 'package:cineapp/config/constants/environment.dart';
import 'package:cineapp/domain/datasource/movies_datasource.dart';
import 'package:cineapp/domain/entities/movies.dart';
import 'package:cineapp/domain/entities/video.dart';
import 'package:cineapp/infrastructure/mappers/movie_mappers.dart';
import 'package:cineapp/infrastructure/mappers/video_mappers.dart';
import 'package:cineapp/infrastructure/models/moviedb/movie_details.dart';
import 'package:cineapp/infrastructure/models/moviedb/movie_video.dart';

import 'package:cineapp/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:dio/dio.dart';

class MoviedbDatasource extends MoviesDatasource {
  final dio = Dio(
      BaseOptions(baseUrl: 'https://api.themoviedb.org/3', queryParameters: {
    'api_key': Environment.apiKey,
    'language': 'es-MX',
  }));

  List<Movie> _jsonToMovie(Map<String, dynamic> json) {
    final moviesDBResponse = MoviedbResponse.fromJson(json);

    final List<Movie> movies = moviesDBResponse.results
        .where((movie) => movie.posterPath != 'no-poster')
        .map((movie) => MovieMapper.movieDBToEntity(movie))
        .toList();

    return movies;
  }

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    
    final response = await dio.get('/movie/now_playing', queryParameters: {
      'page': page,
    });

    return _jsonToMovie(response.data);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
   
    final response = await dio.get('/movie/top_rated', queryParameters: {
      'page': page,
    });
    return _jsonToMovie(response.data);
  }

  Future<List<Movie>> getTerror({int page = 1}) async {
    
    final response = await dio.get('/discover/movie',
        queryParameters: {'page': page, 'with_genres': 27});
    return _jsonToMovie(response.data);
  }
  Future<List<Movie>> getAnimation({int page = 1}) async {
    
    final response = await dio.get('/discover/movie',
        queryParameters: {'page': page, 'with_genres': 16});
    return _jsonToMovie(response.data);
  }
  Future<List<Movie>> getAction({int page = 1}) async {
    
    final response = await dio.get('/discover/movie',
        queryParameters: {'page': page, 'with_genres': 28});
    return _jsonToMovie(response.data);
  }
  Future<List<Movie>> getComedy({int page = 1}) async {
    
    final response = await dio.get('/discover/movie',
        queryParameters: {'page': page, 'with_genres': 35});
    return _jsonToMovie(response.data);
  }
  Future<List<Movie>> getWestern({int page = 1}) async {
    
    final response = await dio.get('/discover/movie',
        queryParameters: {'page': page, 'with_genres': 37});
    return _jsonToMovie(response.data);
  }

  Future<List<Movie>> getUpcoming({int page = 1}) async {
    
    final response = await dio.get('/movie/upcoming', queryParameters: {
      'page': page,
    });
    return _jsonToMovie(response.data);
  }

  @override
  Future<Movie> getMovieById(String id) async {
    final response = await dio.get('/movie/$id');

    if (response.statusCode != 200)
      throw Exception('Movie with id: $id not found');

    final movieDetails = MovieDetails.fromJson(response.data);

    final Movie movie = MovieMapper.MovieDetailsToEntity(movieDetails);

    return movie;
  }
  
  @override
  Future<List<Movie>> searchMovie(String query) async{

    if(query.isEmpty) return [];

    final response = await dio.get('/search/movie', 
    queryParameters: {
      'query': query,
    });
   return _jsonToMovie(response.data);
  }

  @override

  Future<List<Video>> getYoutubeVideosById( int movieId) async{
    final response = await dio.get('/movie/$movieId/videos');

    final movieResponse = MoviedbVideosResponse.fromJson(response.data);

    final videos = <Video>[];

    for (final moviedbVideo in movieResponse.results) {
      if ( moviedbVideo.site == 'YouTube') {
          final video = VideoMapper.moviedbVideoToEntity(moviedbVideo);

        videos.add(video);
      }
      
    } 
    return videos;
  }
}
