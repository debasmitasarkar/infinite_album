import 'package:album/models/album.dart';
import 'package:flutter/material.dart';

class AlbumWidget extends StatelessWidget {
  final Album album;

  const AlbumWidget({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            album.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          // Add horizontal scrolling images here
        ],
      ),
    );
  }
}