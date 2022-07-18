import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty_app/character_details.dart';
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
  final _controller = ScrollController();
  List<Character> _characters = [];
  String _nextPage = 'https://rickandmortyapi.com/api/character';
  bool _hasMore = true;
  bool _isLoading = false;

  Future fetch() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(_nextPage);
    final res = await http.get(url);

    if (res.statusCode == 200) {
      Map<String, dynamic> parsedRes = jsonDecode(res.body);
      String? nextPageRaw = parsedRes['info']['next'];
      setState(() {
        if (nextPageRaw == null) {
          _hasMore = false;
        } else {
          _nextPage = nextPageRaw;
        }

        _characters.addAll(List<Character>.from(
            parsedRes['results'].map((entry) => Character.fromJson(entry))));

        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load character');
    }
  }

  Future refresh() async {
    setState(() {
      _characters = [];
      _nextPage = 'https://rickandmortyapi.com/api/character';
      _hasMore = true;
      _isLoading = false;
    });

    fetch();
  }

  @override
  void initState() {
    super.initState();

    fetch();

    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.offset &&
          _hasMore) {
        fetch();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
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
          controller: _controller,
          padding: const EdgeInsets.all(16.0),
          itemCount: _characters.length * 2 + 1,
          itemBuilder: (context, i) {
            if (i.isOdd) return const Divider();

            final index = i ~/ 2;
            if (index < _characters.length) {
              return ListTile(
                leading: Image.network(_characters[index].image),
                title: Text(_characters[index].name),
                subtitle: Text(_characters[index].species),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CharacterDetails(
                      title: _characters[index].name,
                      id: _characters[index].id,
                    ),
                  ),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: _hasMore
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
