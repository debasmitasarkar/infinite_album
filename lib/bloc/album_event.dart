import 'package:meta/meta.dart';

@immutable
abstract class AlbumsEvent {}

class LoadAlbumsEvent extends AlbumsEvent {}