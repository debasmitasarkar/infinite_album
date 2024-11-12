import 'package:album/bloc/album_bloc.dart';
import 'package:album/bloc/album_state.dart';
import 'package:album/ui/widgets/album_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlbumsScreen extends StatelessWidget {
  const AlbumsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Albums')),
      body: BlocBuilder<AlbumsBloc, AlbumsState>(
        builder: (context, state) {
          if (state is AlbumsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AlbumsLoaded) {
            return ListView.builder(
              itemCount: null, // Infinite scrolling
              itemBuilder: (context, index) {
                final albumWithPhotos =
                    state.albums[index % state.albums.length]; // Repeat albums
                return AlbumWidget(albumWithPhotos: albumWithPhotos);
              },
            );
          } else if (state is AlbumsError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Failed to load albums'));
          }
        },
      ),
    );
  }
}
