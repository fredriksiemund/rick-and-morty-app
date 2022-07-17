import 'package:flutter/material.dart';
import 'package:rick_and_morty_app/models/Character.dart';

class CharacterDetails extends StatelessWidget {
  final String title;

  const CharacterDetails({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final character = ModalRoute.of(context)!.settings.arguments as Character;

    return Scaffold(
      appBar: AppBar(
        title: Text(character.name),
      ),
      body: Center(
        child: Text('Character details of ${character.name}'),
      ),
    );
  }
}
