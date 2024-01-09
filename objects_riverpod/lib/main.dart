import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final TextEditingController _nameController = TextEditingController();
final TextEditingController _ageController = TextEditingController();

Future<Person?> showAddOrUpdateDialog(BuildContext context,
    [Person? existingPerson]) {
  String? name = existingPerson?.name;
  int? age = existingPerson?.age;

  _nameController.text = name ?? '';
  _ageController.text = age?.toString() ?? '';

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Name',
                ),
                onChanged: (value) => name = value,
              ),
              TextField(
                controller: _ageController,
                decoration: const InputDecoration(
                  hintText: 'age',
                ),
                onChanged: (value) => age = int.tryParse(value),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
                onPressed: () {
                  if (name != null || age != null) {
                    if (existingPerson != null) {
                      final newPerson = existingPerson.updated(
                        name: name,
                        age: age,
                      );
                      Navigator.of(context).pop(newPerson);
                    } else {
                      Navigator.of(context).pop(
                        Person(name: name!, age: age!),
                      );
                    }
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Save'))
          ],
        );
      });
}

@immutable
class Person {
  final String name;
  final int age;
  final String uuid;

  Person({required this.name, required this.age, String? uuid})
      : uuid = uuid ?? const Uuid().v4();

  Person updated({String? name, int? age}) =>
      Person(name: name ?? this.name, age: age ?? this.age);

  String get displayName => '$name is $age years old';

  @override
  bool operator ==(covariant Person other) => uuid == other.uuid;

  @override
  int get hashCode => uuid.hashCode;
}

class DataModel extends ChangeNotifier {
  final List<Person> _person = [];

  int get length => _person.length;

  UnmodifiableListView get person => UnmodifiableListView(_person);

  void add(Person person) {
    _person.add(person);
    notifyListeners();
  }

  void remove(Person person) {
    _person.remove(person);
    notifyListeners();
  }

  void update(Person updatedPerson) {
    final index = _person.indexOf(updatedPerson);
    final oldPerson = _person[index];

    if (oldPerson.name != updatedPerson.name ||
        oldPerson.age != updatedPerson.age) {
      oldPerson.updated(
        name: updatedPerson.name,
        age: updatedPerson.age,
      );
    }
    notifyListeners();
  }
}

final dataModelProvider = ChangeNotifierProvider<DataModel>(
  (_) => DataModel(),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, child) {
          final dataModel = ref.watch(dataModelProvider);
          return ListView.builder(
              itemCount: dataModel.length,
              itemBuilder: (context, index) {
                final person = dataModel.person[index];
                return ListTile(
                  title: Text(person.displayName),
                  onTap: () async {
                    final updatedPerson =
                        await showAddOrUpdateDialog(context, person);
                    if (updatedPerson != null) {
                      dataModel.update(updatedPerson);
                    }
                  },
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final person = await showAddOrUpdateDialog(context);
          if (person != null) {
            ref.read(dataModelProvider.notifier).add(person);
          }
        },
      ),
    );
  }
}
