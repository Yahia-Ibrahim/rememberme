import 'package:hive/hive.dart';

part 'Word.g.dart'; // Ensure this is correct

@HiveType(typeId: 1)  // Use a unique type ID for Word
class Word {
  @HiveField(0)
  final String text;

  @HiveField(1)
  final List<String> translations;

  Word({
    required this.text,
    required this.translations,
  });
}