import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rememberme/rememberme/providers/books_provider.dart';
import 'package:rememberme/rememberme/providers/currently_reading_provider.dart';
import 'package:rememberme/rememberme/screens/books_screen.dart';

import 'package:rememberme/rememberme/screens/tabs_screen.dart';
import '../models/book.dart';

class EditBookScreen extends ConsumerWidget {
  const EditBookScreen({required this.book, super.key});
  final Book book;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SwitchListTile(
                  title: const Text('Currently Reading', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                  value: ref.watch(currentlyReadingProvider).where((elem) => elem.title == book.title).isNotEmpty,
                  onChanged: (bool newValue) {
                    final wasAdded = ref.read(currentlyReadingProvider.notifier).toggleBookReadingStatus(book);
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text((wasAdded) ? 'Book Added to the Currently Reading List' : 'Book Removed from the Currently Reading List')));
                  },
              ),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: AlertDialog(
                          title: const Text('Delete this book...'),
                          content: const Text('Are You Sure You want to delete this book?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                            ),
                            TextButton(
                              onPressed: () {
                                ref.read(booksNotifier.notifier).deleteBook(book);
                                ref.read(currentlyReadingProvider.notifier).deleteBook(book);
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context) => const TabsScreen()), // Replace with your screen
                                      (Route<dynamic> route) => true, // This will remove all the routes in the stack
                                );
                              },
                              child: const Text('Confirm', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
                            ),
                          ],
                        ),
                      );
                    },
                  );

                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete_forever, color: Colors.red,),
                    Text('Delete Book', style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),),
                  ],
                ),
              )
            ],
          ),
      ),
    );
  }
}
