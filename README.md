# album

Here's an overview of the files that will be included:

1. **lib/main.dart** - Entry point for the app.
2. **lib/models/album.dart** - Model class for Album.
3. **lib/models/photo.dart** - Model class for Photo.
4. **lib/bloc/albums_bloc.dart** - BLoC implementation for fetching and managing albums.
5. **lib/bloc/albums_event.dart** - Event class for AlbumsBloc.
6. **lib/bloc/albums_state.dart** - State class for AlbumsBloc.
7. **lib/repositories/album_repository.dart** - Repository pattern for Albums and Photos API.
8. **lib/services/local_db.dart** - Local Database class to cache albums and photos using `sqflite`.
9. **lib/ui/screens/albums_screen.dart** - Main UI Screen showing albums and their photos.
10. **lib/ui/widgets/album_widget.dart** - UI Widget for Album with horizontally scrolling photos.
11. **test/bloc/albums_bloc_test.dart** - Test cases for the AlbumsBloc.
12. **test/repositories/album_repository_test.dart** - Test cases for the AlbumRepository.

