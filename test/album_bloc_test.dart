import 'package:album/bloc/album_bloc.dart';
import 'package:album/bloc/album_event.dart';
import 'package:album/bloc/album_state.dart';
import 'package:album/models/album.dart';
import 'package:album/models/album_with_photos.dart';
import 'package:album/models/photo.dart';
import 'package:album/repositories/album_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAlbumRepository extends Mock implements AlbumRepository {}

void main() {
  late MockAlbumRepository mockAlbumRepository;
  late AlbumsBloc albumsBloc;

  setUp(() {
    mockAlbumRepository = MockAlbumRepository();
    albumsBloc = AlbumsBloc(albumRepository: mockAlbumRepository);
    registerFallbackValue(LoadAlbumsEvent());
  });

  tearDown(() {
    albumsBloc.close();
  });

  group('AlbumsBloc', () {
    const album = Album(id: 1, title: 'Test Album');
    const photo = Photo(albumId: 1, thumbnailUrl: '', url: 'test_url');

    blocTest<AlbumsBloc, AlbumsState>(
      'emits [AlbumsLoading, AlbumsLoaded] when LoadAlbumsEvent is added and succeeds',
      build: () {
        when(() => mockAlbumRepository.fetchAlbums(limit: any(named: 'limit')))
            .thenAnswer((_) async => const Right([album]));
        when(() => mockAlbumRepository.fetchPhotos(any(), limit: any(named: 'limit')))
            .thenAnswer((_) async => const Right([photo]));
        return albumsBloc;
      },
      act: (bloc) => bloc.add(LoadAlbumsEvent()),
      expect: () => [
        AlbumsLoading(),
        AlbumsLoaded(albums: const [AlbumWithPhotos(album: album, photos: [photo])]),
      ],
    );

    blocTest<AlbumsBloc, AlbumsState>(
      'emits [AlbumsLoading, AlbumsError] when LoadAlbumsEvent is added and fetchAlbums fails',
      build: () {
        when(() => mockAlbumRepository.fetchAlbums(limit: any(named: 'limit')))
            .thenAnswer((_) async => Left(Exception('Failed to load albums')));
        return albumsBloc;
      },
      act: (bloc) => bloc.add(LoadAlbumsEvent()),
      expect: () => [
        AlbumsLoading(),
        AlbumsError('Failed to load albums.'),
      ],
    );

    blocTest<AlbumsBloc, AlbumsState>(
      'emits [AlbumsLoading, AlbumsLoaded] with empty albums when no albums are returned',
      build: () {
        when(() => mockAlbumRepository.fetchAlbums(limit: any(named: 'limit')))
            .thenAnswer((_) async => const Right([]));
        return albumsBloc;
      },
      act: (bloc) => bloc.add(LoadAlbumsEvent()),
      expect: () => [
        AlbumsLoading(),
        AlbumsLoaded(albums: const []),
      ],
    );

    blocTest<AlbumsBloc, AlbumsState>(
      'emits [AlbumsLoading, AlbumsLoaded] when fetchPhotos fails for an album',
      build: () {
        when(() => mockAlbumRepository.fetchAlbums(limit: any(named: 'limit')))
            .thenAnswer((_) async => const Right([album]));
        when(() => mockAlbumRepository.fetchPhotos(any(), limit: any(named: 'limit')))
            .thenAnswer((_) async => Left(Exception('Failed to load photos')));
        return albumsBloc;
      },
      act: (bloc) => bloc.add(LoadAlbumsEvent()),
      expect: () => [
        AlbumsLoading(),
        AlbumsLoaded(albums: const [] ),
      ],
    );
  });
}
