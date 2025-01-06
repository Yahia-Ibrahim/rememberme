// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookAdapter extends TypeAdapter<Book> {
  @override
  final int typeId = 0;

  @override
  Book read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Book(
      originalLang: fields[0] as String,
      targetLang: fields[1] as String,
      title: fields[2] as String,
      bookCoverURL: fields[3] as String,
      wordList: (fields[5] as List).cast<Word>(),
      author: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Book obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.originalLang)
      ..writeByte(1)
      ..write(obj.targetLang)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.bookCoverURL)
      ..writeByte(4)
      ..write(obj.author)
      ..writeByte(5)
      ..write(obj.wordList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
