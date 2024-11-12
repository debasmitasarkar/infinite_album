import 'package:album/models/album_with_photos.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AlbumWidget extends StatelessWidget {
  final AlbumWithPhotos albumWithPhotos;

  const AlbumWidget({super.key, required this.albumWithPhotos});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            albumWithPhotos.album.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: null,
              itemBuilder: (context, index) {
               final photo = albumWithPhotos.photos[index % albumWithPhotos.photos.length];
                return Container(
                  width: 100,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: CachedNetworkImage(
                    imageUrl: photo.url,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                      child: Image.network(
                        photo.thumbnailUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    errorWidget: (context, url, error) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(child: Icon(Icons.error)),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
