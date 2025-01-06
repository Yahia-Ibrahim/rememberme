import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rememberme/rememberme/screens/results_screen.dart';

import '../models/Word.dart';

class QuizScreen extends StatefulWidget {
  QuizScreen({super.key, required this.words});
  List<Word> words;
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // Random instance
  Random _random = Random();
  Word _word = Word(text: '', translations: []);
  List<Word> _choices = [];
  List<String> _answers = [];
  bool _isAnswered = false;
  int _questionIndex = 0;
  List<Color> _colors = [
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
  ];
  int _wrongCount = 0;
  bool _disabled = false;

  Future<bool> updateQuestion() async {
    if(_questionIndex == 0) {
      _questionIndex++;
    }
    if(_questionIndex > widget.words.length) {
      bool result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => ResultsScreen(percent: ((widget.words.length - _wrongCount) / widget.words.length)))
      ) as bool;
      if(result) {
        print(result);
        Navigator.of(context).pop();
      }
    }
    setState(() {
      _isAnswered = false;
      _disabled = false;
      _word = widget.words.first;
      widget.words.remove(_word);
      _choices.clear();
      _choices.add(_word);
      // Set to hold unique indices
      Set<int> indices = {};
      // Choose 3 unique random indices
      // print(widget.words.length);
      while (indices.length < 3) {
        indices.add(_random.nextInt(widget.words.length));
      }
      for(int idx = 0; idx < 3; idx++) {
        _choices.add(widget.words[indices.elementAt(idx)]);
      }
      widget.words.add(_word);
      _answers = _choices.map(
              (choice) => choice.translations[_random.nextInt(choice.translations.length)]
      ).toList();
      _answers.shuffle();
      _colors = [
        Colors.white,
        Colors.white,
        Colors.white,
        Colors.white,
      ];
    });
    return true;
  }
  @override
  Widget build(BuildContext context) {
    if(_questionIndex == 0) updateQuestion();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.close, size: 30,),),
      ),
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(20.0),
          padding: EdgeInsets.zero,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 300,
                width: 300,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    // width: 20,
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(10.0), // Uniform radius
                ),
                child: Center(
                  child: Text(
                    _word.text,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    )
                  ),
                ),
              ),
              const SizedBox(height: 30,),
              for(var idx = 0; idx < 4; idx++)
                Container(
                  margin: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed:  (_disabled) ? null : () {
                      if(_word.translations.contains(_answers[idx])) {
                        setState(() {
                          _isAnswered = true;
                          _colors[idx] = Colors.green.shade400;
                          _disabled = true;
                          _questionIndex++;
                          if(_colors[0] == Colors.red.shade400
                              || _colors[1] == Colors.red.shade400
                              || _colors[2] == Colors.red.shade400
                              || _colors[3] == Colors.red.shade400
                          )  {
                            _wrongCount++;
                          }
                        });
                      }
                      else {
                        setState(() {
                          _colors[idx] = Colors.red.shade400;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: _colors[idx],
                      disabledBackgroundColor: _colors[idx],
                      elevation: 12,
                      // padding: const EdgeInsets.fromLTRB(100, 0, 100, 0),
                      minimumSize: const Size(300, 50),
                      maximumSize: const Size(300, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        
                      ),
                    ),
                    child: Center(
                      child: Text(
                        // _answers[idx].translations[_random.nextInt(_answers[idx].translations.length)],
                        _answers[idx],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
              (_isAnswered)
                ? TextButton(
                    onPressed: () {
                      updateQuestion();
                    },
                    child: const Text('next', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),)
                )
                : const SizedBox(),
            ],
          ),
        ),
      )
    );
  }
}
