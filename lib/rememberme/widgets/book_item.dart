import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transparent_image/transparent_image.dart';
import './flag_item.dart';
import '../models/book.dart';

class BookItem extends StatelessWidget {
  const BookItem({super.key, required this.book, required this.onSelectBook});
  final Book book;

  final void Function(Book book) onSelectBook;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          // side: const BorderSide(color: Colors.blue, width: 3.0),
      ),
      clipBehavior: Clip.hardEdge,
      elevation: 5,
      child: InkWell(
        onTap: () => onSelectBook(book),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 5,),
            Column(
              children: [
                (book.bookCoverURL.isNotEmpty)
                ? FadeInImage(
                  placeholder: MemoryImage(kTransparentImage),
                  image: NetworkImage(book.bookCoverURL),
                  fit: BoxFit.cover,
                  height: 190,
                )
                : Image.asset('images/pngtree-book-cover-png-image_6853237.png', height: 190,),
                Column(
                  children: [
                    SizedBox(
                      height: 31,
                      child: Directionality(
                        textDirection: isRTL(book.title) ? TextDirection.rtl : TextDirection.ltr, // Set direction based on language
                        child: Text(
                          book.title,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.oswald(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    //const SizedBox(height: 100,),
                    SizedBox(
                      height: 22,
                      child: Text(
                        book.author,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        strutStyle: const StrutStyle(
                            fontSize: 15,
                            height: 1.0
                        ),
                        style: GoogleFonts.oswald(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Row(
                      children: [

                      ],
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  buildLanguageFlag(book.originalLang),
                  buildLanguageFlag(book.targetLang),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Helper function to detect if the text is RTL (Arabic, Hebrew, etc.)
  bool isRTL(String text) {
    final firstChar = text.runes.first;
    return (firstChar >= 0x600 && firstChar <= 0x6FF) || // Arabic
        (firstChar >= 0x0590 && firstChar <= 0x05FF); // Hebrew
  }
}

