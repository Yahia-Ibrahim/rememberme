

import 'package:hive/hive.dart';

import 'Word.dart';

part 'book.g.dart'; // Needed for code generation

@HiveType(typeId: 0)
class Book {
  @HiveField(0)
  final String originalLang;

  @HiveField(1)
  final String targetLang;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String bookCoverURL;

  @HiveField(4)
  final String author;

  @HiveField(5)
  final List<Word> wordList;

  Book(
      {
        required this.originalLang,
        required this.targetLang,
        required this.title,
        required this.bookCoverURL,
        required this.wordList,
        required this.author,
      }
    );
}