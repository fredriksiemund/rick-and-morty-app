import 'package:flutter/material.dart';
import 'package:rick_and_morty_app/character_details.dart';
import 'package:rick_and_morty_app/character_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const CharacterList(
        title: 'All characters',
      ),
      routes: <String, WidgetBuilder>{
        'character-list': (context) => const CharacterList(
              title: 'All characters',
            ),
        'character-details': (context) => const CharacterDetails(
              title: 'Character details',
            )
      },
    );
  }
}
