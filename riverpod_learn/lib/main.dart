import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(
    child: MainApp(),
  ));
}

final date = Provider<DateTime>((ref) => DateTime.now());

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDate = ref.watch(date);
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        body: Center(
          child: Text('Hello World!' + currentDate.toIso8601String()),
        ),
      ),
    );
  }
}
