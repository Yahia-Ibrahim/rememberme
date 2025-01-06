// import 'dart:math';

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rememberme/rememberme/screens/words_screen.dart';
import '../models/book.dart';
import '../old_files/filters_screen.dart';
import '../providers/books_provider.dart';
import '../providers/currently_reading_provider.dart';
import '../widgets/book_item.dart';

class CurrentlyReadingScreen extends ConsumerStatefulWidget {
  const CurrentlyReadingScreen({super.key});
  @override
  ConsumerState<CurrentlyReadingScreen> createState() => CurrentlyReadingScreenState();
}

class CurrentlyReadingScreenState extends ConsumerState<CurrentlyReadingScreen> {
  List<Book> books = [];
  @override
  void initState() {
    super.initState();
    books = ref.read(currentlyReadingProvider); // Initially, all items are displayed
  }

  void _setScreen(String identifier) {
    Navigator.of(context).pop();
    if(identifier == 'filters') {
      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const FiltersScreen()));
    }
    else {
      Navigator.of(context).pop();
    }
  }
  // void _filterList(String query) {
  //   setState(() {
  //     if (query.isEmpty) {
  //       filterBooks = ref.read(booksNotifier);
  //     } else {
  //       List<Book> books = ref.read(booksNotifier);
  //       filterBooks = books
  //           .where((book) =>
  //           book.title.toLowerCase().contains(query.toLowerCase())) // Filter logic
  //           .toList();
  //     }
  //   });
  //   for(final book in books) {
  //     log(book.title);
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    setState(() {
      books = ref.read(currentlyReadingProvider);
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currently reading...', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.blue,
      ),
      // drawer: MainDrawer(onSelectScreen: _setScreen,),
      body: content(context),
    );
  }

  Column content(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 6 / 10,
            ),
            children: books.map((e) => BookItem(book: e, onSelectBook: (Book book) {
              final result = Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => WordsScreen(book: book,)));
              ref.read(booksNotifier.notifier).addNewBook(book);
              ref.read(currentlyReadingProvider.notifier).updateBook(book);
              setState(() {
                books = ref.read(currentlyReadingProvider);
              });
            },)).toList(),
          ),
        ),
      ],
    );
  }
}
