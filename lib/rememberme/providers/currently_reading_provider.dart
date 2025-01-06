import "dart:developer";

import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:hive/hive.dart";
import "../models/book.dart";

class CurrentlyReadingNotifier extends StateNotifier<List<Book>>{
  CurrentlyReadingNotifier() : super([]) {
    _initialize();
  }

  Box<Book>? currentlyReadingBooksBox;

  Future<void> _initialize() async {
    currentlyReadingBooksBox = await Hive.openBox<Book>('currentlyReadingBooksBox');
    _loadBooksFromHive();
  }

  // Load books from Hive asynchronously
  void _loadBooksFromHive() {
    state = currentlyReadingBooksBox!.values.toList();
  }

  bool toggleBookReadingStatus(Book book) {
    if (currentlyReadingBooksBox == null) return false;

    bool bookExists = currentlyReadingBooksBox!.values.where((elem) => elem.title == book.title).isNotEmpty;
    if(bookExists) {
      Iterable bookKeys = currentlyReadingBooksBox!.keys.where((key) => currentlyReadingBooksBox!.get(key) == book);
      state = state.where((e) => e.title != book.title).toList();
      for(final key in bookKeys) {
        currentlyReadingBooksBox!.delete(key);
      }
      return false;
    }
    else {
      state = [...state, book];
      currentlyReadingBooksBox!.add(book);
      return true;
    }
  }

  Future<bool> updateBook(Book book) async {
    bool bookExists = currentlyReadingBooksBox!.values.where((elem) => elem.title == book.title).isNotEmpty;
    print(bookExists);
    print('currently reading');
    if (bookExists) {
      // Find the key for the existing book
      int bookKey = currentlyReadingBooksBox!.keys.firstWhere((key) => currentlyReadingBooksBox!.get(key)?.title == book.title);
      // Update the existing book using the key
      await currentlyReadingBooksBox!.put(bookKey, book);
      state = [...currentlyReadingBooksBox!.values];
      // log(currentlyReadingBooksBox!.get(bookKey)!.wordList.first.text);
      return true;
    }
    return false;
  }

  void deleteBook(Book book) {
    if (currentlyReadingBooksBox == null) return;
    bool bookExists = currentlyReadingBooksBox!.values.contains(book);
    if (bookExists) {
      // Find the key for the existing book
      int bookKey = currentlyReadingBooksBox!.keys.firstWhere((key) => currentlyReadingBooksBox!.get(key) == book);
      currentlyReadingBooksBox!.delete(bookKey);
      state = state.where((e) => e.title != book.title).toList();
    }
  }
}

final currentlyReadingProvider =
StateNotifierProvider<CurrentlyReadingNotifier, List<Book>>((ref) {
  return CurrentlyReadingNotifier();
});

