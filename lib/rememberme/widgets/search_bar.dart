import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/book.dart';

class SearchBar extends StatefulWidget {
  final Function(String) onTextChanged;

  const SearchBar({super.key, required this.onTextChanged});

  @override
  _SearchBarState createState() => _SearchBarState();

}
class _SearchBarState extends State<SearchBar> {
  String query = '';
  _SearchBarState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: (text) {
          widget.onTextChanged(text);
        },
        decoration: const InputDecoration(
          labelText: 'Search Books...',
          border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(50.0))),
          prefixIcon: Icon(Icons.search),
          filled: true,
          fillColor: Colors.black12,
        ),
      ),
    );
  }
}