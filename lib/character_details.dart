import 'package:flutter/material.dart';

class CharacterDetails extends StatelessWidget {
  const CharacterDetails({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: const Center(
        child: Text('Character details'),
      ),
    );
  }
}
