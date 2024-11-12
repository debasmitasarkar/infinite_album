import 'package:album/bloc/album_event.dart';
import 'package:album/bloc/album_state.dart';
import 'package:album/models/album.dart';
import 'package:album/models/album_with_photos.dart';
import 'package:album/models/photo.dart';
import 'package:album/repositories/album_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';

class AlbumsBloc extends Bloc<AlbumsEvent, AlbumsState> {
  final AlbumRepository albumRepository;

  AlbumsBloc({required this.albumRepository}) : super(AlbumsInitial()) {
    on<LoadAlbumsEvent>(_onLoadAlbums);
  }

  Future<void> _onLoadAlbums(
    LoadAlbumsEvent event,
    Emitter<AlbumsState> emit,
  ) async {
    emit(AlbumsLoading());

    try {
      final Either<Exception, List<Album>> failureOrAlbums =
          await albumRepository.fetchAlbums(limit: 4);

      if (failureOrAlbums.isLeft()) {
        emit(AlbumsError("Failed to load albums."));
        return;
      }

      final albums = failureOrAlbums.getOrElse(() => []);
      final List<AlbumWithPhotos> albumsWithPhotos = [];

      for (var album in albums) {
        final Either<Exception, List<Photo>> failureOrPhotos =
            await albumRepository.fetchPhotos(album.id, limit: 4);

        if (failureOrPhotos.isRight()) {
          final photos = failureOrPhotos.getOrElse(() => []);
          albumsWithPhotos.add(AlbumWithPhotos(album: album, photos: photos));
        }
      }

      if (!emit.isDone) {
        emit(AlbumsLoaded(albums: albumsWithPhotos));
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(AlbumsError("An unexpected error occurred."));
      }
    }
  }
}
