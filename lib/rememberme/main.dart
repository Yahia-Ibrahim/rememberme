import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rememberme/rememberme/notification/notification.dart';
import 'package:rememberme/rememberme/providers/books_provider.dart';
import 'package:rememberme/rememberme/screens/quiz_screen.dart';
import 'package:rememberme/rememberme/screens/results_screen.dart';
// import 'package:rememberme/rememberme/screens/categories_screen.dart';
import 'package:rememberme/rememberme/screens/tabs_screen.dart';
import 'package:rememberme/rememberme/screens/words_screen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:workmanager/workmanager.dart';
import 'models/Word.dart';
import 'models/book.dart';


void callbackDispatcher() {
  print("entered callback");
  // Re-initialize the FlutterLocalNotificationsPlugin for background execution
  Workmanager().executeTask((task, inputData) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // Initialize notifications when the task is triggered
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'daily_notification_channel',
      'Daily Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    ProviderContainer container = ProviderContainer();
    // Get the list of books from the provider
    final books = container.read(booksNotifier);
    late final Book randomBook;
    String body = '';
    if (books.isNotEmpty) {
      // Select a random book
      randomBook = (books..shuffle()).first; // Shuffle the list and take the first one
      if(randomBook.wordList.isEmpty) {
        body = 'Arn\'t you encountering any hard words? 🤨';
      }
      else {
        List<Word> words = randomBook.wordList;
        words.shuffle();
        body = 'do you know the meaning of ${words.first}';
      }
    }
    await flutterLocalNotificationsPlugin.show(
      0,
      (books.isEmpty) ? 'Reading any thing interesting' : randomBook.title,
      body,
      platformChannelSpecifics,
    );
    print("WorkManager Task Executed: $task");
    return Future.value(true);
  });
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  // Register the adapter for Book before opening a box
  Hive.registerAdapter(BookAdapter());
  Hive.registerAdapter(WordAdapter());
  await Hive.openBox<Book>('booksBox');
  await Hive.openBox<Book>('currentlyReadingBooksBox');

  await NotificationService.init();

  // Initialize notification service and timezones
  tz.initializeTimeZones();
  // Workmanager().initialize(
  //   callbackDispatcher, // The background task handler
  //   isInDebugMode: true, // Set to `false` in production
  // );
  // NotificationService.scheduleMinNotificationTask(1, 0);

  ProviderContainer container = ProviderContainer();

  await NotificationService.scheduleDailyNotification(10, 30);
  runApp(
      const ProviderScope(child: MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'flutter project',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          // brightness: Brightness.dark,
            seedColor: Colors.white
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      home: const TabsScreen(),
    );
  }
}
