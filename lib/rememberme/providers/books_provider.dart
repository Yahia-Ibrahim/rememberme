import "dart:developer";

import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:hive/hive.dart";
// import "package:rememberme/rememberme/data/dummy_data.dart";

import "../models/book.dart";


class BooksNotifier extends StateNotifier<List<Book>>{
  BooksNotifier(): super([]) {
    _loadBooksFromHive();
  }

  final Box<Book> booksBox = Hive.box<Book>('booksBox');

  // Load books from Hive when initializing
  void _loadBooksFromHive() {
    state = booksBox.values.toList();
  }

  Future<bool> addNewBook(Book book) async {
    bool bookExists = booksBox.values.where((elem) => elem.title == book.title).isNotEmpty;
    print(bookExists);
    print("books");
    if (bookExists) {
      // Find the key for the existing book
      int bookKey = booksBox.keys.firstWhere((key) => booksBox.get(key)?.title == book.title);
      // Update the existing book using the key
      await booksBox.put(bookKey, book);
      state = [...booksBox.values];
      // log(booksBox.get(bookKey)!.wordList.first.text);
      return false;
    }
    else {
      state = [...state, book];
      booksBox.add(book);
      return true;
    }
  }

  void deleteBook(Book book) async {
    bool bookExists = booksBox.values.contains(book);
    if (bookExists) {
      // Find the key for the existing book
      int bookKey = booksBox.keys.firstWhere((key) => booksBox.get(key) == book);
      await booksBox.delete(bookKey);
      state = state.where((e) => e.title != book.title).toList();
    }
  }
}

// final booksProvider = Provider((ref) {
//   return books;
// });
final booksNotifier =
StateNotifierProvider<BooksNotifier, List<Book>>((ref) {
  return BooksNotifier();
});


