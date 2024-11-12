import 'package:album/models/album.dart';
import 'package:album/models/photo.dart';
import 'package:album/repositories/album_repository.dart';
import 'package:album/services/local_db.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MockLocalDb extends Mock implements LocalDb {}
class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockLocalDb mockLocalDb;
  late MockHttpClient mockHttpClient;
  late AlbumRepository repository;

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  setUp(() {
    mockLocalDb = MockLocalDb();
    mockHttpClient = MockHttpClient();
    repository = AlbumRepository(localDb: mockLocalDb, httpClient: mockHttpClient);
  });

  group('AlbumRepository', () {
    const album = Album(id: 1, title: 'Test Album');
    const photo = Photo(albumId: 1,thumbnailUrl: '', url: 'test_url');
    const baseUrl = 'https://jsonplaceholder.typicode.com';

    test('fetchAlbums returns a list of albums when successful', () async {
      when(() => mockLocalDb.getAlbums()).thenAnswer((_) async => []);
      when(() => mockLocalDb.saveAlbums(any())).thenAnswer((_) async {});
      when(() => mockHttpClient.get(Uri.parse('$baseUrl/albums?_limit=4'))).thenAnswer(
        (_) async => http.Response(jsonEncode([{'id': 1, 'title': 'Test Album'}]), 200),
      );

      final result = await repository.fetchAlbums(limit: 4);
      expect(result.isRight(), isTrue);
      expect(result.getOrElse(() => []), [album]);
    });

    test('fetchAlbums returns cached albums when available', () async {
      when(() => mockLocalDb.getAlbums()).thenAnswer((_) async => [album]);

      final result = await repository.fetchAlbums(limit: 4);
      expect(result.isRight(), isTrue);
      expect(result.getOrElse(() => []), [album]);
      verifyNever(() => mockHttpClient.get(any()));
    });

    test('fetchAlbums returns an error when the API call fails', () async {
      when(() => mockLocalDb.getAlbums()).thenAnswer((_) async => []);
      when(() => mockHttpClient.get(Uri.parse('$baseUrl/albums?_limit=4'))).thenAnswer(
        (_) async => http.Response('Failed to load albums', 404),
      );

      final result = await repository.fetchAlbums(limit: 4);
      expect(result.isLeft(), isTrue);
    });

    test('fetchPhotos returns a list of photos when successful', () async {
      when(() => mockHttpClient.get(any())).thenAnswer(
        (_) async => http.Response(jsonEncode([{ 'albumId': 1, 'url': 'test_url', 'thumbnailUrl': ''}]), 200),
      );

      final result = await repository.fetchPhotos(1, limit: 4);
      expect(result.isRight(), isTrue);
      expect(result.getOrElse(() => []), [photo]);
    });

    test('fetchPhotos returns an error when the API call fails', () async {
      when(() => mockHttpClient.get(Uri.parse('$baseUrl/photos?albumId=1&_limit=4'))).thenAnswer(
        (_) async => http.Response('Failed to load photos', 404),
      );

      final result = await repository.fetchPhotos(1, limit: 4);
      expect(result.isLeft(), isTrue);
    });
  });
}
