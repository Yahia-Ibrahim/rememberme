import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rememberme/rememberme/screens/quiz_screen.dart';

import '../models/Word.dart';

class QuizStarterScreen extends StatefulWidget {
  const QuizStarterScreen({super.key, required this.wordList});
  final List<Word> wordList;
  @override
  State<QuizStarterScreen> createState() => _QuizStarterScreenState();
}

class _QuizStarterScreenState extends State<QuizStarterScreen> {
  double _sliderValue = 4;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            Slider(
                value: _sliderValue.roundToDouble(),
                min: 4,
                max: widget.wordList.length.toDouble(),
                activeColor: Colors.blue,
                onChanged: (value) {
                  setState(() {
                    _sliderValue = value;
                  });
                }
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Number of Questions',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  '${_sliderValue.round()}',
                  style: const TextStyle(fontSize: 18),
                )
              ],
            ),
            const SizedBox(height: 500,),
            ElevatedButton(
                onPressed: () {
                  Random random = Random();
                  // Choose a random number of elements to extract
                  int randomNumOfElements = random.nextInt(widget.wordList.length) + 1;
                  // Extract random elements (without repetition)
                  List<Word> words = widget.wordList..shuffle()..sublist(0, randomNumOfElements);
                  print(words.length);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => QuizScreen(words: words,)));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue
                ),
                child: const Text('Start Quiz', style: TextStyle(color: Colors.white, fontSize: 20),),
            )
          ],
        ),
      ),
    );
  }
}
