import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

@immutable
class Film {
  final String id;
  final String title;
  final String description;
  final bool isFavourite;

  const Film({
    required this.id,
    required this.title,
    required this.description,
    required this.isFavourite,
  });

  Film copy({required bool isFavourite}) {
    return Film(
        id: id,
        title: title,
        isFavourite: isFavourite,
        description: description);
  }

  @override
  String toString() =>
      'Film (id: $id, title: $title, description: $description, isFavourite: $isFavourite)';

  @override
  bool operator ==(covariant Film other) =>
      id == other.id && isFavourite == other.isFavourite;

  @override
  int get hashCode => Object.hashAll([id, isFavourite]);
}

const allFilms = [
  Film(
      id: '1',
      title: 'The shawshank redemption',
      description: 'Description for shawshank redemption',
      isFavourite: false),
  Film(
      id: '2',
      title: 'The Godfather',
      description: 'Description for The Godfather',
      isFavourite: false),
  Film(
      id: '3',
      title: 'The - Godfather part II',
      description: 'Description for The - Godfather part II',
      isFavourite: false),
  Film(
      id: '4',
      title: 'Rajesh Hamal',
      description: 'Description for Rajesh Hamal',
      isFavourite: false),
  Film(
      id: '5',
      title: 'Maple Erouse',
      description: 'Description for Maple Erouse',
      isFavourite: false),
];

enum FavouriteStatus {
  all,
  favourite,
  notFavourite,
}

class FilmsNotifier extends StateNotifier<List<Film>> {
  FilmsNotifier() : super(allFilms);

  void update(Film film, bool isFavourite) => state
      .map(
        (e) => e.id == film.id ? e.copy(isFavourite: isFavourite) : e,
      )
      .toList();
}

final favouriteStatusProvider = StateProvider<FavouriteStatus>(
  (ref) => FavouriteStatus.all,
);

final allFilmsProvider = StateNotifierProvider<FilmsNotifier, List<Film>>(
  (ref) => FilmsNotifier(),
);

final favoriteFilmProvider = Provider(
  (ref) => ref.watch(allFilmsProvider).where((element) => element.isFavourite),
);

final nonFavoriteFilmProvider = Provider(
  (ref) => ref.watch(allFilmsProvider).where((element) => !element.isFavourite),
);

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}
