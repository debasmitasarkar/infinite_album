import 'package:album/bloc/album_bloc.dart';
import 'package:album/bloc/album_event.dart';
import 'package:album/ui/album_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'repositories/album_repository.dart';
import 'services/local_db.dart';
import 'package:http/http.dart' as http;

final GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<LocalDb>(() => LocalDb());
  getIt.registerLazySingleton<AlbumRepository>(() =>
      AlbumRepository(localDb: getIt<LocalDb>(), httpClient: http.Client()));
  getIt.registerFactory<AlbumsBloc>(
      () => AlbumsBloc(albumRepository: getIt<AlbumRepository>()));
}

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AlbumsBloc>()..add(LoadAlbumsEvent()),
      child: const MaterialApp(
        title: 'Albums App',
        home: AlbumsScreen(),
      ),
    );
  }
}
