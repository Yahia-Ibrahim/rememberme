import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rememberme/rememberme/models/Word.dart';
import 'package:translator/translator.dart';
import '../models/book.dart';

class EditWord extends StatefulWidget {
  const EditWord({
    super.key,
    required this.word,
    required this.translations,
  });
  final String word;
  final List<String> translations;

  @override
  State<EditWord> createState() => _NewWordState();
}

class _NewWordState extends State<EditWord> {

  final _translationEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _translationEditingController.dispose();
    super.dispose();
  }
  // void _getTranslation(String word) {
  //   if(word.isEmpty || _textEditingController.text.length < 3) {
  //     setState(() {
  //       _translation = '';
  //     });
  //     return;
  //   }
  //   setState(() {
  //     widget.translator.translate(word, from: widget.book.originalLang.substring(0, 2), to: widget.book.targetLang.substring(0, 2)).then((result) => _translation = result.text);
  //   });
  //   log(_translation);
  // }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Center(
                      child: Text(
                        maxLines: 3,
                        widget.word,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      )
                  )
              ),
              Expanded(
                  child: Center(
                      child: Text(
                        maxLines: 3,
                        widget.translations.first,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      )
                  ),
              ),
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                        label: Text('add translation', style: TextStyle(color: Colors.blue),)
                    ),
                    controller: _translationEditingController,
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.blue,),
                    onPressed: () {
                      if(_translationEditingController.text.isEmpty) {
                        return;
                      }
                      setState(() {
                        widget.translations.add(_translationEditingController.text);
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          // Form(
          //   key: _formKey,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       const SizedBox(width: 20,),
          //       Expanded(
          //         child: TextFormField(
          //           decoration: const InputDecoration(
          //             label: Text('Add Translation', style: TextStyle(color: Colors.blue),),
          //           ),
          //           controller: _translationEditingController,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // const SizedBox(height: 20,),
          // const Text(
          //   'Translation',
          //   style: TextStyle(
          //       color: Colors.blue,
          //       fontSize: 17
          //   ),
          // ),
          // Text(
          //   _translation,
          //   style: const TextStyle(
          //       fontSize: 15,
          //       color: Colors.black45
          //   ),
          // ),
          // const SizedBox(height: 20,),
          // const Divider(),
          SizedBox(
            height: 180,
            child: ListView.builder(
              itemCount: widget.translations.length,
              itemBuilder: (context, index) {
                // if(index == 0) {
                //   return null;
                // }
                var word = widget.translations[index];
                return (word != widget.translations.first) ? ListTile(
                  title: Text(
                    word,
                    style: const TextStyle(
                        fontSize: 15
                    ),
                  ),
                  trailing: InkWell(
                      child: const Icon(
                        Icons.delete_forever, color: Colors.red,
                      ),
                    onTap: () {
                        setState(() {
                          widget.translations.remove(word);
                        });
                    },
                  ),
                ) : const SizedBox();
              },
            ),
          ),
          const Divider(),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(Word(
                            text: '',
                            translations: []
                          )
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete_forever, color: Colors.red, size: 20,),
                          Text(
                            'delete word',
                            style: TextStyle(fontSize: 17, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(Word(
                            text: widget.word,
                            translations: widget.translations
                        )
                        );
                      },
                      child: const InkWell(
                        child: Row(
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
            ),
          ),
        ],
      ),
    );
  }
}
