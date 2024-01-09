import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
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

const names = [
  'albert',
  'alfred',
  'bhuwan',
  'binay',
  'ciya',
  'cena',
  'derma',
  'susmita',
  'nishant',
  'nikunja',
  'cincinnati',
  'blabla'
];

final tickerProvider = StreamProvider(
  (ref) => Stream.periodic(
      const Duration(
        seconds: 1,
      ),
      (i) => i + 1),
);

final namesProvider = StreamProvider((ref) =>
    ref.watch(tickerProvider.stream).map((event) => names.getRange(0, event)));

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final names = ref.watch(namesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Streams with riverpod'),
      ),
      body: names.when(
          data: (names) => ListView.builder(
              itemCount: names.length,
              itemBuilder: (ctx, index) {
                return ListTile(
                  title: Text(
                    names.elementAt(index),
                  ),
                );
              }),
          error: (error, stackTrace) => Text("some $error"),
          loading: () => const CircularProgressIndicator()),
    );
  }
}
