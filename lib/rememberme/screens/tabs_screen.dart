import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rememberme/rememberme/old_files/favorites_provider.dart';
import 'package:rememberme/rememberme/screens/add_book_screen.dart';
import 'package:rememberme/rememberme/screens/books_screen.dart';
import 'package:rememberme/rememberme/screens/currently_reading_screen.dart';
// import 'package:rememberme/rememberme/screens/filters_screen.dart';
// import 'package:rememberme/rememberme/screens/meals_screen.dart';
import 'package:rememberme/rememberme/widgets/main_drawer.dart';
import '../models/book.dart';
// import '../models/meal.dart';
import '../providers/books_provider.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});
  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {

  int _selectedPgeIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPgeIndex = index;
    });
    // if(_selectedPgeIndex == 1) {
    //   Navigator.of(context).push(
    //       MaterialPageRoute(builder: (ctx) => const AddBookScreen())
    //   );
    //   //activePageTitle = 'Add a New Book';
    // }
  }
  // void _setScreen(String identifier) {
  //   Navigator.of(context).pop();
  //   if(identifier == 'filters') {
  //     Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const FiltersScreen()));
  //   }
  //   else {
  //     Navigator.of(context).pop();
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    Widget activePage = const BooksScreen();

    if(_selectedPgeIndex == 1) {
      activePage = const CurrentlyReadingScreen();
    }
    return Scaffold(
        // appBar: AppBar(
        //   title: Text(activePageTitle, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        //   backgroundColor: Colors.blue,
        // ),
      body: activePage,

      // drawer: MainDrawer(onSelectScreen: _setScreen,),
      bottomNavigationBar: BottomNavigationBar(
          onTap: _selectPage,
          currentIndex: _selectedPgeIndex,
          backgroundColor: Colors.blue,
          selectedItemColor: Colors.white,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.book_sharp), label: "Books"),
            BottomNavigationBarItem(icon: Icon(Icons.access_time_outlined), label: "Currently Reading"),
          ]
      ),
    );
  }
}
