import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: const MyHomePage(),
    );
  }
}

enum City {
  paris,
  stockholm,
  tokyo,
}

typedef WeatherEmoji = String;

Future<WeatherEmoji> getWeather(City city) {
  return Future.delayed(
      const Duration(seconds: 1),
      () =>
          {City.paris: '🌦️', City.stockholm: '☃️', City.tokyo: '🌞'}[city] ??
          "🙈");
}

// UI Writes to this and reads from this
final currentCityProvider = StateProvider<City?>(
  (ref) => null,
);

// UI Listens from this
final weatherProvider = FutureProvider<WeatherEmoji>((ref) {
  final city = ref.watch(currentCityProvider);
  return getWeather(city!);
});

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(weatherProvider);
    return Scaffold(
      body: Column(
        children: [
          currentWeather.when(
            data: (data) => Text(data),
            error: (error, stack)=>const Text('Some error occured'),
            loading: CircularProgressIndicator.adaptive
          ),
          Expanded(
            child: ListView.builder(
              itemCount: City.values.length,
              itemBuilder: (ctx, index) {
                final city = City.values[index];
                final isSelected = city == ref.watch(currentCityProvider);
                return ListTile(
                  title: Text(city.toString()),
                  trailing: isSelected ? const Icon(Icons.check) : null,
                  onTap: () =>
                      ref.read(currentCityProvider.notifier).state = city,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
