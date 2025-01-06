import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rememberme/rememberme/models/Word.dart';
import 'package:translator/translator.dart';
import '../models/book.dart';

class NewWord extends StatefulWidget {
  const NewWord({
    super.key,
    required this.book,
    required this.translator});
  final Book book;
  final GoogleTranslator translator;

  @override
  State<NewWord> createState() => _NewWordState();
}

class _NewWordState extends State<NewWord> {
  String _translation = '';
  List<String> _translations = [];
  final _textEditingController = TextEditingController();
  final _translationEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _textEditingController.dispose();
    _translationEditingController.dispose();
    super.dispose();
  }
  void _getTranslation(String word) {
    if(word.isEmpty || _textEditingController.text.length < 3) {
      setState(() {
        _translation = '';
      });
      return;
    }

    setState(() {
      widget.translator.translate(word, from: widget.book.originalLang.substring(0, 2), to: widget.book.targetLang.substring(0, 2)).then((result) => _translation = result.text);
    });
    log(_translation);
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Form(
            key: _formKey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      label: Text('Word', style: TextStyle(color: Colors.blue),),
                    ),
                    validator: (value) {
                      if(value == null || value.isEmpty) {
                        return 'please enter a word';
                      }
                      return null;
                    },
                    controller: _textEditingController,
                    onChanged: _getTranslation,
                  ),
                ),
                const SizedBox(width: 20,),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      label: Text('Add another translation', style: TextStyle(color: Colors.blue),),
                    ),
                    controller: _translationEditingController,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20,),
          const Text(
            'Translation',
            style: TextStyle(
                color: Colors.blue,
                fontSize: 17
            ),
          ),
          Text(
            _translation,
            style: const TextStyle(
                fontSize: 15,
                color: Colors.black45
            ),
          ),
          const SizedBox(height: 20,),
          const Divider(),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: TextButton(
                  onPressed: () {
                    if(!_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter a word'),)
                      );
                      return;
                    }
                    _translations.add(_translation);
                    if(_translationEditingController.text.isNotEmpty) {
                      _translations.add(_translationEditingController.text);
                    }
                    Navigator.of(context).pop(Word(
                        text: _textEditingController.text,
                        translations: _translations
                      )
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check, color: Colors.blue,),
                      Text(
                        'Save',
                        style: TextStyle(fontSize: 17, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
            ),
          ),
        ],
      ),
    );
  }
}
