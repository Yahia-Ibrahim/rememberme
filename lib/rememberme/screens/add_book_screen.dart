import 'dart:developer';
import 'dart:math' as maths;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rememberme/rememberme/models/book.dart';
import 'package:rememberme/rememberme/widgets/flag_item.dart';
import 'package:transparent_image/transparent_image.dart';
import '../providers/books_provider.dart';
import 'dart:convert' as convert;

import '../providers/currently_reading_provider.dart';

class AddBookScreen extends ConsumerStatefulWidget {
  const AddBookScreen({super.key});

  @override
  ConsumerState<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends ConsumerState<AddBookScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // A key for managing the form
  final TextEditingController _titleController = TextEditingController();
  String _title = ''; // Variable to store the entered name
  String _dropdownValue1 = 'en';
  String _dropdownValue2 = 'ar-eg';
  String _coverImageURL = '';
  String _authors = '';
  List _suggestions = [];
  bool _currentlyReading = false;
  var _selectedBook;

  void onChanged(String text) {
    setState(() {
      text = text;
    });
  }
  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
  Future<void> _submitForm() async {
    // Check if the form is valid
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Save the form data
      _selectedBook = Book(
          originalLang: _dropdownValue1,
          targetLang: _dropdownValue2,
          title: _title,
          bookCoverURL: _coverImageURL,
          wordList: [],
          author: _authors
      );
      final wasAdded = await ref.read(booksNotifier.notifier).addNewBook(_selectedBook);
      if(_currentlyReading) {
        ref.read(currentlyReadingProvider.notifier).toggleBookReadingStatus(_selectedBook);
      }
      Navigator.of(context).pop();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a New Book', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.check, size: 30,),
            onPressed: () {
              // Navigate to the "Add Book" screen when the button is pressed
              _submitForm();
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey, // Associate the form key with this Form widget
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
          children: <Widget>[
            TextFormField(
              controller: _titleController, // Set the controller here
              decoration: const InputDecoration(labelText: 'Title'), // Label for the name field
              validator: (value) {
              // Validation function for the name field
                if (value!.isEmpty) {
                  return 'Please enter the book title.'; // Return an error message if the name is empty
                }
                  return null; // Return null if the name is valid
              },
              onSaved: (value) {
                _title = value!;
                // log(_title);// Save the entered title
              },
              onChanged: (text) async {
                setState(() {
                  _title = text;
                  _coverImageURL = '';
                  _authors = '';
                  if(text.length < 3) {
                    _suggestions.clear();
                    return;
                  }
                });
                var url = Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$_title');
                http.Response response = await http.get(url);
                var data;
                if(response.statusCode == 200) {
                  var jsonResponse = convert.jsonDecode(response.body);
                  var items = jsonResponse['items'];
                  setState(() {
                    // _suggestions = items.map((item) => item['volumeInfo']['title'].toString()).toList().sublist(0, maths.min(5, jsonResponse['totalItems'] as int));
                    _suggestions = items;
                        // .sublist(0, maths.min(5, jsonResponse['totalItems'] as int));
                  });
                }
                else {
                  print('Request failed with status: ${response.statusCode}');
                }
              },
            ),
            // Constrain the ListView to a fixed height
            SizedBox(
              height: (_title.length > 3 && _suggestions.isNotEmpty) ? 300 : 0, // Fixed height for the list
              child: ListView.builder(
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  var book = _suggestions[index];
                  return ListTile(
                    title: Text(
                      book['volumeInfo']['title'].toString(),
                      style: const TextStyle(color: Colors.blue),
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: (book['volumeInfo']['authors'] != null && book['volumeInfo']['authors'] is List)
                        ? Text((book['volumeInfo']['authors'] as List).map((author) => author.toString()).join(', ') as String, overflow: TextOverflow.ellipsis,)
                        : const Text(''),
                    onTap: () {
                      setState(() {
                        _title = book['volumeInfo']['title'].toString();
                        _titleController.text = book['volumeInfo']['title'].toString(); // Set the text in the controller
                        _coverImageURL = (book['volumeInfo']['imageLinks'] != null)
                            ? book['volumeInfo']['imageLinks']['thumbnail']
                            : '';
                        _authors = (book['volumeInfo']['authors'] != null && book['volumeInfo']['authors'] is List)
                            ? book['volumeInfo']['authors'].map((author) => author.toString()).join(', ')
                            : '';
                        _suggestions.clear();
                        _dropdownValue1 = (book['volumeInfo']['language'] == 'ar')
                                          ? book['volumeInfo']['language'] + '-eg'
                                          : book['volumeInfo']['language'];
                        _selectedBook = Book(
                            originalLang: _dropdownValue1,
                            targetLang: _dropdownValue2,
                            title: _title,
                            bookCoverURL: _coverImageURL,
                            wordList: [],
                            author: _authors
                        );
                        FocusScope.of(context).unfocus();
                        log(_title);
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            DropdownButton<String>(
                              value: _dropdownValue1,
                              hint: const Text("Select Country"),
                              items: languageCodes.map((country) {
                                return DropdownMenuItem<String>(
                                  value: country,
                                  child: Row(
                                    children: [
                                      buildLanguageFlag(country),
                                      const SizedBox(width: 10), // Space between flag and text
                                      Text(country), // Country name
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _dropdownValue1 = value!; // Update the selected country
                                });
                              },
                            ),
                            const Text(
                              "Original Language", // This is the label
                              // style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20.0,),
                        Column(
                          children: [
                            DropdownButton<String>(
                              value: _dropdownValue2,
                              hint: const Text("Select Country"),
                              items: languageCodes.map((country) {
                                return DropdownMenuItem<String>(
                                  value: country,
                                  child: Row(
                                    children: [
                                      buildLanguageFlag(country),
                                      const SizedBox(width: 10), // Space between flag and text
                                      Text(country), // Language Code
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _dropdownValue2 = value!; // Update the selected country
                                });
                              },
                            ),
                            const Text(
                              "Target Language", // This is the label
                              // style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30,),
                    SwitchListTile(
                      title: const Text('Currently Reading', style: TextStyle(fontSize: 17),),
                      value: _currentlyReading,
                      onChanged: (bool newValue) {
                        setState(() {
                          _currentlyReading = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 150,),
                    (_selectedBook != null)
                    ? (_coverImageURL.isNotEmpty)
                        ? FadeInImage(
                          placeholder: MemoryImage(kTransparentImage),
                          image: NetworkImage(_coverImageURL),
                          fit: BoxFit.cover,
                          height: 300,
                        )
                        : Container(color: Colors.white24, height: 300, width: 200,
                      child: Image.asset('images/pngtree-book-cover-png-image_6853237.png'),)
                    : Container(color: Colors.white,),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      )
    );
  }
}
