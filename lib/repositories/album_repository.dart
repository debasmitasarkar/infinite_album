import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../models/album.dart';
import '../models/photo.dart';
import '../services/local_db.dart';

class AlbumRepository {
  final String baseUrl = 'https://jsonplaceholder.typicode.com';
  final LocalDb localDb;

   final http.Client httpClient;
  AlbumRepository({required this.httpClient, required this.localDb});

  Future<Either<Exception, List<Album>>> fetchAlbums({int limit = 4}) async {
    try {
      // Check local cache first
      List<Album> cachedAlbums = await localDb.getAlbums();
      if (cachedAlbums.isNotEmpty) {
        return Right(cachedAlbums.take(limit).toList());
      }

      // Fetch from API if not cached
      final response =
          await httpClient.get(Uri.parse('$baseUrl/albums?_limit=$limit'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        List<Album> albums =
            jsonList.map((json) => Album.fromJson(json)).toList();
        await localDb.saveAlbums(albums); // Cache the albums
        return Right(albums);
      } else {
        return Left(Exception('Failed to load albums'));
      }
    } catch (e) {
      return Left(Exception('Failed to load albums'));
    }
  }

  Future<Either<Exception, List<Photo>>> fetchPhotos(int albumId,
      {int limit = 4}) async {
    try {
      final response = await httpClient
          .get(Uri.parse('$baseUrl/photos?albumId=$albumId&_limit=$limit'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        List<Photo> photos =
            jsonList.map((json) => Photo.fromJson(json)).toList();
        return Right(photos);
      } else {
        return Left(Exception('Failed to load photos'));
      }
    } catch (e) {
      return Left(Exception('Failed to load photos'));
    }
  }
}
