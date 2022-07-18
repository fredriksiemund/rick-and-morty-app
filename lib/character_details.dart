import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty_app/models/Character.dart';

class CharacterDetails extends StatefulWidget {
  const CharacterDetails({
    Key? key,
    required this.title,
    required this.id,
  }) : super(key: key);

  final String title;
  final int id;

  @override
  State<CharacterDetails> createState() => _CharacterDetailsState();
}

class _CharacterDetailsState extends State<CharacterDetails> {
  late Future<Character> _character;

  Future<Character> fetch() async {
    final url =
        Uri.parse('https://rickandmortyapi.com/api/character/${widget.id}');
    final res = await http.get(url);

    if (res.statusCode == 200) {
      Map<String, dynamic> parsedRes = jsonDecode(res.body);
      return Character.fromJson(parsedRes);
    } else {
      throw Exception('Failed to load character');
    }
  }

  @override
  void initState() {
    super.initState();
    _character = fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<Character>(
        future: _character,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Image.network(snapshot.data!.image),
                Center(
                  child: Text('Character details of ${snapshot.data!.name}'),
                )
              ],
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('An unexpected error occurred'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
