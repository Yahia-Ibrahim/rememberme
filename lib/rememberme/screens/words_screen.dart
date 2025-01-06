import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rememberme/rememberme/providers/books_provider.dart';
import 'package:rememberme/rememberme/providers/currently_reading_provider.dart';
import 'package:rememberme/rememberme/screens/edit_book_screen.dart';
import 'package:rememberme/rememberme/screens/quiz_starter_screen.dart';
import 'package:translator/translator.dart';
import 'package:transparent_image/transparent_image.dart';

import '../models/Word.dart';
import '../models/book.dart';
import '../widgets/edit_word.dart';
import '../widgets/new_Word.dart';

class WordsScreen extends ConsumerStatefulWidget {
  const WordsScreen({super.key, required this.book});
  final Book book;

  @override
  ConsumerState<WordsScreen> createState() => _WordsScreenState();
}

class _WordsScreenState extends ConsumerState<WordsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading:
        IconButton(
          onPressed: () {
            Navigator.of(context).pop(widget.book);
          },
          icon: const Icon(Icons.arrow_back_outlined,
            color: Colors.blue,
          )
        ),
        actions: [
          // IconButton(onPressed: () {}, icon: const Icon(Icons.star_border_outlined), color: Colors.blue,),
          InkWell(
              child: IconButton(
                onPressed: () async {
                  final result = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => EditBookScreen(book: widget.book,)),
                  );
                },
                icon: const Icon(Icons.edit),
                color: Colors.blue,
              )
          )
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.book.title,
                        maxLines: 4,
                        // textWidthBasis: TextWidthBasis.longestLine,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.oswald(fontSize: 30, fontWeight: FontWeight.w900, /*color: Colors.blue,*/),
                      ),
                      const SizedBox(height: 15,),
                      Text(widget.book.author,
                        maxLines: 2,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 17, color: Colors.black45),
                      ),
                    ],
                  ),
                ),
                (widget.book.bookCoverURL.isNotEmpty)
                    ? FadeInImage(
                  placeholder: MemoryImage(kTransparentImage),
                  image: NetworkImage(widget.book.bookCoverURL),
                  fit: BoxFit.cover,
                  height: 150,
                )
                    : Image.asset('images/pngtree-book-cover-png-image_6853237.png', height: 150,),
              ],
            ),
            const SizedBox(height: 35,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Your Words:',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                InkWell(
                  child: IconButton(
                    onPressed: () async {
                      final translator = GoogleTranslator();
                      final result = await showModalBottomSheet(
                          context: context,
                          builder: (c) => NewWord(
                              book: widget.book,
                              translator: translator
                          )
                      );
                      if(result != null) {
                        setState(() {
                          widget.book.wordList.add(result);
                        });
                        if(ref.read(currentlyReadingProvider).where((elem) => widget.book.title == elem.title).isNotEmpty) {
                          ref.read(currentlyReadingProvider.notifier).updateBook(widget.book);
                        }
                        ref.read(booksNotifier.notifier).addNewBook(widget.book);
                      }
                    },
                    icon: const Icon(Icons.add_circle),
                    color: Colors.blue,
                  ),
                )
              ],
            ),
            const Divider(
              color: Colors.blue,
            ),
            Expanded(
              child: SizedBox(
                height: 300, // Fixed height for the list
                child: (widget.book.wordList.isNotEmpty) ? ListView.builder(
                  itemCount: widget.book.wordList.length,
                  itemBuilder: (context, index) {
                    var word = widget.book.wordList[index];
                    return ListTile(
                      title: Text(
                        word.text.toString(),
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 15
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Container(
                        width: MediaQuery.of(context).size.width * 0.4, // Limit trailing width
                        child: Text(
                          word.translations.join(', '),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 15),
                          maxLines: 2,
                          textAlign: TextAlign.end, // Align trailing text to the right
                        ),
                      ),
                      onTap: () async {
                        final result = await showModalBottomSheet(
                            context: context,
                            builder: (c) => EditWord(
                                word: word.text,
                                translations: word.translations
                            )
                        );
                        if(result != null) {
                          if(result.text.isEmpty) {
                            setState(() {
                              widget.book.wordList.removeWhere((text) => text.text == word.text);
                            });
                            return;
                          }
                          setState(() {
                            word = Word(text: word.text, translations: result.translations);
                          });
                        }
                      },
                    );
                  },
                )
                : const SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.emoji_nature, color: Colors.grey, size: 50,),
                      Text('WOW! That\'s Empty', style: TextStyle(color: Colors.grey, fontSize: 15),),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_arrow_rounded, color: (widget.book.wordList.length >= 4) ? Colors.blue : Colors.grey,),
                TextButton(
                    onPressed: () {
                      if(widget.book.wordList.length >= 4) {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (ctx) => QuizStarterScreen(wordList: widget.book.wordList,))
                        );
                      }
                    },
                    child: (widget.book.wordList.length >= 4)
                      ? const Text(
                        'Take a Quiz',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                        ),
                    )
                    : const Text(
                      'Take a Quiz',
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      ),
                    )
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
