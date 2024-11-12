import 'package:album/models/album_with_photos.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';


@immutable
abstract class AlbumsState extends Equatable{}

class AlbumsInitial extends AlbumsState {
  @override
  List<Object?> get props => [];
}

class AlbumsLoading extends AlbumsState {
  @override
  List<Object?> get props => [];
}

class AlbumsLoaded extends AlbumsState {
  final List<AlbumWithPhotos> albums;

  AlbumsLoaded({required this.albums});

  @override
  List<Object?> get props => [albums];
}

class AlbumsError extends AlbumsState {
  final String message;

  AlbumsError(this.message);

  @override
  List<Object?> get props => [message];
}