import 'package:equatable/equatable.dart';

class Photo extends Equatable{
  final int albumId;
  final String url;
  final String thumbnailUrl;

  const Photo({required this.albumId, required this.url, required this.thumbnailUrl});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      albumId: json['albumId'],
      url: json['url'],
      thumbnailUrl: json['thumbnailUrl'],
    );
  }
  
  @override
  List<Object?> get props => [albumId, url, thumbnailUrl];
}