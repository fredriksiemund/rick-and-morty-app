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
  final controller = ScrollController();
  List<Character> characters = [];
  String nextPage = 'https://rickandmortyapi.com/api/character';
  bool hasMore = true;
  bool isLoading = false;

  Future fetch() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    final url = Uri.parse(nextPage);
    final res = await http.get(url);

    if (res.statusCode == 200) {
      Map<String, dynamic> parsedRes = jsonDecode(res.body);
      String? nextPageRaw = parsedRes['info']['next'];
      setState(() {
        if (nextPageRaw == null) {
          hasMore = false;
        } else {
          nextPage = nextPageRaw;
        }

        characters.addAll(List<Character>.from(
            parsedRes['results'].map((entry) => Character.fromJson(entry))));

        isLoading = false;
      });
    } else {
      throw Exception('Failed to load character');
    }
  }

  Future refresh() async {
    setState(() {
      characters = [];
      nextPage = 'https://rickandmortyapi.com/api/character';
      hasMore = true;
      isLoading = false;
    });

    fetch();
  }

  @override
  void initState() {
    super.initState();

    fetch();

    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset && hasMore) {
        fetch();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: ListView.builder(
          controller: controller,
          padding: const EdgeInsets.all(16.0),
          itemCount: characters.length * 2 + 1,
          itemBuilder: (context, i) {
            if (i.isOdd) return const Divider();

            final index = i ~/ 2;
            if (index < characters.length) {
              return ListTile(
                leading: Image.network(characters[index].image),
                title: Text(characters[index].name),
                subtitle: Text(characters[index].species),
                onTap: () =>
                    Navigator.of(context).pushNamed('character-details'),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: hasMore
                      ? const CircularProgressIndicator()
                      : const Text('No more data to load'),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
