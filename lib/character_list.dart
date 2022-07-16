import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty_app/models/Character.dart';

class CharacterList extends StatefulWidget {
  final String title;

  const CharacterList({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<CharacterList> createState() => _CharacterListState();
}

class _CharacterListState extends State<CharacterList> {
  late Future<List<Character>> _futureCharacters;
  late String _nextPage;

  Future<List<Character>> fetchCharacters(String url) async {
    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      Map<String, dynamic> parsedRes = jsonDecode(res.body);
      _nextPage = parsedRes['info']['next'];
      return List<Character>.from(
          parsedRes['results'].map((entry) => Character.fromJson(entry)));
    } else {
      throw Exception('Failed to load character');
    }
  }

  // void fetchMoreCharacters() async {
  //   final moreCharacters = await fetchCharacters(await _nextPage);
  //   _futureCharacters = _futureCharacters + moreCharacters;
  // }

  @override
  void initState() {
    super.initState();
    _futureCharacters =
        fetchCharacters('https://rickandmortyapi.com/api/character');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Character>>(
        future: _futureCharacters,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: snapshot.data!.length * 2 + 1,
              itemBuilder: (context, i) {
                if (i.isOdd) return const Divider();

                final index = i ~/ 2;
                if (index >= snapshot.data!.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                return ListTile(
                  leading: Image.network(snapshot.data![index].image),
                  title: Text(snapshot.data![index].name),
                  subtitle: Text(snapshot.data![index].species),
                  onTap: () =>
                      Navigator.of(context).pushNamed('character-details'),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
