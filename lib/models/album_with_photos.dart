import 'package:album/models/album.dart';
import 'package:album/models/photo.dart';
import 'package:equatable/equatable.dart';

class AlbumWithPhotos extends Equatable {
  final Album album;
  final List<Photo> photos;

  const AlbumWithPhotos({required this.album, required this.photos});
  
  @override
  List<Object?> get props => [album, photos];
}