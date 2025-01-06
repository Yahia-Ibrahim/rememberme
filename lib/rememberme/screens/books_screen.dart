// import 'dart:math';

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rememberme/rememberme/screens/words_screen.dart';
import '../models/book.dart';
import '../old_files/filters_screen.dart';
import '../providers/books_provider.dart';
import '../widgets/book_item.dart';
import '../widgets/search_bar.dart' as search;
import 'add_book_screen.dart';

class BooksScreen extends ConsumerStatefulWidget {
  const BooksScreen({super.key});

  @override
  ConsumerState<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends ConsumerState<BooksScreen> {
  List<Book> filterBooks = [];
  @override
  void initState() {
    super.initState();
    filterBooks = ref.read(booksNotifier); // Initially, all items are displayed
    // for(final book in filterBooks)
    //   log(book.title);
    _filterList('');
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
  void _filterList(String query) {
    setState(() {
      if (query.isEmpty) {
        filterBooks = ref.read(booksNotifier);
      } else {
        List<Book> books = ref.read(booksNotifier);
        filterBooks = books
            .where((book) =>
            book.title.toLowerCase().contains(query.toLowerCase())) // Filter logic
            .toList();
      }
    });
    for(final book in filterBooks) {
      log(book.title);
    }
  }

  Future<void> _refreshBooks() async {
    setState(() {
      filterBooks = ref.read(booksNotifier); // Reload the books list
    });
  }


  @override
  Widget build(BuildContext context) {
    log('entered');
    // for(final book in filterBooks) {
    //   log(book.title);
    // }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Books', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.blue,
        actions: [
          InkWell(
            child: IconButton(
              color: Colors.white,
              icon: const Icon(Icons.add, size: 30,),
              onPressed: () async {
                // Navigate to the "Add Book" screen when the button is pressed
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const AddBookScreen()),
                );
                _filterList('');
              },
            ),
          ),
        ],
      ),
      // drawer: MainDrawer(onSelectScreen: _setScreen,),
      body: content(context),
    );
  }

  Column content(BuildContext context) {
    return Column(
      children: [
        search.SearchBar(onTextChanged: _filterList,),
        Expanded(
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 6 / 10,
            ),
            children: filterBooks.map((e) => BookItem(
              book: e,
              onSelectBook: (Book book) async {
                final result = await Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => WordsScreen(book: book,)));
                ref.read(booksNotifier.notifier).addNewBook(book);
                _filterList('');
              },)).toList(),
          ),
        ),
      ],
    );
  }
}
