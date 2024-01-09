import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

extension OperatorInfix<T extends num> on T? {
  T? operator +(T? secOperand) {
    final firstOperand = this;

    if (firstOperand != null) {
      return firstOperand + (secOperand ?? 0) as T;
    }
    return null;
  }
}

class Counter extends StateNotifier<int?> {
  Counter() : super(null);

  increment() => state = state == null ? 1 : state + 1;
}

final counterProvider =
    StateNotifierProvider<Counter, int?>((ref) => Counter());

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        body: Center(
          child: Consumer(
            builder: (context, ref, child) {
              final count = ref.watch(counterProvider);
              final text = count ?? "Press the button";

              return Text(text.toString());
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: ref.read(counterProvider.notifier).increment,
          child: const Icon(Icons.plus_one),
        ),
      ),
    );
  }
}
